// ignore_for_file: avoid_print
import 'dart:io';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import 'package:dotenv/dotenv.dart';

void main() async {
  try {
    // Load environment variables
    final env = DotEnv()..load(['./.env']);

    // Initialize Supabase client with service role key for admin operations
    final supabase = SupabaseClient(
      env['SUPABASE_URL']!,
      env['SUPABASE_SERVICE_ROLE_KEY'] ?? env['SUPABASE_ANON_KEY']!,
    );

    // Read JSON data
    final jsonFile = File('./stores_data.json');
    if (!await jsonFile.exists()) {
      print('Error: stores_data.json not found');
      exit(1);
    }

    final jsonContent = await jsonFile.readAsString();
    final List<dynamic> storesData = json.decode(jsonContent);

    print('Found ${storesData.length} stores to seed');

    // Insert stores data
    print('Inserting store data...');

    for (int i = 0; i < storesData.length; i++) {
      final store = storesData[i];

      try {
        await supabase.from('stores').insert({
          'name': store['name'],
          'store_brand': store['store_brand'],
          'address': store['address'],
          'latitude': store['latitude'],
          'longitude': store['longitude'],
          'phone': store['phone'],
          'business_hours': store['business_hours'],
          'store_tag': store['store_tag'],
          'company_id': store['company_id'],
        });

        print('Inserted store ${i + 1}/${storesData.length}: ${store['name']}');
      } catch (e) {
        print('Error inserting store ${store['name']}: $e');
      }
    }

    // Verify the data was inserted
    final result = await supabase.from('stores').select();
    print('Successfully seeded ${result.length} stores');
  } catch (e) {
    print('Error during seeding: $e');
    exit(1);
  }
}
