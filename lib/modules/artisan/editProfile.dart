// ignore_for_file: file_names, sized_box_for_whitespace, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:map_location_picker/map_location_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  void initState() {
    super.initState();
    loadAuthToken();
    fetchData();
  }

  List<dynamic> data = [];
  List<DropdownMenuItem<String>> dropdownItems = [];
  int quartier = 0;

  String authToken = "";

  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      authToken = token ?? '';
      print(authToken);
    });
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.0.2.2:9000/api/v1/qu/quartiers');
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

        dropdownItems = data.map<DropdownMenuItem<String>>((dynamic item) {
          final Map<String, dynamic> quartier = item as Map<String, dynamic>;
          return DropdownMenuItem<String>(
            value: quartier['id'],
            child: Text(quartier['libele'] as String,
                style: GoogleFonts.poppins(fontSize: 12)),
          );
        }).toList();

        // Tri des éléments par ordre alphabétique
        dropdownItems.sort((a, b) => a.value!.compareTo(b.value!));
      });
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();

  final url = Uri.parse('http://10.0.2.2:9000/api/v1/auth/artisan/modifier');

  Future<void> _submitForm() async {
    // Récupérer les valeurs saisies dans les variables
    String nom = _nomController.text;
    String prenom = _prenomController.text;
    String email = _emailController.text;
    String telephone = _telephoneController.text;
    int quartierId = quartier;

    var res = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: json.encode({
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'num_telephone': telephone,
        'quartierId': quartierId,
      }),
    );
    if (res.statusCode == 200) {
      print(res.body);
      Fluttertoast.showToast(
        msg: 'Modification effectué',
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
        msg: 'Une erreur s\'est produite. Veuillez reessayer plus tard',
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
      print(res.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _telephoneController,
                decoration: InputDecoration(
                  labelText: 'Téléphone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListView(shrinkWrap: true, children: [
                    DropdownButton<String>(
                      focusColor: Colors.grey,
                      isExpanded: true,
                      // ignore: prefer_null_aware_operators, unnecessary_null_comparison
                      value: quartier != null ? quartier.toString() : null,
                      onChanged: (newValue) {
                        setState(() {
                          quartier = newValue! as int;
                          print(quartier);
                        });
                      },
                      items: dropdownItems.isNotEmpty ? dropdownItems : null,
                      hint: dropdownItems.isNotEmpty
                          ? const Text('Sélectionnez un quartier',
                              style: TextStyle(
                                  fontFamily: 'poppins', fontSize: 12))
                          : const Text('Aucun quartier disponible'),
                    ),
                  ]),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: 400,
                height: 40,
                child: ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic>? result =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MapLocationPicker(
                        apiKey: 'AIzaSyAu76Kt4TGshChEI2kBSuAOdebFLKOFJII',
                      ),
                    ));

                    // ignore: unnecessary_null_comparison
                    if (result != null && result.containsKey('location')) {
                      LatLng location = result['location'];
                      print('Location picked: $location');
                    } else {
                      // Afficher un message si la liste est vide
                      print('Veuillez choisir une localisation');
                      Fluttertoast.showToast(
                        msg: "Veuillez choisir une localisation",
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      side: BorderSide.none, shape: const StadiumBorder()),
                  child: Text(
                    'Où offrez vous, vôtre service ?',
                    style:
                        GoogleFonts.poppins(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Container(
                width: 250,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                      side: BorderSide.none, shape: const StadiumBorder()),
                  child: Text(
                    'Valider',
                    style:
                        GoogleFonts.poppins(fontSize: 15, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
