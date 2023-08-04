// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, file_names, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mon_artisan/common/my_button2.dart';
import 'package:mon_artisan/common/my_textfield.dart';
import 'package:mon_artisan/modules/auth/Login.dart';
import 'package:mon_artisan/modules/auth/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<dynamic> data = [];
  List<DropdownMenuItem<String>> dropdownItems = [];
  String offreService = '';

  @override
  void initState() {
    super.initState();
    fetchData();

    if (data.isNotEmpty) {
      offreService = data[0]['nomDuService'];
    }
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.0.2.2:9000/api/v1/of/offreServices');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      setState(() {
        data = responseData;
        print(data);

        dropdownItems = data.map<DropdownMenuItem<String>>((dynamic item) {
          final Map<String, dynamic> offreService =
              item as Map<String, dynamic>;
          return DropdownMenuItem<String>(
            value: offreService['nomDuService'] as String,
            child: Text(offreService['nomDuService'] as String,
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

  User user = User("", "", "", "", "");
  final nomController = TextEditingController();
  final prenomController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Uri url = Uri.parse('http://10.0.2.2:9000/api/v1/auth/artisan/ajout');

  Future registerUser() async {
    user.nom = nomController.text;
    user.password = passwordController.text;
    user.prenom = prenomController.text;
    user.email = emailController.text;
    user.offreService = offreService;

    if (user.nom.isEmpty ||
        user.prenom.isEmpty ||
        user.email.isEmpty ||
        user.password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Veuillez remplir tous les champs",
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
      return;
    }

    var res = await http.post(
      url,
      headers: {'content-type': 'application/json'},
      body: json.encode({
        'nom': user.nom,
        'prenom': user.prenom,
        'email': user.email,
        'mot_de_passe': user.password,
        'offreService': {'nomDuService': offreService}
      }),
    );

    if (res.statusCode == 200) {
      var jsonResponse = json.decode(res.body);
      var token = jsonResponse['token'];

      if (jsonResponse.containsKey('message')) {
        String message = jsonResponse['message'];
        Fluttertoast.showToast(
          msg: message.toString(),
          gravity: ToastGravity.BOTTOM,
          fontSize: 16,
        );
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('token', token);
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false,
            arguments: user.email);
      }
    } else {
      Fluttertoast.showToast(
        msg: "Une erreur s'est produite lors de l'inscription",
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/LOGO-01.png'),
                  height: 200,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Bienvenue, inscrivez-vous ',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: nomController,
                  hintText: 'Nom',
                  obscureText: false,
                  onChanged: (value) {
                    user.nom = value;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: prenomController,
                  hintText: 'Prénom',
                  obscureText: false,
                  onChanged: (value) {
                    user.prenom = value;
                  },
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  onChanged: (value) {
                    user.email = value;
                  },
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListView(shrinkWrap: true, children: [
                      DropdownButton<String>(
                        menuMaxHeight: 300,
                        focusColor: Colors.grey,
                        isExpanded: true,
                        value: offreService.isNotEmpty ? offreService : null,
                        onChanged: (newValue) {
                          setState(() {
                            offreService = newValue!;
                            print(offreService);
                          });
                        },
                        items: dropdownItems.isNotEmpty ? dropdownItems : null,
                        hint: dropdownItems.isNotEmpty
                            ? const Text('Sélectionnez un service',
                                style: TextStyle(
                                    fontFamily: 'poppins', fontSize: 12))
                            : const Text('Aucun service disponible'),
                      ),
                    ]),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Mot de passe',
                  obscureText: true,
                  onChanged: (value) {
                    user.password = value;
                  },
                ),
                const SizedBox(height: 25),
                MyButton2(
                  onTap: registerUser,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous êtes des nôtres ?',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'poppins',
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Connectez-vous',
                        style: TextStyle(
                          fontFamily: 'poppins',
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
