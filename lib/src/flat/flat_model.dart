class FlatModel {
  final String title;
  final String description;
  final String address;
  final int id;

  FlatModel({
    required this.title,
    required this.description,
    required this.address,
    this.id = 0,
  });

  factory FlatModel.fromJson(Map<String, dynamic> json) {
    return FlatModel(
      title: json['title'],
      description: json['description'],
      address: json['address'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'address': address,
      'id': id,
    };
  }
}
