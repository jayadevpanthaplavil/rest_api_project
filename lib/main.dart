import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rest_api_project/User.dart';
import 'package:rest_api_project/products_example.dart';
import 'package:rest_api_project/todos_example.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductsPage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body) as List;
      var listUsers = jsonString.map((i) => User.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  Widget build(BuildContext context) {
    late List<User> userList;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              userList = snapshot.data as List<User>;
              return ListView.builder(
                itemCount: userList.length,
                  itemBuilder: (BuildContext context, int index) {
                User us = userList[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name : ${us.name}"),
                        Text("Username : ${us.username}"),
                        Text("Email : ${us.email}"),
                        Text("Phone : ${us.phone}"),

                      ],
                    ),
                  ),
                );
              });
            }return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
