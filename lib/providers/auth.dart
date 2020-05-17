import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_Exceptions.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBCeugnCT0l6j1pXuMKisqF2vlW2rT9YdQ';
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } on HttpException catch (error) {
      var errmsg = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errmsg = 'This email is already in use';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errmsg = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errmsg = 'This password is too weak';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errmsg = 'Email could not be found';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errmsg = 'Invalid password';
      }
      HttpException(errmsg);
    } catch (error) {
      HttpException(error);
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}