class Thing {
  final int id;
  final String name;
  final String normalName;
  final String description;
  final String brand;
  final String ean;
  final String upc;
  final String imageUrl;
  final int dateAdded;
  final int locationId;
  final int categoryId;

  Thing({
    required this.id,
    required this.name,
    required this.normalName,
    required this.description,
    required this.brand,
    required this.ean,
    required this.upc,
    required this.imageUrl,
    required this.dateAdded,
    required this.locationId,
    required this.categoryId,
  });


    // Convert a Thing into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id<=0?null:id,
      'name': name,
      'normalName':normalName,
      'description':description,
      'brand':brand,
      'ean':ean,
      'upc':upc,
      'imageUrl':imageUrl,
      'dateAdded':dateAdded,
      'locationId': locationId,
      'categoryId':categoryId,
    };
  }

  Thing.fromDbMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        normalName=map['normalName'],
        description=map['description'],
        brand=map['brand'],
        ean=map['ean'],
        upc=map['upc'],
        imageUrl=map['imageUrl'],
        dateAdded=map['dateAdded'],
        locationId = map['locationId'],
        categoryId=map['categoryId'];

  // Implement toString to make it easier to see information about
  // each Thing when using the print statement.
  @override
  String toString() {
    return 'Thing{id: $id, name: $name}';
  }
}