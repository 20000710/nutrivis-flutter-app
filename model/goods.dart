import 'package:cloud_firestore/cloud_firestore.dart';

class Goods{
  String? goodsID;
  String? name;
  String? description;
  Timestamp? createdAt;
  String? imageUrl;

  Goods({
    this.goodsID,
    this.name,
    this.description,
    this.createdAt,
    this.imageUrl
  });

  Goods.fromJson(Map<String, dynamic> json){
    goodsID = json["goods_id"];
    name = json["name"];
    description = json["description"];
    createdAt = json["created_at"];
    imageUrl = json["image_url"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["goods_id"] = goodsID;
    data["name"] = name;
    data["description"] = description;
    data["created_at"] = createdAt;
    data["imageUrl"] = imageUrl;

    return data;
  }
}

