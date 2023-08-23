// ignore_for_file: file_names, sized_box_for_whitespace, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final int id;
  const EditProfilePage({Key? key, required this.id}) : super(key: key);

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

  Uint8List? photoProfil;

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        photoProfil = imageBytes;
        _buildProfileImage();
      });
    }
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
      print(widget.id);
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
    //int quartierId = quartier;

    var res = await http.put(
      url,
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
      body: json.encode({
        'id': widget.id,
        'nom': nom,
        'prenom': prenom,
        'email': email,
        'num_telephone': telephone,
        'photo_profile': photoProfil,
        'quartierId': 1,
        'localisation': {
          'adresse': '11 Agoe vakpoe',
          'longitude': '76.098',
          'latitude': '89.536',
        }
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
      print(res.body);
    }
  }

  Widget _buildProfileImage() {
    if (photoProfil == null) {
      // Si aucune image n'est sélectionnée, affichez une image réseau
      return ClipRRect(
          borderRadius: BorderRadius.circular(60),
          child: Image.asset(
            "assets/images/télécharger.png",
            fit: BoxFit.cover,
          ));
    } else {
      // Si une image est sélectionnée, affichez l'image depuis la mémoire
      return ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.memory(
          photoProfil!,
          fit: BoxFit.cover,
        ),
      );
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
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(width: 4, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1))
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: _buildProfileImage(),
                  ),
                  GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: Positioned(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white),
                          color: Colors.orange,
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
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
