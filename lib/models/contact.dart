import 'package:flutter/material.dart';

class Contact {
  int id;
  String name;
  String phoneNumber;
  String avatar;
  Contact({this.name, this.phoneNumber, this.avatar});
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["name"] = name;
    map["phoneNumber"] = phoneNumber;
    map["avatar"] = avatar;
    return map;
  }

  Contact.toObject(Map<String, dynamic> map) {
    id = map["id"];
    name = map["name"];
    phoneNumber = map["phoneNumber"];
    avatar = map["avatar"];
  }
}
