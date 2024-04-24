import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/data/store.dart';
import 'package:shop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  String? _email;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token! : null;
  }

  String? get email {
    return isAuth ? _email! : null;
  }

  String? get userId {
    return isAuth ? _userId! : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:${urlSegment}?key=AIzaSyBQTE9Sx2eFFEjIQ9hL0gUIdQSM06VURE8';
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true,
      }),
    );
    final body = json.decode(response.body);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _userId = body['localId'];
      _email = body['email'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );
      Store.saveMap('userData', {
        'token': _token,
        'userId': _userId,
        'email': _email,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;
    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _userId = userData['userId'];
    _email = userData['email'];
    _expiryDate = expiryDate;
    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _email = null;
    _clearLogoutTimer();
    Store.remove('userData').then((_) {
      notifyListeners();
    });
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }
}
