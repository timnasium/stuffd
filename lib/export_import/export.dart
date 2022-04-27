class ExportItem {
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
  final String locationName;
  final int categoryId;
  final String categoryName;

  ExportItem({
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
    required this.locationName,
    required this.categoryId,
    required this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id <= 0 ? null : id,
      'name': name,
      'normalName': normalName,
      'description': description,
      'brand': brand,
      'ean': ean,
      'upc': upc,
      'imageUrl': imageUrl,
      'dateAdded': dateAdded,
      'locationId': locationId,
      'locationName': locationId <= 0 ? '' : locationName,
      'categoryId': categoryId,
      'categoryName': categoryId <= 0 ? '' : categoryName,
    };
  }

  ExportItem.fromDbMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        normalName = map['normalName'],
        description = map['description'],
        brand = map['brand'],
        ean = map['ean'],
        upc = map['upc'],
        imageUrl = map['imageUrl'],
        dateAdded = map['dateAdded'],
        locationId = map['locationId'],
        locationName = map['locationName'],
        categoryId = map['categoryId'],
        categoryName = map['categoryName'];

  List<dynamic> get csvRow => [
        id,
        name,
        normalName,
        description,
        brand,
        ean,
        upc,
        imageUrl,
        dateAdded,
        locationId,
        locationName,
        categoryId,
        categoryName
      ];
      List<dynamic> get csvHeaderRow => [
        'id',
        'name',
        'normalName',
        'description',
        'brand',
        'ean',
        'upc',
        'imageUrl',
        'dateAdded',
        'locationId',
        'locationName',
        'categoryId',
        'categoryName'
      ];
}

