
import 'package:json_annotation/json_annotation.dart';
import 'package:stuffd/thing/upc_item.dart';

part 'upc_response.g.dart';

@JsonSerializable()
class UpcResponse {
  String? code;
  int? total;
  int? offset;
  List<Item>? items;

  UpcResponse();
  factory UpcResponse.fromJson(Map<String, dynamic> json) => _$UpcResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpcResponseToJson(this);

}
