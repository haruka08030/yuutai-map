// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import 'package:dotenv/dotenv.dart';
// import 'package:path/path.dart' as p; // パス操作が必要な場合は追加

Future<void> main() async {
  try {
    // 1. 環境変数の読み込み
    final env = DotEnv()..load(['./.env']);

    final supabase = SupabaseClient(
      env['SUPABASE_URL']!,
      env['SUPABASE_SERVICE_ROLE_KEY'] ?? env['SUPABASE_ANON_KEY']!,
    );

    // 2. 読み込むフォルダの指定（Pythonの出力先に合わせる）
    final inputDir = Directory('./output_data');

    if (!await inputDir.exists()) {
      print('Error: Directory "${inputDir.path}" not found.');
      exit(1);
    }

    // フォルダ内のJSONファイルを取得
    final List<FileSystemEntity> files = inputDir
        .listSync()
        .where((entity) => entity is File && entity.path.endsWith('.json'))
        .toList();

    if (files.isEmpty) {
      print('No .json files found in "${inputDir.path}".');
      exit(0);
    }

    print('Found ${files.length} JSON files to process.');

    // 全体のカウンター
    int totalInserted = 0;
    int totalFailed = 0;

    // 3. ファイルごとのループ処理
    for (var entity in files) {
      final file = entity as File;
      final fileName = file.uri.pathSegments.last; // ファイル名取得

      print('\n--- Processing file: $fileName ---');

      try {
        final jsonContent = await file.readAsString();
        final List<dynamic> storesData = json.decode(jsonContent);

        print('Contains ${storesData.length} stores.');

        // ファイル内のデータごとのループ処理
        for (int i = 0; i < storesData.length; i++) {
          final store = storesData[i] as Map<String, dynamic>;

          try {
            // company_id など、DB側の必須カラムがJSONに含まれている前提です
            await supabase.from('stores').insert({
              'name': store['name'],
              'store_brand': store['store_brand'],
              'address': store['address'],
              'lat': store['lat'],
              'lng': store['lng'],
              'category_tag': store['category_tag'],
              'company_id': store['company_id'],
            });

            totalInserted++;
            // 進捗が見えるように出力（量が多い場合はコメントアウトしてもOK）
            print('Inserted: ${store['name']}');
          } catch (e) {
            totalFailed++;
            print('Error inserting "${store['name']}": $e');
          }
        }
      } catch (e) {
        print('Error reading file $fileName: $e');
      }
    }

    // 4. 最終結果表示
    print('\n========================================');
    print('All files processed.');
    print('Total Inserted: $totalInserted');
    print('Total Failed:   $totalFailed');
    print('========================================');
  } catch (e) {
    print('An unexpected error occurred: $e');
    exit(1);
  }
}
