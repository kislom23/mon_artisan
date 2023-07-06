// ignore_for_file: file_names

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

  const DetailsPage(
      {Key? key,
      required this.nom,
      required this.prenom,
      required this.email,
      required this.numTelephone,
      required this.nomDuService,
      required this.categorie,
      required this.description})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LineAwesomeIcons.arrow_left),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.nomDuService,
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                      image: AssetImage('assets/images/télécharger.png')),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.grey.withOpacity(0.1),
                ),
                child: const Icon(
                  LineAwesomeIcons.envelope,
                  color: Color.fromARGB(255, 45, 43, 107),
                ),
              ),
              title: Text(
                widget.email,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
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
                  LineAwesomeIcons.phone,
                  color: Color.fromARGB(255, 45, 43, 107),
                ),
              ),
              title: Text(
                widget.numTelephone,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 2,
            ),
            Row(
              children: [
                Text(
                  'Service :   ',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 45, 43, 107),
                  ),
                ),
                Text(
                  widget.nomDuService,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Catégorie :   ',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 45, 43, 107),
                  ),
                ),
                Text(
                  widget.categorie,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  ),
                ),
              ],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // google button
                GestureDetector(
                  onTap: () {
                    String phoneNumber = widget.numTelephone;
                    final Uri url = Uri.parse('tel:$phoneNumber');
                    launchUrl(url);
                  },
                  child: const SquareTile(
                      imagePath: 'assets/images/telephone.png'),
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
