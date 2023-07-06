// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DashbordPage extends StatefulWidget {
  const DashbordPage({Key? key}) : super(key: key);

  @override
  State<DashbordPage> createState() => _DashbordPageState();
}

class _DashbordPageState extends State<DashbordPage> {
  @override
  Widget build(BuildContext context) {
    //final userEmail = ModalRoute.of(context)?.settings.arguments as String;
    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: const AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            Text(
              'Ici,',
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'Vous trouverez les statistiques en rapport à votre profil, vos offres de services, et vos prestations de services.',
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Vous y trouverez aussi vos meilleurs commentaires et notes de prestattions de services',
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Au plaisir de vous revoir, je dis bonsoir et heureux de vous comptee parmi nos artisans 😉',
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            ),
          ],
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
                hintText: "Recherche....",
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
