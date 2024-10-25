// food_model.dart
// ignore_for_file: file_names

class Food {
  final int id;
  final String name;
  final String image;
  final List<int> contents;

  Food({
    required this.id,
    required this.name,
    required this.image,
    required this.contents,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      contents: List<int>.from(json['contents']),
    );
  }
}
