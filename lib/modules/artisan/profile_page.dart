// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:nye_dowola/main.dart';
import 'package:nye_dowola/modules/artisan/editProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    loadAuthToken().then((_) {
      getEmail().then((_) {
        fetchData();
      });
    });
  }

  Future<void> _logout() async {
    String url = 'http://10.0.2.2:9000/api/v1/auth/logout';

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $authToken'},
      );

      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
          (Route<dynamic> route) => false,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Une erreur s'est produite lors de la deconnexion",
          gravity: ToastGravity.BOTTOM,
          fontSize: 16,
        );
        print(response.statusCode);
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la déconnexion : $error',
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
    }
  }

  Future<void> _delayedLogout() async {
    await Future.delayed(const Duration(seconds: 3));
    await _logout();
  }

  String authToken = "";

  Future<void> loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    setState(() {
      authToken = token ?? '';
    });
  }

  String userEmail = '';

  Future<void> getEmail() async {
    final url = Uri.parse(
        'http://10.0.2.2:9000/api/v1/auth/email-utilisateur-connecte');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $authToken'},
    );

    if (response.statusCode == 200) {
      setState(() {
        userEmail = response.body;
        print(userEmail);
      });
    } else {
      print('Erreur de récupération de l\'e-mail');
    }
  }

  String nomUser = '';
  String prenomUser = '';
  String emailUser = '';
  String telUser = '';
  String quartierUser = '';
  String photoUser = '';
  int idUser = 0;

  Uint8List? photoProfile;

  Future<void> fetchData() async {
    final url =
        Uri.parse('http://10.0.2.2:9000/api/v1/auth/artisand/$userEmail');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $authToken', // Add token to headers
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> responseData = json.decode(response.body);
      int userId = responseData['id'];
      String nom = responseData['nom'].toString();
      String prenom = responseData['prenom'].toString();
      String email = responseData['email'].toString();
      String tel = responseData['num_telephone'].toString();
      String quartier = '';

      if (responseData['localisations'].isNotEmpty) {
        quartier = responseData['localisations'][0]['adresse'].toString();
      } else {
        quartier = 'null';
      }

      String photo = responseData['photo_profil'].toString();

      setState(() {
        nomUser = nom;
        prenomUser = prenom;
        emailUser = email;
        telUser = tel;
        quartierUser = quartier;
        photoUser = photo;
        idUser = userId;

        if (photoUser == 'null') {
          photoProfile = null;
        } else {
          photoProfile = Uint8List.fromList(base64Decode(photoUser));
        }
      });

      print(quartierUser);
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: photoProfile != null
                      ? Image.memory(
                          photoProfile!,
                          fit: BoxFit.cover,
                        )
                      : const Image(
                          image: AssetImage('assets/images/LOGO-01.png')),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              //nom et prenom
              Text(
                '$nomUser  $prenomUser',
                style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              //email
              Text(
                emailUser,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                    id: idUser,
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                        side: BorderSide.none, shape: const StadiumBorder()),
                    child: Text(
                      'Modifier',
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: Colors.white),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 2,
              ),
              const SizedBox(
                height: 10,
              ),
              //quartier
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: const Icon(
                    LineAwesomeIcons.phone,
                    color: Color.fromARGB(255, 45, 43, 107),
                  ),
                ),

                // ignore: unnecessary_null_comparison
                title: telUser != null && telUser != 'null'
                    ? Text(
                        telUser,
                        style: GoogleFonts.poppins(fontSize: 16),
                      )
                    : Text(
                        'Non Defini',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: const Icon(
                    LineAwesomeIcons.map_marker,
                    color: Color.fromARGB(255, 45, 43, 107),
                  ),
                ),
                // ignore: unnecessary_null_comparison
                title: quartierUser != null && quartierUser != 'null'
                    ? Text(
                        quartierUser,
                        style: GoogleFonts.poppins(fontSize: 16),
                      )
                    : Text(
                        'Non défini',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: const Icon(
                    LineAwesomeIcons.sign_out,
                    color: Color.fromARGB(255, 45, 43, 107),
                  ),
                ),
                title: Text(
                  'Se déconnecter',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                trailing: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: InkWell(
                    onTap: () async {
                      Fluttertoast.showToast(
                        msg: "Deconnexion en cours...",
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16,
                      );

                      await _delayedLogout();
                    },
                    child: const Icon(
                      LineAwesomeIcons.angle_right,
                      size: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
