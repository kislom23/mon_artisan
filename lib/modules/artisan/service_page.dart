// ignore_for_file: file_names, avoid_print, sized_box_for_whitespace, avoid_unnecessary_containers, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key}) : super(key: key);

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  List<dynamic> data = [];

  List<dynamic> offreServices = [];

  String authToken = "";

  @override
  void initState() {
    super.initState();
    loadAuthToken().then((_) {
      offreServiceList();
      fetchData();
    });
  }

  Future<void> offreServiceList() async {
    final url = Uri.parse('http://10.0.2.2:9000/api/v1/of/offreServices');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      setState(() {
        offreServices = responseData;
      });
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      authToken = token ?? '';
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
      });

      setState(() {});
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

  String userOffreService = "";

  void _addService() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Ajouter un service',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            titlePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: offreServices.map((offreService) {
              return SimpleDialogOption(
                onPressed: () async {
                  setState(() {
                    userOffreService = offreService['nomDuService'].toString();
                    
                  });
                  await addUserService();
                  await fetchData();
                  Navigator.of(context).pop();
                },
                child: Text(
                  offreService['nomDuService'].toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          );
        });
  }

  Future addUserService() async {
    final url2 =
        Uri.parse('http://10.0.2.2:9000/api/v1/auth/ajout/offre-service');

    var res = await http.post(
      url2,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({'nomDuService': userOffreService}),
    );

    if (res.statusCode == 200) {
      print("Success");
    } else {
      Fluttertoast.showToast(
        msg: "Une erreur s'est produite lors de l'ajout du service",
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
    }
  }

  Future deleteUserService(String userServiceName) async {
    final urlDel =
        Uri.parse('http://10.0.2.2:9000/api/v1/auth/$userServiceName/artisan');

    var res = await http.delete(
      urlDel,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    if (res.statusCode == 200) {
      fetchData();
      Fluttertoast.showToast(
        msg: "Service supprimé avec succès",
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
    } else {
      print(res.statusCode);
      Fluttertoast.showToast(
        msg: "Une erreur s'est produite lors de la suppression du service",
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
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
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          InkWell(
                            onTap: _addService,
                            child: const Icon(
                              Icons.add,
                              size: 35,
                            ),
                          )
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
                          final serviceCategorie =
                              service['categorie_De_Service']
                                  ['categorieService'];
                          final serviceDescription =
                              service['description_du_service'];

                          return ListTile(
                            leading: const CircleAvatar(
                                child: Icon(Icons.business_center_outlined,
                                    size: 30)),
                            title: Text(
                              serviceName,
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              'Catégorie : ' +
                                  serviceCategorie +
                                  '\n' +
                                  serviceDescription,
                              style: GoogleFonts.poppins(
                                  fontSize: 10, color: Colors.black),
                            ),
                            trailing: Container(
                              child: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  deleteUserService(serviceName);
                                },
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
