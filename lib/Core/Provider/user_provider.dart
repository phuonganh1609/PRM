import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _user;

  Map<String, dynamic>? get user => _user;
  int? get userId => _user?["id"];

  void setUser(Map<String, dynamic> data) {
    _user = data;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  bool get isLoggedIn => _user != null;

  Future<void> fetchUserById(int userId) async {
    try {
      final url = Uri.parse("http://10.0.2.2:5162/api/user/$userId");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        _user = jsonDecode(response.body);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Fetch user error: $e");
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> login(
    String identifier,
    String password,
  ) async {
    final url = Uri.parse("http://10.0.2.2:5162/api/user/login");
    final body = jsonEncode({"identifier": identifier, "password": password});

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['user'] != null) {
        setUser(data['user']);
      }
      return data['user'];
    } else {
      return null;
    }
  }
}
