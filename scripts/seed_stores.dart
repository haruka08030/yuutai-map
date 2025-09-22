import 'dart:io';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

void main() async {
  try {
    // Load environment variables
    await dotenv.load(fileName: '.env');
    
    // Initialize Supabase
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    
    final supabase = Supabase.instance.client;
    
    // Read JSON data
    final jsonFile = File('stores_data.json');
    if (!await jsonFile.exists()) {
      Logger('seed_stores').warning('Error: stores_data.json not found');
      exit(1);
    }
    
    final jsonContent = await jsonFile.readAsString();
    final List<dynamic> storesData = json.decode(jsonContent);
    
    Logger('seed_stores').info('Found ${storesData.length} stores to seed');
    
    // Clear existing data (optional)
    Logger('seed_stores').info('Clearing existing stores data...');
    await supabase.from('stores').delete().neq('id', 0);
    
    // Insert stores data
    Logger('seed_stores').info('Inserting store data...');
    
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
          'is_active': true,
        });
        
        Logger('seed_stores').info('Inserted store ${i + 1}/${storesData.length}: ${store['name']}');
        
      } catch (e) {
        Logger('seed_stores').warning('Error inserting store ${store['name']}: $e');
      }
    }
    
    // Verify the data was inserted
    final result = await supabase.from('stores').select('count').count();
    Logger('seed_stores').info('Successfully seeded ${result.count} stores');
    
  } catch (e) {
    Logger('seed_stores').warning('Error during seeding: $e');
    exit(1);
  }
}