import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:itsnu_app/models/author_model.dart';
import 'package:itsnu_app/providers/author_provider.dart';
import 'package:provider/provider.dart';

class AuthorFormScreen extends StatefulWidget {
  final AuthorModel? author; // Optional author for editing

  const AuthorFormScreen({this.author, super.key});

  @override
  State<AuthorFormScreen> createState() => _AuthorFormScreenState();
}

class _AuthorFormScreenState extends State<AuthorFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _selectedImageBytes;
  String? _currentPhotoUrl;

  bool _isLoading = false;
  bool get _isEditMode => widget.author != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _nameController.text = widget.author?.name ?? '';
      _currentPhotoUrl = widget.author!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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

  Future<void> _saveAuthor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authorProvider = Provider.of<AuthorProvider>(
        context,
        listen: false,
      );

      final AuthorModel newAuthor = AuthorModel(
        id: _isEditMode ? widget.author!.id : null,
        name: _nameController.text.trim(),
        createdAt: _isEditMode ? widget.author!.createdAt : null,
      );

      bool res;
      if (_isEditMode) {
        res = await authorProvider.updateAuthor(newAuthor, _selectedImageBytes);
      } else {
        res = await authorProvider.createAuthor(newAuthor, _selectedImageBytes);
      }

      if (!mounted) return;

      if (res) {
        Navigator.of(context).pop(true); // Indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal ${_isEditMode ? 'update' : 'membuat'} penulis.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteAuthor() async {
    if (!_isEditMode || widget.author?.id == null) return;

    // Show confirmation dialog
    final bool? isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${widget.author!.name}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
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
      final AuthorProvider authorProvider = Provider.of<AuthorProvider>(
        context,
        listen: false,
      );
      final bool res = await authorProvider.deleteAuthor(widget.author!.id!);

      if (!mounted) return;
      if (res) {
        Navigator.of(context).pop(true); // Indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gagal menghapus penulis: ${authorProvider.errorMessage}',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Penulis' : 'Tambah Penulis'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // If editing, show current photo or selected photo
              if (_isEditMode || _selectedImageBytes != null) ...[
                Center(
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: _currentPhotoUrl != null
                        ? NetworkImage(_currentPhotoUrl!)
                        : (_selectedImageBytes != null
                              ? MemoryImage(_selectedImageBytes!)
                              : null),
                    child: null,
                  ),
                ),

                const SizedBox(height: 16.0),
              ],

              TextFormField(
                controller: _nameController,
                enabled: !_isLoading, // Disable when loading
                decoration: const InputDecoration(
                  labelText: 'Nama Penulis',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama penulis wajib diisi.';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama penulis minimal 3 karakter.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16.0),

              // Upload Author Photo Button
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _selectImage,
                icon: const Icon(Icons.photo_camera),
                label: const Text('Unggah Foto Penulis'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),

              const SizedBox(height: 24.0),
              // Save Button
              SizedBox(
                height: 48.0,

                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveAuthor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        )
                      : Text(_isEditMode ? 'Update Penulis' : 'Simpan Penulis'),
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
                    foregroundColor: Colors.teal,
                    side: const BorderSide(color: Colors.teal),
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
                    onPressed: _isLoading ? null : _deleteAuthor,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          )
                        : const Text('Hapus Penulis'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
