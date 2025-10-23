import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:itsnu_app/models/author_model.dart';

class SupabaseAuthorService {
  static final SupabaseAuthorService _instance =
      SupabaseAuthorService._internal();
  factory SupabaseAuthorService() => _instance;
  SupabaseAuthorService._internal();

  final SupabaseClient _supabaseClient = Supabase.instance.client;

  // Getter
  SupabaseClient get supabaseClient => _supabaseClient;
  User? get currentUser => _supabaseClient.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<List<AuthorModel>> getAuthors() async {
    try {
      final List<Map<String, dynamic>> response = await _supabaseClient
          .from('authors')
          .select()
          .order('name', ascending: true);
      return response.map((res) => AuthorModel.fromJson(res)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data penulis: $e');
    }
  }

  Future<AuthorModel> getAuthorById(String id) async {
    try {
      final Map<String, dynamic> response = await _supabaseClient
          .from('authors')
          .select()
          .eq('id', id)
          .single();
      return AuthorModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal mengambil data penulis: $e');
    }
  }

  Future<AuthorModel> addAuthor(
    AuthorModel author,
    Uint8List? fileBytes,
  ) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      final Map<String, dynamic> response = await _supabaseClient
          .from('authors')
          .insert({'name': author.name})
          .select()
          .single();
      final AuthorModel newAuthor = AuthorModel.fromJson(response);

      // If fileBytes is not null, upload author image
      if (fileBytes != null) {
        // Upload author image to storage
        await _uploadAuthorImage(fileBytes, newAuthor.id!);
      }

      return newAuthor;
    } catch (e) {
      throw Exception('Gagal menambahkan data penulis: $e');
    }
  }

  // Upload author image to Supabase Storage
  Future<bool> _uploadAuthorImage(Uint8List fileBytes, String authorId) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      // Create unique filename for author
      final String fileName =
          '${authorId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      // Define author file path
      final String filePath = 'author-profile-images/$fileName';

      // Upload file to 'assets' bucket
      final String res = await _supabaseClient.storage
          .from('assets')
          .uploadBinary(filePath, fileBytes);

      if (res.isEmpty) {
        throw Exception('Upload gagal: Gagal mengunggah gambar ke server');
      }

      // Get file URL
      final String fileUrl = _supabaseClient.storage
          .from('assets')
          .getPublicUrl(filePath);

      // Update author image_url in database
      await _updateAuthorImage(authorId, fileUrl);

      return true;
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  // Update author image_url in database
  Future<void> _updateAuthorImage(String authorId, String fileUrl) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      final Map<String, dynamic> res = await _supabaseClient
          .from('authors')
          .update({'image_url': fileUrl})
          .eq('id', authorId)
          .select()
          .single();

      // If res is null then throw exception
      if (res.isEmpty || res['image_url'] == fileUrl) {
        throw Exception('Update gagal: Gagal memperbarui URL gambar penulis');
      }
    } catch (e) {
      throw Exception('Gagal menyimpan gambar: $e');
    }
  }

  // Update Author data with optional image update
  Future<AuthorModel> updateAuthor(
    AuthorModel author,
    Uint8List? fileBytes,
  ) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      if (author.id == null) {
        throw Exception('ID penulis tidak ditemukan');
      }

      // If new image is provided, upload it
      if (fileBytes != null) {
        // Upload author image to storage
        final res = await _uploadAuthorImage(fileBytes, author.id!);

        if (author.imageUrl != null && res) {
          // Delete existing image
          await _deleteAuthorImageFromBucketOnly(author.id!);
        }
      }

      // Preventing empty strings from being updated
      final Map<String, dynamic> data = {
        if (author.name.trim().isNotEmpty) 'name': author.name,
        // if (author.imageUrl != null && author.imageUrl!.trim().isNotEmpty)
        //   'image_url': author.imageUrl,
      };

      final Map<String, dynamic> response = await _supabaseClient
          .from('authors')
          .update(data)
          .eq('id', author.id!)
          .select()
          .single();

      return AuthorModel.fromJson(response);
    } catch (e) {
      throw Exception('Gagal update data penulis: $e');
    }
  }

  // Delete author image from Supabase Storage only (without updating database)
  Future<void> _deleteAuthorImageFromBucketOnly(String authorId) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      // Get author data
      final AuthorModel author = await getAuthorById(authorId);
      if (author.imageUrl == null) {
        throw Exception('Tidak ada gambar untuk dihapus');
      }

      // Get author image url
      final String imageUrl = author.imageUrl!;
      final String filePath = imageUrl.split('/assets/').last;

      // Delete image from storage
      await _supabaseClient.storage.from('assets').remove([filePath]);
    } catch (e) {
      throw Exception('Gagal menghapus gambar: $e');
    }
  }

  // Delete author image from Supabase Storage and update database
  Future<void> deleteAuthorImage(String authorId) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      // Get author data
      final AuthorModel author = await getAuthorById(authorId);

      // Get author image url
      final String? imageUrl = author.imageUrl;

      // if imageUrl is null or empty, return; (nothing to do)
      if (imageUrl == null || imageUrl.trim().isEmpty) return;

      final String filePath = imageUrl.split('/assets/').last;

      // Delete image from storage
      await _supabaseClient.storage.from('assets').remove([filePath]);

      // Update author image_url in database to null
      await _supabaseClient
          .from('authors')
          .update({'image_url': null})
          .eq('id', authorId);
    } catch (e) {
      throw Exception('Gagal menghapus gambar: $e');
    }
  }

  // Delete Author data along with image from storage
  Future<void> deleteAuthor(String id) async {
    try {
      if (!isAuthenticated) {
        throw Exception('User belum login');
      }

      await deleteAuthorImage(id);
      await _supabaseClient.from('authors').delete().eq('id', id);
    } catch (e) {
      throw Exception('Gagal menghapus data penulis: $e');
    }
  }
}
