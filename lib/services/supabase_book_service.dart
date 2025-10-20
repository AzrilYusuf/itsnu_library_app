import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itsnu_app/models/book_model.dart';

class SupabaseBookSErvice {
  static final SupabaseBookSErvice _instance =
      SupabaseBookSErvice._internal();
  factory SupabaseBookSErvice() => _instance;
  SupabaseBookSErvice._internal();

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Getter
  SupabaseClient get supabaseClient => _supabaseClient;
  User? get currentUser => _supabaseClient.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<List<BookModel>> getBooks() async {
    try {
      final List<Map<String, dynamic>> books = await _supabaseClient
          .from('books')
          .select()
          .order('created_at', ascending: false);
          return books.map((book) => BookModel.fromJson(book)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data buku: $e');
    }
  }

  Future<BookModel> getBookById(String id) async {
    try {
      final Map<String, dynamic> book = await _supabaseClient
          .from('books')
          .select()
          .eq('id', id)
          .single();
      return BookModel.fromJson(book);
    } catch (e) {
      throw Exception('Gagal mengambil data buku: $e');
    }
  }

  Future<BookModel> addBook(BookModel book) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      final Map<String, dynamic> response = await _supabaseClient
          .from('books')
          .insert(book.toJson())
          .select()
          .single();
      return BookModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal menambahkan data buku: $e');
    }
  }
}