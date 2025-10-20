import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:itsnu_app/models/book_model.dart';
import 'package:itsnu_app/services/supabase_book_service.dart';

class BookProvider extends ChangeNotifier {
  final SupabaseBookService _bookService = SupabaseBookService();

  List<BookModel> _books = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<BookModel> get books => _books;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;

  // Fetch all books from the service
  Future<void> fetchBooks() async {
    _setLoading(true);
    clearError();

    try {
      _books = await _bookService.getBooks();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<BookModel?> getBookById(String id) async {
    _setLoading(true);
    clearError();
    
    try {
      return await _bookService.getBookById(id);
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createBook(BookModel book, Uint8List? fileBytes) async {
    _setLoading(true);
    clearError();
    
    try {
      final BookModel newBook = await _bookService.addBook(
        book,
        fileBytes,
      );
      _books.insert(0, newBook); // Insert at the beginning of the list
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateBook(BookModel book, Uint8List? fileBytes) async {
    _setLoading(true);
    clearError();
    
    try {
      final BookModel updatedBook = await _bookService.updateBook(
        book,
        fileBytes,
      );
      // Search for the book in the list and update it
      final index = _books.indexWhere((a) => a.id == updatedBook.id);
      // If found, update the book in the list
      if (index != -1) {
        _books[index] = updatedBook;
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

  Future<bool> deleteBook(String id) async {
    _setLoading(true);
    clearError();
    
    try {
      await _bookService.deleteBook(id);
      // Remove the book from the list
      _books.removeWhere((a) => a.id == id);
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
    await fetchBooks();
  }
}