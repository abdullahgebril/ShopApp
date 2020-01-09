import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';
class Auth with ChangeNotifier {
  String _token;
  String _userID;
  DateTime _dateTime;

  bool get isAuth {
    return token !=null;
  }
  String get token {
    if(_dateTime!=null&& _dateTime.isAfter(DateTime.now())&&_token !=null) {
      return _token;
    }
    return null;
  }
  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDtrs-C0JXvH-OcYISVIKQClAa7aIPP3h8';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );

      if (json.decode(response.body)['error']!=null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = json.decode(response.body)['idToken'];
      _userID = json.decode(response.body)['localId'];
      _dateTime = DateTime.now().add(Duration(seconds: int.parse(json.decode(response.body)['expiresIn']))) ;
      notifyListeners();
    }catch(error){
     throw error;
    }


  }

  Future<void> signin(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDtrs-C0JXvH-OcYISVIKQClAa7aIPP3h8';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );

      if (json.decode(response.body)['error'] != null) {
        throw HttpException(json.decode(response.body)['error']['message']);
      }
      _token = json.decode(response.body)['idToken'];
      _userID = json.decode(response.body)['localId'];
      _dateTime = DateTime.now().add(Duration(seconds: int.parse(json.decode(response.body)['expiresIn']))) ;
      notifyListeners();
    }

    catch(error){
      throw error;
    }


  }
}
