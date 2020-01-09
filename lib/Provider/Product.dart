



import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class Product with ChangeNotifier{

  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;
  Product({this.id,this.title,this.description,this.imageUrl,this.price,this.isFavorite = false});

  Future<void> toggleIsFavorite(String token)async{

final oldFavorite = isFavorite;
    isFavorite = ! isFavorite;
    notifyListeners();

    final url = 'https://marketapp-fe785.firebaseio.com/products/$id.json?auth=$token';
    try{
 final response =  await http.patch(url,body:json.encode({
      'isFavorite':isFavorite
    }) );

 if(response.statusCode >=400) {
   isFavorite =oldFavorite;
   notifyListeners();

 }
  }catch(_){
      isFavorite =oldFavorite;
      notifyListeners();

    }
  }
}