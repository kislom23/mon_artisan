// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/square_tile.dart';

class DetailsPage extends StatefulWidget {
  final String nom;
  final String prenom;
  final String email;
  final String numTelephone;
  final String nomDuService;
  final String categorie;
  final String description;
  final Uint8List? photo;
  final String prestationService;

  const DetailsPage({
    Key? key,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.numTelephone,
    required this.nomDuService,
    required this.categorie,
    required this.photo,
    required this.description,
    required this.prestationService,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: widget.photo != null
                      ? Image.memory(
                          widget.photo!,
                          fit: BoxFit.cover,
                        )
                      : const Image(
                          image: AssetImage('assets/images/télécharger.png')),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                widget.nomDuService,
                style: GoogleFonts.poppins(fontSize: 15, color: Colors.black),
              ),
            ),
            Center(
              child: Text(
                '${widget.nom} ${widget.prenom}',
                style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    leading: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.orange,
                      ),
                      child: const Icon(
                        LineAwesomeIcons.envelope,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      widget.email,
                      style: GoogleFonts.poppins(fontSize: 11),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    leading: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.orange,
                      ),
                      child: const Icon(
                        LineAwesomeIcons.phone,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      widget.numTelephone,
                      style: GoogleFonts.poppins(fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Catégorie de service :   ',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.categorie,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Description : ${widget.description}',
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 250,
              height: 40,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    side: BorderSide.none, shape: const StadiumBorder()),
                child: Text(
                  'Notez ${widget.prenom}',
                  style: GoogleFonts.poppins(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // google button
                GestureDetector(
                  onTap: () {},
                  child: const SquareTile(imagePath: 'assets/images/map.png'),
                ),

                const SizedBox(width: 20),

                GestureDetector(
                  onTap: () {
                    String phoneNumber = widget.numTelephone;
                    final Uri url = Uri.parse('tel:$phoneNumber');
                    launchUrl(url);
                  },
                  child: const SquareTile(
                      imagePath: 'assets/images/phone-call.png'),
                ),

                const SizedBox(width: 20),

                // apple button
                GestureDetector(
                  onTap: () {
                    String phoneNumber = widget.numTelephone;
                    final Uri url = Uri.parse('https://wa.me/$phoneNumber');
                    launchUrl(url);
                  },
                  child:
                      const SquareTile(imagePath: 'assets/images/whatsapp.png'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
