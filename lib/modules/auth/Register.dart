// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors, file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  User user = User("", "", "", "");
  // text editing controllers
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

    // Vérifier si tous les champs sont remplis
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
      // Enregistrez le token dans les préférences de l'appareil
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
                // logo
                const Image(
                  image: AssetImage('assets/images/LOGO-01.png'),
                  height: 200,
                ),

                const SizedBox(height: 10),

                // welcome back, you've been missed!
                const Text(
                  'Bienvenue, inscrivez-vous ',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 15),

                // username textfield
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
                // password textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  onChanged: (value) {
                    user.email = value;
                  },
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

                // sign in button
                MyButton2(
                  onTap: registerUser,
                ),

                const SizedBox(height: 20),
                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous êtes des nôtres ?',
                      style: TextStyle(color: Colors.grey),
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
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
