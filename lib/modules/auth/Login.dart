// ignore_for_file: file_names, use_build_context_synchronously, use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nye_dowola/common/my_button.dart';
import 'package:nye_dowola/common/my_textfield.dart';
import 'package:nye_dowola/modules/auth/Register.dart';
import 'package:nye_dowola/modules/auth/user.dart';
import 'package:http/http.dart' as http;
import 'package:nye_dowola/screens/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/route.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  bool obscureText = true;

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
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        fontSize: 16,
      );
      return;
    }
    setState(() {
      isLoading = true;
    });
    user.email = emailController.text;
    user.password = passwordController.text;
    var res = await http.post(url,
        headers: {'content-type': 'application/json'},
        body:
            json.encode({'email': user.email, 'mot_de_passe': user.password}));
    if (res.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
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
    } else {
      Fluttertoast.showToast(
        msg: "E-mail ou mot de passe incorrect",
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1,
        fontSize: 16,
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
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
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'NYE DOWOLA',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                // welcome back, you've been missed!
                Text(
                  'En vous connectant vous acceptez nos',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'termes et politiques de confidentialité',
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
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
                  obscureText: obscureText,
                  icon: const Icon(Icons.password),
                  onChanged: (value) {
                    user.password = value;
                  },
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
                ),

                const SizedBox(height: 20),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Mot de passe oublié ?',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  isLoading: isLoading,
                  onTap: signUserIn,
                ),

                const SizedBox(height: 20),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Vous n\'avez pas de compte ?',
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
                                  return const RegisterPage();
                                }));
                      },
                      child: Text(
                        'Créer en-un',
                        style: GoogleFonts.poppins(
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
