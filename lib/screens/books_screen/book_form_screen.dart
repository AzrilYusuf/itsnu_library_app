import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itsnu_app/models/author_model.dart';
import 'package:itsnu_app/models/book_model.dart';
import 'package:itsnu_app/providers/author_provider.dart';
import 'package:itsnu_app/providers/book_provider.dart';
import 'package:provider/provider.dart';

class BookFormScreen extends StatefulWidget {
  final BookModel? book;

  const BookFormScreen({this.book, super.key});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  String? _selectedAuthorId;
  BookCategory? _selectedCategory;
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _selectedImageBytes;
  String? _currentImageUrl;

  bool _isLoading = false;
  bool get _isEditMode => widget.book != null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });

    if (_isEditMode) {
      _titleController.text = widget.book!.title;
      _selectedAuthorId = widget.book!.authorId;
      _selectedCategory = widget.book!.category;
      _currentImageUrl = widget.book!.imageUrl;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final AuthorProvider authorProvider = Provider.of<AuthorProvider>(
      context,
      listen: false,
    );

    if (authorProvider.authors.isNotEmpty) return;
    await authorProvider.fetchAuthors();
  }

  // Method to select image from camera or gallery
  Future<void> _selectImage() async {
    try {
      // Show option dialog
      final ImageSource? selectedSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Pilih sumber foto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
            ],
          ),
        ),
      );

      if (selectedSource == null) return;

      // Pick image
      final XFile? selectedImage = await _imagePicker.pickImage(
        source: selectedSource,
      );

      if (selectedImage == null) return;

      final Uint8List imageBytes = await selectedImage.readAsBytes();
      setState(() {
        _selectedImageBytes = imageBytes;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memilih gambar: $e')));
    }
  }

  Future<void> _saveBook() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final BookProvider bookProvider = Provider.of<BookProvider>(
        context,
        listen: false,
      );

      // Create or update book
      final BookModel newBook = BookModel(
        id: _isEditMode ? widget.book!.id : null,
        title: _titleController.text.trim(),
        authorId: _selectedAuthorId!,
        category: _selectedCategory!,
      );

      bool res;
      if (_isEditMode) {
        res = await bookProvider.updateBook(newBook, _selectedImageBytes);
      } else {
        res = await bookProvider.createBook(newBook, _selectedImageBytes);
      }

      if (!mounted) return;

      if (res) {
        Navigator.of(context).pop(true); // Indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal ${_isEditMode ? 'update' : 'membuat'} buku: ${bookProvider.errorMessage}',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
        bookProvider.clearError();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteBook() async {
    if (!_isEditMode || widget.book?.id == null) return;

    // Show confirmation dialog
    final bool? isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${widget.book!.title}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Hapus',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    // Check if deletion is confirmed
    if (isConfirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (!mounted) return;
      final BookProvider bookProvider = Provider.of<BookProvider>(
        context,
        listen: false,
      );
      final bool res = await bookProvider.deleteBook(widget.book!.id!);

      if (!mounted) return;
      if (res) {
        Navigator.of(context).pop(true); // Indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menghapus buku: ${bookProvider.errorMessage}',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
        bookProvider.clearError();
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error: $e',
            style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<AuthorModel> authors = Provider.of<AuthorProvider>(
      context,
    ).authors; // listen: true

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book == null ? 'Tambah Buku' : 'Edit Buku'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // If editing, show current image
                if (_isEditMode || _selectedImageBytes != null) ...[
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      backgroundImage: _currentImageUrl != null
                          ? NetworkImage(_currentImageUrl!)
                          : (_selectedImageBytes != null
                                ? MemoryImage(_selectedImageBytes!)
                                : null),
                      child:
                          _currentImageUrl == null &&
                              _selectedImageBytes == null
                          ? Icon(Icons.book, size: 50.0, color: Theme.of(context).colorScheme.secondary)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],

                TextFormField(
                  controller: _titleController,
                  enabled: !_isLoading, // Disable when loading
                  decoration: InputDecoration(
                    labelText: 'Judul Buku',
                    labelStyle: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.0,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.book,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Judul buku wajib diisi.';
                    }
                    if (value.trim().length < 3) {
                      return 'Judul buku minimal 3 karakter.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // Author dropdown
                DropdownButtonFormField<String>(
                  initialValue: _isEditMode
                      ? widget.book!.authorId
                      : _selectedAuthorId,
                  decoration: InputDecoration(
                    labelText: 'Pilih Penulis',
                    labelStyle: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onChanged: (v) => setState(() => _selectedAuthorId = v),
                  items: authors
                      .map(
                        (a) =>
                            DropdownMenuItem(value: a.id, child: Text(a.name)),
                      )
                      .toList(),
                ),

                const SizedBox(height: 16.0),

                // Category dropdown
                DropdownButtonFormField<BookCategory>(
                  initialValue: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Pilih Kategori',
                    labelStyle: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    // Focused border
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2.0,
                      ),
                    ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onChanged: (v) => setState(() => _selectedCategory = v),
                  items: BookCategory.values
                      .map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.name)),
                      )
                      .toList(),
                ),

                const SizedBox(height: 16.0),

                // Upload Book Cover Button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _selectImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Unggah Cover Buku'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                // Save Button
                SizedBox(
                  height: 48.0,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.inversePrimary,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          )
                        : Text(_isEditMode ? 'Update Buku' : 'Simpan Buku'),
                  ),
                ),

                const SizedBox(height: 12.0),

                // Cancel Button
                SizedBox(
                  height: 48.0,
                  child: OutlinedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),

                if (_isEditMode) ...[
                  const SizedBox(height: 12.0),

                  // Delete Button
                  SizedBox(
                    height: 48.0,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _deleteBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).colorScheme.secondary,
                              ),
                            )
                          : const Text('Hapus Buku'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
