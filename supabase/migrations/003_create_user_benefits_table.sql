
CREATE TABLE user_benefits (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) NOT NULL,
    title TEXT NOT NULL,
    brand_id TEXT,
    company_id TEXT,
    benefit_text TEXT,
    notes TEXT,
    notify_before_days INTEGER,
    notify_at_hour INTEGER,
    expire_on TIMESTAMPTZ,
    is_used BOOLEAN DEFAULT false NOT NULL,
    tags TEXT[] NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    deleted_at TIMESTAMPTZ
);

ALTER TABLE user_benefits ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own benefits" ON user_benefits
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own benefits" ON user_benefits
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own benefits" ON user_benefits
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own benefits" ON user_benefits
    FOR DELETE USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_user_benefits_updated_at
    BEFORE UPDATE ON user_benefits
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
