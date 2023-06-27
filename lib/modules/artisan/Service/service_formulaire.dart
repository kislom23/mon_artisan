// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ModifServicePage extends StatefulWidget {
  const ModifServicePage({Key? key}) : super(key: key);

  @override
  State<ModifServicePage> createState() => _ModifServicePageState();
}

class _ModifServicePageState extends State<ModifServicePage> {
  String userService = "";

  List<String> _categoryService = [];
  String authToken = "";

  @override
  void initState() {
    super.initState();
    loadAuthToken();
    RecupListCatSer();
  }

  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      authToken = token ?? '';
      print(authToken);
    });
  }

  Future<void> RecupListCatSer() async {
    final url = Uri.parse('http://10.0.2.2:9000/api/v1/ca/categorie_service');

    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $authToken'});

    if (response.statusCode == 200) {
      List<String> responseData = json.decode(response.body);

      setState(() {
        _categoryService = responseData;
      });
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modification du service',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Service',
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            DropdownButtonFormField<String>(
              value: userService,
              onChanged: (value) {
                setState(() {
                  userService = value!;
                });
              },
              items: _categoryService.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Catégorie',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
