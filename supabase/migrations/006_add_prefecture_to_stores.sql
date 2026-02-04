-- Add prefecture (都道府県) for location filter
ALTER TABLE stores
ADD COLUMN IF NOT EXISTS prefecture TEXT;

CREATE INDEX IF NOT EXISTS idx_stores_prefecture ON stores(prefecture);

COMMENT ON COLUMN stores.prefecture IS '都道府県名（例: 東京都, 大阪府）。住所から抽出して格納。';
