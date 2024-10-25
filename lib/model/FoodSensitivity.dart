// ignore_for_file: file_names

class FoodSensitivity {
  final int id;
  final int userId;
  final int foodContentId;
  final bool isAllergic;

  FoodSensitivity({
    required this.id,
    required this.userId,
    required this.foodContentId,
    required this.isAllergic,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'food_content_id': foodContentId,
      'is_allergic': isAllergic,
    };
  }
}
