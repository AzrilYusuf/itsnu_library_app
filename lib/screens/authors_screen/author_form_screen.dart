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
      _nameController.text = widget.author!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
      final AuthorProvider authorProvider = Provider.of<AuthorProvider>(context, listen: false);
      final bool res = await authorProvider.deleteAuthor(widget.author!.id!);

      if (!mounted) return;
      if (res) {
        Navigator.of(context).pop(true); // Indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus penulis: ${authorProvider.errorMessage}'),
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
        title: const Text("Author Form"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(child: Text("Author Form Screen")),
    );
  }
}
