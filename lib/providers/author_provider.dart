import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:itsnu_app/models/author_model.dart';
import 'package:itsnu_app/services/supabase_author_service.dart';

class AuthorProvider extends ChangeNotifier {
  final SupabaseAuthorService _authorService = SupabaseAuthorService();

  List<AuthorModel> _authors = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<AuthorModel> get authors => _authors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Fetch all authors from the service
  Future<void> fetchAuthors() async {
    _setLoading(true);
    clearError();

    try {
      _authors = await _authorService.getAuthors();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchAllAuthorsName() async {
    _setLoading(true);
    clearError();

    try {
      _authors = await _authorService.getAllAuthorsName();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<AuthorModel?> getAuthorById(String id) async {
    _setLoading(true);
    clearError();

    try {
      return await _authorService.getAuthorById(id);
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createAuthor(AuthorModel author, Uint8List? fileBytes) async {
    _setLoading(true);
    clearError();

    try {
      final AuthorModel newAuthor = await _authorService.addAuthor(
        author,
        fileBytes,
      );

      _authors.insert(0, newAuthor); // Insert at the beginning of the list
      notifyListeners();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateAuthor(AuthorModel author, Uint8List? fileBytes) async {
    _setLoading(true);
    clearError();

    try {
      final AuthorModel updatedAuthor = await _authorService.updateAuthor(
        author,
        fileBytes,
      );
      // Search for the author in the list and update it
      final index = _authors.indexWhere((a) => a.id == updatedAuthor.id);
      // If found, update the author in the list
      if (index != -1) {
        _authors[index] = updatedAuthor;
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> deleteAuthor(String id) async {
    _setLoading(true);
    clearError();

    try {
      await _authorService.deleteAuthor(id);
      // Remove the author from the list
      _authors.removeWhere((a) => a.id == id);
      notifyListeners();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await fetchAuthors();
  }
}
