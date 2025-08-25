import csv
import json
import requests
import firebase_admin
from firebase_admin import credentials, firestore

# --- 設定情報 ---
# ① your_company_id を、firebaseコンソールから取得した企業IDに置き換えてください。
YOUR_COMPANY_ID = "sldPwo2WC8PLlh5tT0Wi" 
# ② serviceAccountKey.json のパスを設定してください。
SERVICE_ACCOUNT_KEY_PATH = "serviceAccountKey.json"
# ③ Geocoding APIキーを設定してください。
GEOCODING_API_KEY = "AIzaSyBYveNSHy4H_W7k5jv5bSzlO8I67cAsgZ4" 

# --- Firebase Admin SDKの初期化 ---
try:
    cred = credentials.Certificate(SERVICE_ACCOUNT_KEY_PATH)
    firebase_admin.initialize_app(cred)
    db = firestore.client()
except Exception as e:
    print(f"Firebase Admin SDKの初期化に失敗しました: {e}")
    exit()

# --- ジオコーディングAPI関数 ---
def geocode_address(address):
    base_url = "https://maps.googleapis.com/maps/api/geocode/json"
    params = {
        "address": address,
        "key": GEOCODING_API_KEY,
        "language": "ja"
    }
    try:
        response = requests.get(base_url, params=params)
        response.raise_for_status()
        result = response.json()
        if result['status'] == 'OK':
            location = result['results'][0]['geometry']['location']
            return location['lat'], location['lng']
        else:
            print(f"ジオコーディングに失敗: {address}, Status: {result['status']}")
            return None, None
    except requests.exceptions.RequestException as e:
        print(f"APIリクエストエラー: {e}")
        return None, None

# --- CSVデータ（文字列） ---
csv_data = """store_name,address

"""

# --- メイン処理 ---
if __name__ == "__main__":
    import io
    csv_reader = csv.DictReader(io.StringIO(csv_data))
    
    parent_doc_ref = db.collection('companies').document(YOUR_COMPANY_ID)
    
    for row in csv_reader:
        store_name = row['store_name'].strip()
        address = row['address'].strip()

        if not store_name or not address:
            continue

        lat, lng = geocode_address(address)
        
        if lat is not None and lng is not None:
            location_data = {
                "store_name": store_name,
                "address": address,
                "latitude": lat,
                "longitude": lng,
            }
            # サブコレクションにドキュメントを追加
            parent_doc_ref.collection('locations').add(location_data)
            print(f"Successfully added: {store_name}")
        else:
            print(f"Failed to add: {store_name}")
            
    print("データ登録処理が完了しました。")
    