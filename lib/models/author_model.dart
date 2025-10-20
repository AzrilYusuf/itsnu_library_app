class AuthorModel {
  final String? id;
  final String name;
  final String? imageUrl;
  final DateTime? createdAt;

  AuthorModel({this.id, required this.name, this.imageUrl, this.createdAt});

  // factory constructor is for converting JSON to AuthorModel
  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // This method is for converting AuthorModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Method for updating AuthorModel
  AuthorModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    DateTime? createdAt,
  }) {
    return AuthorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Method for printing AuthorModel (used for debugging or logging)
  @override
  String toString() {
    return 'AuthorModel(id: $id, name: $name, imageUrl: $imageUrl, createdAt: $createdAt)';
  }

  // Method for comparing AuthorModel
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthorModel &&
        other.id == id &&
        other.name == name &&
        other.imageUrl == imageUrl &&
        other.createdAt == createdAt;
  }

  // Method for hashing AuthorModel that is used for comparing
  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ imageUrl.hashCode ^ createdAt.hashCode;
  }
}
