import 'dart:developer';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:mangodb/MangoDBModel.dart';
import 'package:mangodb/constant.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MangoDataBase {
  static var collection, db, status;

  static connect(BuildContext context,String url) async {
    try {
      // db = await Db.create(url);
      db = Db(url);
      await db.open();
      inspect(db);
      status = db.serverStatus();
      log('$status');
      collection = db.collection(COLLECTION_NAME);
      log('${await collection.find().toList()}');
      await showOkAlertDialog(
                context: context,
                title: 'Connection',
                message: 'Mongodb connection is established',
                canPop: true,
              );
    } catch (e) {
      await showOkAlertDialog(
                context: context,
                title: 'Connection Error',
                message: '$e',
                canPop: true,
              );
      log("Error : Connecting Mongodb :$e");
    }
  }

  static Future<String> insert(MangoDbModel data) async {
    try {
      var result = await collection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something went wrong while inserting data";
      }
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final arrylist = await collection.find().toList();
    return arrylist;
  }
}
