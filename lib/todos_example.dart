import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rest_api_project/Todos.dart';
import 'package:http/http.dart' as http;

class TodosExample extends StatefulWidget {
  const TodosExample({Key? key}) : super(key: key);

  @override
  State<TodosExample> createState() => _TodosExampleState();
}

class _TodosExampleState extends State<TodosExample> {

  Future<List<Todos>> fetchUsers() async {
    final response =
    await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));
    if (response.statusCode == 200) {
      var jsonString = json.decode(response.body) as List;
      var listUsers = jsonString.map((i) => Todos.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception("Failed to load");
    }
  }
  @override
  Widget build(BuildContext context) {
    late List<Todos> userList;
    return Scaffold(
      appBar: AppBar(title: Text("ToDo App"),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchUsers(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              userList = snapshot.data as List<Todos>;
              return ListView.builder(
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    Todos us = userList[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Task : ${us.title}"),
                            Row(
                              children: [
                                Text("Status  - "),
                                Container(child: us.completed==true ? Icon(Icons.done): Icon(Icons.error)),
                              ],
                            ),


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
