// Create an enum for book categories for error handling
enum BookCategory {
  fiction,
  // ignore: constant_identifier_names
  non_fiction,
  science,
  biography,
  history,
  education,
  fantasy;

  static BookCategory fromString(String value) =>
      BookCategory.values.firstWhere((e) => e.name == value);

  String get value => name;
}

class BookModel {
  final String? id;
  final String title;
  final String authorId;
  final String? imagePath;
  final BookCategory category;
  final DateTime createdAt;

  BookModel({
    this.id,
    required this.title,
    required this.authorId,
    this.imagePath,
    required this.category,
    required this.createdAt,
  });

  // factory constructor is for converting JSON to BookModel
  // NOTE: This is necessary because the API returns JSON
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      authorId: json['author_id'],
      imagePath: json['image_path'],
      category: BookCategory.fromString(json['category']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method for converting BookModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author_id': authorId,
      'image_path': imagePath,
      'category': category.value,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Method for updating BookModel
  BookModel copyWith({
    String? id,
    String? title,
    String? authorId,
    String? imagePath,
    BookCategory? category,
    DateTime? createdAt,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Method for converting BookModel to string
  @override // override is for debugging or logging
  String toString() {
    return 'BookModel(id: $id, title: $title, authorId: $authorId, imagePath: $imagePath, category: $category, createdAt: $createdAt)';
  }

  // Method for comparing two BookModel objects
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookModel &&
          id == other.id &&
          title == other.title &&
          authorId == other.authorId &&
          imagePath == other.imagePath &&
          category == other.category &&
          createdAt == other.createdAt;

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        authorId.hashCode ^
        imagePath.hashCode ^
        category.hashCode ^
        createdAt.hashCode;
  }
}
