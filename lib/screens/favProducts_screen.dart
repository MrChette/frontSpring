// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:frontspring/models/category_model.dart';
import 'package:frontspring/services/category_service.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';

class favProductScreen extends StatefulWidget {
  const favProductScreen({Key? key}) : super(key: key);

  @override
  State<favProductScreen> createState() => _favProductScreenState();
}

class _favProductScreenState extends State<favProductScreen> {
  final productService = ProductService();
  final authService = AuthService();
  bool buttonState = false;
  List<ProductModel> productos = [];
  List<int> favoritos = [];
  List<ProductModel> productosFav = [];

  Future getProducts() async {
    await productService.getListProducts();
    setState(() {
      productos.clear();
      productos = productService.productData;
    });
  }

  Future getProductModelFav() async {
    productosFav.clear();
    await productService.getFav();
    await productService.getListProducts();
    List<ProductModel> productosM = productService.productData;
    List<int> favoritos = productService.favorites;
    List<ProductModel> pFav = [];
    print("modelfav" + productosM.length.toString());
    for (var i = 0; i < productosM.length; i++) {
      if (favoritos.contains(productos[i].id)) {
        pFav.add(productos[i]);
      }
    }
    setState(() {
      productosFav = pFav;
    });
  }

  Future getFavorites() async {
    await productService.getFav();
    setState(() {
      favoritos.clear();
      favoritos = productService.favorites;
    });
    print("favoritos" + favoritos.toString());
  }

  @override
  void initState() {
    super.initState();
    getProducts();
    getFavorites();
    getProductModelFav();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _onItemTapped(int index) {
      if (index == 1) {
        Navigator.pushReplacementNamed(context, 'favProducts');
      } else {
        Navigator.pushReplacementNamed(context, 'userProducts');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
      body: builListView(context, productosFav),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Favorites'),
        ],
        currentIndex: 0, //New
        onTap: _onItemTapped,
      ),
    );
  }
  // void _toggleFavorite(ProductModel product) {
  //   setState(() {
  //     if (_favorites.contains(product)) {
  //       _favorites.remove(product);
  //       product.isFavorite = false;
  //     } else {
  //       _favorites.add(product);
  //       product.isFavorite = true;
  //     }
  //   });
  // }

  Widget builListView(BuildContext context, productos) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.60,
      child: ListView.builder(
          itemCount: productos.length,
          padding: const EdgeInsets.all(30),
          itemBuilder: (BuildContext context, index) {
            int idProducto = productos[index].id;
            bool esFavorito = favoritos.contains(idProducto);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(productos[index].name,
                          style: TextStyle(fontSize: 20)),
                      subtitle: Text(productos[index].description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${productos[index].price.toStringAsFixed(2)}€',
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(width: 60),
                          GestureDetector(
                            onTap: () {
                              print(idProducto.toString());
                              setState(() {
                                if (esFavorito) {
                                  productService.delFav(idProducto.toString());
                                  favoritos.remove(idProducto);
                                } else {
                                  productService.addFav(idProducto.toString());
                                  favoritos.add(idProducto);
                                }
                              });
                              getFavorites();
                              getProductModelFav();
                            },
                            child: Icon(
                              esFavorito
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: esFavorito ? Colors.red : null,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
