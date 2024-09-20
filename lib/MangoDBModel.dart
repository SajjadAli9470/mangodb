import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

MangoDbModel mangoDbModelFromJson(String str) =>
    MangoDbModel.fromJson(json.decode(str));

String mangoDbModelToJson(MangoDbModel data) => jsonEncode(data.toJson());

class MangoDbModel {
  ObjectId id;
  String firstname;
  String lastName;
  String address;

  MangoDbModel({
    required this.id,
    required this.firstname,
    required this.lastName,
    required this.address,
  });

  factory MangoDbModel.fromJson(Map<String, dynamic> json) => MangoDbModel(
      id: json["_id"],
      firstname: json["_firstname"],
      lastName: json["_lastName"],
      address: json["_addres"]);

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_firstname": firstname,
        "_lastName": lastName,
        "_addres": address,
      };
}
