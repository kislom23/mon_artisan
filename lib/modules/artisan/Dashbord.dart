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

  List imgSrc = [
    'assets/images/clay-crafting.png',
    'assets/images/comments.png',
    'assets/images/help.png',
    'assets/images/about.png',
  ];

  List titles = [
    "Services",
    "Commentaire",
    "Assistance",
    "A propos",
  ];

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
              height: height * 0.35,
              width: width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 35,
                      left: 20,
                      right: 20,
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
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            image: const DecorationImage(
                              image: AssetImage('assets/images/LOGO-01.png'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 35,
                      left: 15,
                      right: 15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tableau de bord',
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Mis à jour: 2 Sept 2023',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                height: height,
                width: width,
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.1,
                      mainAxisSpacing: 25,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                imgSrc[index],
                                width: 100,
                              ),
                              Text(
                                titles[index],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
