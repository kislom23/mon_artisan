// ignore_for_file: file_names, sized_box_for_whitespace, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashbordPage extends StatefulWidget {
  const DashbordPage({Key? key}) : super(key: key);

  @override
  State<DashbordPage> createState() => _DashbordPageState();
}

class _DashbordPageState extends State<DashbordPage> {
  @override
  void initState() {
    super.initState();
    shouldShowAlertDialog();
  }

  Future<bool> shouldShowAlertDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool showDialogg = prefs.getBool('show_dialogg') ?? true;

    if (showDialogg) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text(
                          'Bienvenue',
                          style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          'Merci de faire partie de notre communauté, diriger vous vers l\'onglet profil pour parametrer votre compte',
                          style: TextStyle(fontSize: 13, fontFamily: 'Poppins'),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await prefs.setBool('show_dialogg', false);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Ok',
                            style: TextStyle(
                                color: Colors.white, fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: Colors.orangeAccent,
                  radius: 60,
                  child: Icon(
                    Icons.message,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // Enregistrez que l'AlertDialog a été affiché une fois
      await prefs.setBool('show_dialog', false);
    }

    return showDialogg;
  }

  var height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        color: Colors.orangeAccent,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              decoration: const BoxDecoration(),
              height: height * 0.25,
              width: width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 35,
                      left: 15,
                      right: 15,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.sort,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        ClipRRect(
                          child: Image.asset(
                            "assets/images/woman.png",
                            height: 40,
                            width: 40,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
              height: height * 0.75,
              width: width,
            )
          ]),
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(200);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              IconButton(
                icon: Icon(
                  Icons.sort_rounded,
                  size: 30,
                ),
                color: Colors.white,
                onPressed: null,
              ),
              IconButton(
                icon: Icon(
                  Icons.category_rounded,
                  size: 30,
                ),
                color: Colors.white,
                onPressed: null,
              ),
            ],
          ),
          const SizedBox(height: 20),
          // ignore: prefer_const_constructors
          Padding(
            padding: const EdgeInsets.only(left: 3, bottom: 15),
            // ignore: prefer_const_constructors
            child: Text(
              "Bienvenue",
              // ignore: prefer_const_constructors
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                wordSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 20),
            width: MediaQuery.of(context).size.width,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Recherche...",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
