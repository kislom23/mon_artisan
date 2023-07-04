// ignore_for_file: file_names, avoid_print, sized_box_for_whitespace, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mon_artisan/modules/artisan/Service/service_formulaire.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<dynamic> data = [];
  String authToken = "";

  @override
  void initState() {
    super.initState();
    loadAuthToken().then((_) {
      fetchData();
    });
  }

  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      authToken = token ?? '';
      print(authToken);
    });
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.0.2.2:9000/api/v1/of/artoffre');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $authToken', // Add token to headers
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      setState(() {
        data = responseData;
        print(data);
      });
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Art.jpeg"),
                    fit: BoxFit.cover),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * .6,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: const Border(
                    bottom: BorderSide(
                      style: BorderStyle.none,
                    ),
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.2),
                      offset: const Offset(0, -4),
                      blurRadius: 8,
                    )
                  ],
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Service",
                              style: GoogleFonts.poppins(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const Icon(
                            Icons.business_center,
                            size: 36,
                          ),
                        ],
                      ),
                    ),
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
                          final service = data[index];
                          final serviceName = service['nomDuService'];
                          final serviceDescription =
                              service['description_du_service'];

                          return ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.business_center_outlined)),
                            title: Text(
                              serviceName,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              serviceDescription,
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: Colors.black),
                            ),
                            trailing: Container(
                              child: const IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: null,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
