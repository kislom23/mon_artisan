// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, file_names, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nye_dowola/common/my_button2.dart';
import 'package:nye_dowola/common/my_textfield.dart';
import 'package:nye_dowola/modules/auth/Login.dart';
import 'package:nye_dowola/modules/auth/user.dart';
import 'package:nye_dowola/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/route.dart';

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

  bool obscureText = true;

  Future<void> fetchData() async {
    final url = Uri.parse('$urlServer/api/v1/of/offreServices');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      setState(() {
        data = responseData.whereType<Map<String, dynamic>>().toList();
        print(data);

        dropdownItems = data.map<DropdownMenuItem<String>>((dynamic item) {
          final Map<String, dynamic> offreService =
              item as Map<String, dynamic>;
          return DropdownMenuItem<String>(
            value: offreService['nomDuService'] as String,
            child: Text(offreService['nomDuService'] as String,
                style: GoogleFonts.poppins(fontSize: 15)),
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
  Uri url = Uri.parse('$urlServer/api/v1/auth/artisan/ajout');

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
        msg: "Veuillez remplir tous les champs...",
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
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
          textColor: Colors.white,
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 1,
          fontSize: 16,
        );
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (token != null) {
        await prefs.setString('token', token);
        Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const HomePage(),
            transitionsBuilder: (context, animation1, animation2, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation1.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
          (route) => false,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Une erreur s'est produite lors de l'inscription",
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
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
                Container(
                  height: 170,
                  width: 170,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/LOGO-01.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Commençons...',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 350,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MyTextField(
                          icon: const Icon(Icons.person),
                          controller: nomController,
                          hintText: 'Nom',
                          obscureText: false,
                          onChanged: (value) {
                            user.nom = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          icon: const Icon(Icons.person),
                          controller: prenomController,
                          hintText: 'Prénom',
                          obscureText: false,
                          onChanged: (value) {
                            user.prenom = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          icon: const Icon(Icons.mail),
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
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListView(shrinkWrap: true, children: [
                              DropdownButton<String>(
                                icon: const Icon(
                                    Icons.home_repair_service_rounded),
                                menuMaxHeight: 400,
                                focusColor: Colors.grey,
                                underline: Container(),
                                isExpanded: true,
                                value: offreService.isNotEmpty
                                    ? offreService
                                    : null,
                                onChanged: (newValue) {
                                  setState(() {
                                    offreService = newValue!;
                                    print(offreService);
                                  });
                                },
                                items: dropdownItems.isNotEmpty
                                    ? dropdownItems
                                    : null,
                                hint: dropdownItems.isNotEmpty
                                    ? Text('Sélectionnez un service',
                                        style: TextStyle(
                                            fontFamily: 'poppins',
                                            fontSize: 15,
                                            color: Colors.grey[500]))
                                    : Text('Aucun service disponible',
                                        style: TextStyle(
                                            fontFamily: 'poppins',
                                            fontSize: 15,
                                            color: Colors.grey[500])),
                              ),
                            ]),
                          ),
                        ),
                        const SizedBox(height: 10),
                        MyTextField(
                          icon: const Icon(Icons.password),
                          controller: passwordController,
                          hintText: 'Mot de passe',
                          obscureText: obscureText,
                          icon2: GestureDetector(
                            onTap: () {
                              if (obscureText == false) {
                                setState(() {
                                  obscureText = true;
                                });
                              } else {
                                setState(() {
                                  obscureText = false;
                                });
                              }
                            },
                            child: obscureText
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                          onChanged: (value) {
                            user.password = value;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                MyButton2(
                  onTap: registerUser,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous êtes des nôtres ?',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder:
                                    (context, animation, animationTime, child) {
                                  animation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.elasticInOut);
                                  return ScaleTransition(
                                    scale: animation,
                                    alignment: Alignment.center,
                                    child: child,
                                  );
                                },
                                pageBuilder:
                                    (context, animation, animationTime) {
                                  return const LoginPage();
                                }));
                      },
                      child: Text(
                        'Connectez-vous',
                        style: GoogleFonts.poppins(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
