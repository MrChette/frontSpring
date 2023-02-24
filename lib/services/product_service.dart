// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontspring/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = '192.168.1.140:8080';
  bool isLoading = true;
  List<ProductModel> productData = [];
  List<ProductModel> product = [];
  Future<List> getListProducts() async {
    print("Entrando");
    productData.clear();
    isLoading = true;
    notifyListeners();
    final url = Uri.http(_baseUrl, '/api/all/products');
    String? token = await AuthService().readToken();
    print(token);

    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );
    print("Resp " + resp.body);
    final List<dynamic> decodedResp = json.decode(resp.body);
    List<ProductModel> categoryList = decodedResp
        .map((e) => ProductModel(
              id: e['id'],
              name: e['name'],
              description: e['description'],
              idCategory: e['idCategory'],
              price: e['price'],
            ))
        .toList();
    print(categoryList);
    productData = categoryList;

    // var catalog = ProductModel.fromJson(decodedResp);
    // print(catalog);
    isLoading = false;
    notifyListeners();
    return categoryList;
  }

  getProductsfilter(String id) async {
    String? token = await AuthService().readToken();

    final url = Uri.http(_baseUrl, 'api/user/categories/$id/products');

    isLoading = true;
    notifyListeners();
    final resp = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    final List<dynamic> decodedResp = json.decode(resp.body);

    List<ProductModel> productList = decodedResp
        .map((e) => ProductModel(
              id: e['id'],
              name: e['name'],
              description: e['description'],
              price: e['price'],
              idCategory: e['idCategory'],
            ))
        .toList();

    product = productList;
    isLoading = false;
    notifyListeners();
    return product;
  }

  Future addFav(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/user/addFav/$id');

    final resp = await http.post(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print(resp.statusCode);

    if (resp.statusCode == 200) {}
  }

  deleteProduct(String id) async {
    String? token = await AuthService().readToken();

    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/admin/products/$id');

    final resp = await http.delete(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    print(resp.statusCode);

    if (resp.statusCode == 200) {}
  }

  Future modify(
    int id,
    String name,
    String description,
    String price,
  ) async {
    String? token = await AuthService().readToken();

    final Map<String, dynamic> productData = {
      'name': name,
      'description': description,
      'price': price,
    };
    print(productData);
    print(json.encode(productData));
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/admin/products/$id');

    final resp = await http.put(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(productData),
    );

    print(resp.statusCode);

    if (resp.statusCode == 200) {}
  }

  Future create(
    int idCategory,
    String name,
    String description,
    String price,
  ) async {
    String? token = await AuthService().readToken();
    isLoading = true;
    final Map<String, dynamic> productData = {
      'name': name,
      'description': description,
      'price': price,
      'idCategory': idCategory,
    };
    print(productData);
    print(json.encode(productData));
    isLoading = true;
    notifyListeners();

    final url = Uri.http(_baseUrl, '/api/admin/categories/$idCategory/product');

    final resp = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: json.encode(productData),
    );

    print(resp.statusCode);

    if (resp.statusCode == 200) {}
  }
}
