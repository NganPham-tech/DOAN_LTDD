class Category {
  final int? categoryID;
  final String name;
  final String? description;
  final String colorCode;
  final String? icon;

  Category({
    this.categoryID,
    required this.name,
    this.description,
    this.colorCode = '#6c757d',
    this.icon,
  });

  Map<String, dynamic> toMap() {
    return {
      'CategoryID': categoryID,
      'Name': name,
      'Description': description,
      'ColorCode': colorCode,
      'Icon': icon,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryID: map['CategoryID'],
      name: map['Name'],
      description: map['Description'],
      colorCode: map['ColorCode'] ?? '#6c757d',
      icon: map['Icon'],
    );
  }

  Category copyWith({
    int? categoryID,
    String? name,
    String? description,
    String? colorCode,
    String? icon,
  }) {
    return Category(
      categoryID: categoryID ?? this.categoryID,
      name: name ?? this.name,
      description: description ?? this.description,
      colorCode: colorCode ?? this.colorCode,
      icon: icon ?? this.icon,
    );
  }
}
