import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../services/auth_service.dart';
import '../services/product_service.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final productService = ProductService();

  List<ProductModel> productos = [];

  Future getProducts() async {
    await productService.getListProducts();
    setState(() {
      productos = productService.productData;
    });
  }

  @override
  void initState() {
    super.initState();
    getProducts();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    void _onItemTapped(int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, 'user');
      } else {
        Navigator.pushReplacementNamed(context, 'catalog');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            Provider.of<AuthService>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.markunread_mailbox_outlined),
            onPressed: () {
              Navigator.of(context).pushNamed('orders');
            },
          )
        ],
      ),
      body: builListView(context, productos),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Categories'),
        ],
        currentIndex: 0, //New
        onTap: _onItemTapped,
      ),
    );
  }

  Widget builListView(BuildContext context, List articles) {
    return ListView.separated(
      padding: const EdgeInsets.all(30),
      itemCount: articles.length,
      itemBuilder: (BuildContext context, index) {
        return SizedBox(
            height: 200,
            child: Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Color(0xFFF5F5F5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${productos[index].id}',
                            style: const TextStyle(fontSize: 20)),
                        Text(
                          productos[index].name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          productos[index].description,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          'Price : ${productos[index].price}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GFIconButton(
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete Product'),
                                content: const Text('Are you sure?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // productService.deleteProduct(
                                      //     productos[index].id.toString());
                                      // setState(() {
                                      //   productos.removeWhere((element) =>
                                      //       (element == productos[index]));
                                      // });
                                      // Navigator.pop(context);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                        GFIconButton(
                          onPressed: () {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Delete Product'),
                                content: const Text('Are you sure?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // productService.deleteProduct(
                                      //     productos[index].id.toString());
                                      // setState(() {
                                      //   productos.removeWhere((element) =>
                                      //       (element == productos[index]));
                                      // });
                                      // Navigator.pop(context);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.delete_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )

            // Card(
            //   elevation: 20,
            //   child: Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //       children: [
            //         Text('${productos[index].id}',
            //             style: const TextStyle(fontSize: 20)),
            //         Text(
            //           productos[index].name,
            //           style: const TextStyle(fontSize: 20),
            //         ),
            //         Text(
            //           productos[index].description,
            //           style: const TextStyle(fontSize: 20),
            //         ),
            //         Text(
            //           'Price : ${productos[index].price}',
            //           style: const TextStyle(fontSize: 20),
            //         ),
            //         const Divider(color: Colors.black),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //           children: [
            //             const Divider(color: Colors.black),
            //             GFIconButton(
            //               onPressed: () {
            //                 showDialog<String>(
            //                   context: context,
            //                   builder: (BuildContext context) => AlertDialog(
            //                     title: const Text('Delete Product'),
            //                     content: const Text('Are you sure?'),
            //                     actions: <Widget>[
            //                       TextButton(
            //                         onPressed: () {
            //                           Navigator.pop(context);
            //                         },
            //                         child: const Text('No'),
            //                       ),
            //                       TextButton(
            //                         onPressed: () {
            //                           // productService.deleteProduct(
            //                           //     productos[index].id.toString());
            //                           // setState(() {
            //                           //   productos.removeWhere((element) =>
            //                           //       (element == productos[index]));
            //                           // });
            //                           // Navigator.pop(context);
            //                         },
            //                         child: const Text('Yes'),
            //                       ),
            //                     ],
            //                   ),
            //                 );
            //               },
            //               icon: const Icon(
            //                 Icons.delete_outlined,
            //                 color: Colors.white,
            //                 size: 30,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ]),
            // ),
            );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }
}


// Card(
//   clipBehavior: Clip.antiAliasWithSaveLayer,
//   color: Color(0xFFF5F5F5),
//   child: Row(
//     mainAxisSize: MainAxisSize.max,
//     children: [
//       Expanded(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               'Hello World',
//               textAlign: TextAlign.start,
//               style: FlutterFlowTheme.of(context).bodyText1,
//             ),
//             Text(
//               'Hello World',
//               textAlign: TextAlign.start,
//               style: FlutterFlowTheme.of(context).bodyText1,
//             ),
//             Text(
//               'Hello World',
//               textAlign: TextAlign.start,
//               style: FlutterFlowTheme.of(context).bodyText1,
//             ),
//           ],
//         ),
//       ),
//       Expanded(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             FlutterFlowIconButton(
//               borderColor: Colors.transparent,
//               borderRadius: 30,
//               borderWidth: 1,
//               buttonSize: 60,
//               icon: Icon(
//                 Icons.add,
//                 color: FlutterFlowTheme.of(context).primaryText,
//                 size: 30,
//               ),
//               onPressed: () {
//                 print('IconButton pressed ...');
//               },
//             ),
//             FlutterFlowIconButton(
//               borderColor: Colors.transparent,
//               borderRadius: 30,
//               borderWidth: 1,
//               buttonSize: 60,
//               icon: Icon(
//                 Icons.add,
//                 color: FlutterFlowTheme.of(context).primaryText,
//                 size: 30,
//               ),
//               onPressed: () {
//                 print('IconButton pressed ...');
//               },
//             ),
//           ],
//         ),
//       ),
//     ],
//   ),
// )
