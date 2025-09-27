-- Create companies table for storing company information
CREATE TABLE IF NOT EXISTS companies (
    id SERIAL PRIMARY KEY,
    company_code VARCHAR(10) UNIQUE NOT NULL,  -- 証券コード
    company_name VARCHAR(100) NOT NULL,        -- 企業名
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create shareholder_benefits table
CREATE TABLE IF NOT EXISTS shareholder_benefits (
    id SERIAL PRIMARY KEY,
    company_id uuid REFERENCES companies(id),
    benefit_type VARCHAR(50) NOT NULL,         -- 優待種別（買い物券、割引券等）
    benefit_value INTEGER,                     -- 優待券面額（円）
    validity_start_date DATE,                  -- 有効期間開始
    validity_end_date DATE,                    -- 有効期間終了
    is_active BOOLEAN DEFAULT TRUE,            -- 有効/無効フラグ
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Update stores table structure to match the design
ALTER TABLE stores 
    ALTER COLUMN name TYPE VARCHAR(100),
    ADD COLUMN IF NOT EXISTS store_brand VARCHAR(50),
    ADD COLUMN IF NOT EXISTS store_tag VARCHAR(10),
    ALTER COLUMN latitude TYPE DECIMAL(10, 8),
    ALTER COLUMN longitude TYPE DECIMAL(11, 8),
    ALTER COLUMN phone TYPE VARCHAR(20),
    ADD COLUMN IF NOT EXISTS is_active BOOLEAN DEFAULT TRUE;

-- Create benefit_store_mappings table
CREATE TABLE IF NOT EXISTS benefit_store_mappings (
    id SERIAL PRIMARY KEY,
    benefit_id INTEGER REFERENCES shareholder_benefits(id),
    store_id INTEGER REFERENCES stores(id),
    usage_conditions TEXT,                     -- 利用条件
    discount_rate DECIMAL(5,2),                -- 割引率（%）
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(benefit_id, store_id)
);

-- Create future expansion tables
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE,
    username VARCHAR(50),
    password_hash VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS favorites (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    benefit_id INTEGER REFERENCES shareholder_benefits(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, benefit_id)
);

-- Create indexes for performance
-- 企業検索用
CREATE INDEX IF NOT EXISTS idx_companies_code ON companies(company_code);
CREATE INDEX IF NOT EXISTS idx_companies_name ON companies(company_name);

-- 株主優待検索用
CREATE INDEX IF NOT EXISTS idx_benefits_company ON shareholder_benefits(company_id);
CREATE INDEX IF NOT EXISTS idx_benefits_type ON shareholder_benefits(benefit_type);
CREATE INDEX IF NOT EXISTS idx_benefits_active ON shareholder_benefits(is_active);

-- 店舗検索用（地理的検索）
CREATE INDEX IF NOT EXISTS idx_stores_location ON stores(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_stores_tag ON stores(store_tag);
CREATE INDEX IF NOT EXISTS idx_stores_brand ON stores(store_brand);

-- 関連テーブル検索用
CREATE INDEX IF NOT EXISTS idx_mappings_benefit ON benefit_store_mappings(benefit_id);
CREATE INDEX IF NOT EXISTS idx_mappings_store ON benefit_store_mappings(store_id);

-- Enable Row Level Security
ALTER TABLE companies ENABLE ROW LEVEL SECURITY;
ALTER TABLE shareholder_benefits ENABLE ROW LEVEL SECURITY;
ALTER TABLE benefit_store_mappings ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- Create policies for companies
CREATE POLICY "Enable read access for all users" ON companies
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users" ON companies
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users" ON companies
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Create policies for shareholder_benefits
CREATE POLICY "Enable read access for all users" ON shareholder_benefits
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users" ON shareholder_benefits
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users" ON shareholder_benefits
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Create policies for benefit_store_mappings
CREATE POLICY "Enable read access for all users" ON benefit_store_mappings
    FOR SELECT USING (true);

CREATE POLICY "Enable insert for authenticated users" ON benefit_store_mappings
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Enable update for authenticated users" ON benefit_store_mappings
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Create policies for users (authenticated users can only see/edit their own data)
CREATE POLICY "Users can view own profile" ON users
    FOR SELECT USING (auth.uid()::text = id::text);

CREATE POLICY "Users can update own profile" ON users
    FOR UPDATE USING (auth.uid()::text = id::text);

-- Create policies for favorites (authenticated users can only see/edit their own favorites)
CREATE POLICY "Users can view own favorites" ON favorites
    FOR SELECT USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can insert own favorites" ON favorites
    FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can delete own favorites" ON favorites
    FOR DELETE USING (auth.uid()::text = user_id::text);

-- Create triggers for updated_at
CREATE TRIGGER update_companies_updated_at
    BEFORE UPDATE ON companies
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_shareholder_benefits_updated_at
    BEFORE UPDATE ON shareholder_benefits
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();