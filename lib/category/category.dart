class Category {
  final int id;
  final String name;
  final String matches;

  Category({
    required this.id,
    required this.name,
    required this.matches,
  });



  Map<String, dynamic> toMap() {
    return {
      'id': id<=0?null:id,
      'name': name,
      'matches': matches,
    };
  }

  Category.fromDbMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        matches = map['matches'];


  @override
  String toString() {
    return 'Category{id: $id, name: $name, matches: $matches}';
  }
}