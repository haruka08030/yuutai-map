
CREATE TABLE users_yuutai (
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
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

ALTER TABLE users_yuutai ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own benefits" ON users_yuutai
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own benefits" ON users_yuutai
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own benefits" ON users_yuutai
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own benefits" ON users_yuutai
    FOR DELETE USING (auth.uid() = user_id);

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$ LANGUAGE 'plpgsql';

CREATE TRIGGER update_users_yuutai_updated_at
    BEFORE UPDATE ON users_yuutai
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
