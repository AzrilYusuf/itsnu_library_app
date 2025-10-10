class AuthorModel {
  final String id;
  final String name;
  final String imagePath;

  AuthorModel({required this.id, required this.name, required this.imagePath});

  // factory constructor is for converting JSON to AuthorModel
  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      id: json['id'],
      name: json['name'],
      imagePath: json['image_path'],
    );
  }

  // This method is for converting AuthorModel to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image_path': imagePath};
  }


  // Method for updating AuthorModel
  AuthorModel copyWith({String? id, String? name, String? imagePath}) {
    return AuthorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  // Method for printing AuthorModel (used for debugging or logging)
  @override
  String toString() {
    return 'AuthorModel(id: $id, name: $name, imagePath: $imagePath)';
  }

  // Method for comparing AuthorModel
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthorModel &&
        other.id == id &&
        other.name == name &&
        other.imagePath == imagePath;
  }

  // Method for hashing AuthorModel that is used for comparing
  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ imagePath.hashCode;
  }
}
