import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itsnu_app/models/book_model.dart';

class SupabaseBookService {
  static final SupabaseBookService _instance = SupabaseBookService._internal();
  factory SupabaseBookService() => _instance;
  SupabaseBookService._internal();

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

  Future<BookModel> addBook(BookModel book, Uint8List? fileBytes) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      final Map<String, dynamic> response = await _supabaseClient
          .from('books')
          .insert(book.toJson())
          .select()
          .single();
      final BookModel newBook = BookModel.fromJson(response);

      // If fileBytes is not null, upload book image
      if (fileBytes != null) {
        // Upload book image to storage
        await _uploadBookImage(fileBytes, newBook.id!);
      }

      return newBook;
    } catch (e) {
      throw Exception('Gagal menambahkan data buku: $e');
    }
  }

  // Upload book image to Supabase Storage
  Future<bool> _uploadBookImage(Uint8List fileBytes, String bookId) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      // Create unique filename for book
      final String fileName =
          '${bookId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // Define book file path
      final String filePath = 'cover-images/$fileName';

      // Upload file to 'assets' bucket
      final String res = await _supabaseClient.storage
          .from('assets')
          .uploadBinary(filePath, fileBytes);

      if (res.isEmpty) {
        throw Exception('Upload gagal: Gagal mengunggah gambar buku ke server');
      }

      // Get file URL
      final String fileUrl = _supabaseClient.storage
          .from('assets')
          .getPublicUrl(filePath);

      // Update book image (in book table)
      await _updateBookImage(bookId, fileUrl);

      return true;
    } catch (e) {
      throw Exception('Gagal mengunggah gambar buku: $e');
    }
  }

  // Update book image_url in database
  Future<void> _updateBookImage(String bookId, String fileUrl) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      final Map<String, dynamic> res = await _supabaseClient
          .from('books')
          .update({'image_url': fileUrl})
          .eq('id', bookId)
          .select()
          .single();

      if (res.isEmpty || res['image_url'] != fileUrl) {
        throw Exception('Update gagal: Gagal memperbarui URL gambar buku');
      }
    } catch (e) {
      throw Exception('Gagal memperbarui gambar buku: $e');
    }
  }
}
