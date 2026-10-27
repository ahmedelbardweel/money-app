import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://kapktnxqachedzmgwhba.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImthcGt0bnhxYWNoZWR6bWd3aGJhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMxMDUyNTksImV4cCI6MjEwODY4MTI1OX0.Cvns0KWovvqq3G2hr9vFSP1eWZFq1mB6GvlK0U4GJ7w';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      // ignore: deprecated_member_use
      anonKey: anonKey,
    );
  }
}
