// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontspring/services/auth_service.dart';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class ProductService extends ChangeNotifier {
  final String _baseUrl = '192.168.131.208:8080';
  bool isLoading = true;
  List<ProductModel> productData = [];

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
}
