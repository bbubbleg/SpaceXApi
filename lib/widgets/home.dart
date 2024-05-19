// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String apiUrl = 'https://api.spacexdata.com/v4/launches/past';
  List data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SPACE X LAUNCHES'),
        ),
        // ignore: unnecessary_null_comparison
        body: data == null
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('LAUNCH: ${data[index]['name']}',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 125, 195, 233))),
                      subtitle: Column(
                        children: [
                          Text(data[index]['details'] ?? 'No details available',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 61, 63, 65))),
                          SizedBox(height: 5),
                          Text(data[index]['date_utc'],
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 175, 190, 201))),
                        ],
                      ),
                      trailing: Text(
                          data[index]['success'] ? 'success' : 'failed',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      leading: Image.network(
                          data[index]['links']['patch']['small'],
                          width: 10,
                          height: 10),
                    ),
                  );
                },
              ));
  }
}
