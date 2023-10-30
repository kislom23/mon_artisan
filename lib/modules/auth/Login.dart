// ignore_for_file: file_names, use_build_context_synchronously, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nye_dowola/common/my_button.dart';
import 'package:nye_dowola/common/my_textfield.dart';
import 'package:nye_dowola/modules/auth/Register.dart';
import 'package:nye_dowola/modules/auth/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/route.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User user = User("", "", "", "", "");

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Uri url = Uri.parse('$urlServer/api/v1/auth/login');

  // sign user in method
  Future signUserIn() async {
    // Validation des champs email et mot de passe
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Veuillez remplir tous les champs",
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
      return;
    }

    user.email = emailController.text;
    user.password = passwordController.text;
    var res = await http.post(url,
        headers: {'content-type': 'application/json'},
        body:
            json.encode({'email': user.email, 'mot_de_passe': user.password}));
    if (res.statusCode == 200) {
      var jsonResponse = json.decode(res.body);
      var token = jsonResponse['token'];

      // Enregistrez le token dans les préférences de l'appareil
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      Fluttertoast.showToast(
        msg: "Connexion réussie",
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false,
          arguments: user.email);
    } else {
      Fluttertoast.showToast(
        msg: "E-mail ou mot de passe incorrect",
        gravity: ToastGravity.BOTTOM,
        fontSize: 16,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
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
                  'Ravi de vous retrouver, vous nous avez-manqué',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 25),

                // username textfield
                MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    icon: const Icon(Icons.email),
                    onChanged: (value) {
                      user.email = value;
                    }),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Mot de passe',
                  obscureText: true,
                  icon: const Icon(Icons.password),
                  onChanged: (value) {
                    user.password = value;
                  },
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: signUserIn,
                ),

                const SizedBox(height: 20),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Vous n\'avez pas de compte',
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
                                builder: (context) => const RegisterPage()));
                      },
                      child: const Text(
                        'Créer en-un',
                        style: TextStyle(
                          fontFamily: 'poppins',
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
