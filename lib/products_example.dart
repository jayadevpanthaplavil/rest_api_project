import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_project/ProductsJsontoDart.dart';
import 'Products.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  Future<List<Products>?> fetchProducts() async {
    final response =
        await http.get(Uri.parse("https://dummyjson.com/products"));
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body.toString()) ;
      var data=ProductsJsontoDart.fromJson(jsonString);
      var listProducts = data.products;
      return listProducts;
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  Widget build(BuildContext context) {
    late List<Products> proList;
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchProducts(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              proList = snapshot.data as List<Products>;
              return ListView.builder(
                  itemCount: proList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Products pro = proList[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Image.network("${pro.thumbnail}"),
                            ),
                            Text("${pro.description}"),
                            // Row(
                            //   children: [
                            //     Text("Status  - "),
                            //     Container(child: us.completed==true ? Icon(Icons.done): Icon(Icons.error)),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
