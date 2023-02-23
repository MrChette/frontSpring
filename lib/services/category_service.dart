// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:appproducts/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import 'services.dart';

class CategoryService extends ChangeNotifier {
  final String _baseUrl = ':8080';
  bool isLoading = true;
  List<Category> categorias = [];
  String categoria = "";
  final storage = const FlutterSecureStorage();

  getCategories() async {
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/api/all/categories');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final List<dynamic> decodedResp = json.decode(resp.body);

    List<Category> categoryList = decodedResp
        .map((e) => Category(
              id: e['id'],
              name: e['name'],
              description: e['description'],
            ))
        .toList();

    categorias = categoryList;

    isLoading = false;
    notifyListeners();
    return categorias;
  }

  Future deleteCategory(String id) async {
    final url = Uri.http(_baseUrl, '/api/admin/categories/$id');
    String? token = await AuthService().readToken();
    print(url);
    isLoading = true;
    notifyListeners();
    // ignore: unused_local_variable
    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
  }

  Future updateCategory(String id, String name, String description) async {
    String? token = await AuthService().readToken();
    print(id);
    print(name);
    print(description);

    isLoading = true;
    notifyListeners();

    // ignore: unused_local_variable

    final Map<String, dynamic> authData = {
      'name': name,
      'description': description,
    };

    final encodedFormData = utf8.encode(json.encode(authData));
    final url = Uri.http(_baseUrl, '/api/admin/categories/$id');

    final resp = await http.put(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: encodedFormData);

    print(resp.statusCode);

    if (resp.statusCode == 200) {}
  }

  Future createCategory(String name, String description) async {
    String? token = await AuthService().readToken();
    print(name);
    print(description);

    isLoading = true;
    notifyListeners();

    // ignore: unused_local_variable

    final Map<String, dynamic> authData = {
      'name': name,
      'description': description,
    };

    final encodedFormData = utf8.encode(json.encode(authData));
    final url = Uri.http(_baseUrl, '/api/admin/categories');

    final resp = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          "Authorization": "Bearer $token"
        },
        body: encodedFormData);

    print(resp.statusCode);

    if (resp.statusCode == 200) {
      print('FUNSIONA PERRO');
    }
  }

  getCategory(String id) async {
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, '/api/admin/categories/$id');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    Category category = Category.fromJson(decodedResp);

    isLoading = false;
    notifyListeners();
    return category;
  }
}
