import 'package:json_annotation/json_annotation.dart';
import 'package:stuffd/thing/thing.dart';
import 'package:stuffd/utils/database_manager.dart';

part 'upc_item.g.dart';

@JsonSerializable()
class Item {
  String? ean;
  String? title;
  String? description;
  String? upc;
  String? brand;
  String? model;
  String? color;
  String? size;
  String? dimension;
  String? weight;
  String? category;
  double? lowestRecordedPrice;
  double? highestRecordedPrice;
  List<String>? images;
  //List<Offers>? offers;
  String? asin;
  String? elid;

  Item();
  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);

  Future<Thing> toThing() async {
    var name = cleanName(this.title!);
    var imgUrl='';
    if(this.images!.isNotEmpty){
      imgUrl=this.images![0];
    }
    var catId =await findCategory(this.category!);
    return new Thing(
        id: 0,
        name: name,
        normalName: normalizeName(name),
        description: this.description ?? "",
        brand: this.brand ?? "",
        ean: this.ean ?? "",
        upc: this.upc ?? "",
        imageUrl: imgUrl,
        dateAdded:DateTime.now().millisecondsSinceEpoch,
        locationId: 0,
        categoryId: catId);
  }

//Remove known patterns from title/name
  static String cleanName(String name) {
    name = name.split(" (")[0];
    name = name.split(" -")[0];
    name = name.split(" [")[0];
    return name;
  }

  static String normalizeName(String name) {
    //TODO: strip out "the", "a", "an"...
    return name;
  }

  static Future<int> findCategory(String t) async {

   var db = DatabaseManager.instance;
  var cats = await db.getCategoriesByType(t);
  if(cats.isNotEmpty){
    return cats[0].id;
  }
    return 0;
  }
}
