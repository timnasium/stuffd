class Location {
  final int id;
  final String name;
  final String description;

  Location({
    required this.id,
    required this.name,
    required this.description,
  });



  Map<String, dynamic> toMap() {
    return {
      'id': id<=0?null:id,
      'name': name,
      'description': description,
    };
  }

  Location.fromDbMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'];


  @override
  String toString() {
    return 'Location{id: $id, name: $name, description: $description}';
  }
}