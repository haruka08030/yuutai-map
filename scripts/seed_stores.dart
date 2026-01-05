import 'dart:io';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  try {
    final env = DotEnv()..load(['./.env']);

    final supabase = SupabaseClient(
      env['SUPABASE_URL']!,
      env['SUPABASE_SERVICE_ROLE_KEY'] ?? env['SUPABASE_ANON_KEY']!,
    );

    final jsonFile = File('./stores_data.json');
    if (!await jsonFile.exists()) {
      print('Error: stores_data.json not found');
      exit(1);
    }

    final jsonContent = await jsonFile.readAsString();
    final List<dynamic> storesData = json.decode(jsonContent);

    print('Found ${storesData.length} stores to seed');

    print('Inserting store data...');

    for (int i = 0; i < storesData.length; i++) {
      final store = storesData[i];

      try {
        await supabase.from('stores').insert({
          'name': store['name'],
          'store_brand': store['store_brand'],
          'address': store['address'],
          'lat': store['lat'],
          'lng': store['lng'],
          'category_tag': store['category_tag'],
          'company_id': store['company_id'],
        });

        print('Inserted store ${i + 1}/${storesData.length}: ${store['name']}');
      } catch (e) {
        print('Error inserting store ${store['name']}: $e');
      }
    }

    final result = await supabase.from('stores').select();
    print('Successfully seeded ${result.length} stores');
  } catch (e) {
    print('Error during seeding: $e');
    exit(1);
  }
}
