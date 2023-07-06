// ignore_for_file: avoid_print, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:http/http.dart' as http;

class ResultatPage extends StatefulWidget {
  final String searchTerm;

  const ResultatPage({Key? key, required this.searchTerm}) : super(key: key);

  @override
  State<ResultatPage> createState() => _ResultatPageState();
}

class _ResultatPageState extends State<ResultatPage> {
  late String searchTerm;

  @override
  void initState() {
    super.initState();
    searchTerm = widget.searchTerm;
    search();
  }

  List<dynamic> data = [];
  String? nomDuService;

  Future<void> search() async {
    final url =
        Uri.parse('http://10.0.2.2:9000/api/v1/auth/offre-service/$searchTerm');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      setState(() {
        data = responseData;
        print(data);
      });

      for (var offreService in data[0]['offreServices']) {
        if (offreService['nomDuService'] == searchTerm) {
          setState(() {
            nomDuService = offreService['nomDuService'];
          });
          break;
        }
      }

      setState(() {});
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.arrow_left),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          searchTerm,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 30,
              right: 30,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final artisan = data[index];
                final artisanName = artisan['nom'];
                final artisanPrenom = artisan['prenom'];
                final artisanService =
                    artisan['offreServices'][index]['nomDuService'];

                return ListTile(
                  leading:
                      const CircleAvatar(child: Icon(Icons.person, size: 30)),
                  title: Text(
                    artisanService,
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  subtitle: Text(
                    artisanName + ' ' + artisanPrenom,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Container(
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_right,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {},
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
