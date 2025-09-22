-- Create stores table for storing store information
CREATE TABLE IF NOT EXISTS stores (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    store_brand VARCHAR(255),
    address TEXT NOT NULL,
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    phone VARCHAR(50),
    business_hours TEXT,
    store_tag VARCHAR(100),
    company_id VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create index for location-based queries
CREATE INDEX IF NOT EXISTS idx_stores_location ON stores (latitude, longitude);

-- Create index for store_tag queries
CREATE INDEX IF NOT EXISTS idx_stores_tag ON stores (store_tag);

-- Create index for company_id queries
CREATE INDEX IF NOT EXISTS idx_stores_company_id ON stores (company_id);

-- Enable Row Level Security
ALTER TABLE stores ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all users to read stores
CREATE POLICY "Enable read access for all users" ON stores
    FOR SELECT USING (true);

-- Create policy to allow authenticated users to insert stores
CREATE POLICY "Enable insert for authenticated users" ON stores
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Create policy to allow authenticated users to update stores
CREATE POLICY "Enable update for authenticated users" ON stores
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_stores_updated_at
    BEFORE UPDATE ON stores
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();