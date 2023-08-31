// ignore_for_file: file_names, unnecessary_null_comparison

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  final int prestationService;
  final String latitude;
  final String longitude;

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
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

Future openDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remplissez'),
        content: SizedBox(
          height: 250,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TextField(
                  decoration: InputDecoration(hintText: 'Entrer vôtre nom'),
                ),
                const SizedBox(
                  height: 20,
                ),
                RatingBar.builder(
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 14,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.orange),
                  onRatingUpdate: (index) {},
                ),
                const SizedBox(
                  height: 20,
                ),
                const TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Entrer vôtre commentaire',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: const [
          TextButton(
            onPressed: null,
            child: Text(
              'Envoyer',
              style: TextStyle(fontSize: 20, color: Colors.orange),
            ),
          )
        ],
      ),
    );

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ignore: sized_box_for_whitespace
          Container(
            width: double.infinity,
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: widget.photo != null
                  ? Image.memory(
                      widget.photo!,
                      fit: BoxFit.cover,
                    )
                  : const Image(
                      image: AssetImage('assets/images/télécharger.png')),
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
                    style: GoogleFonts.poppins(fontSize: 12),
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
                  title: widget.numTelephone != null &&
                          widget.numTelephone != 'null'
                      ? Text(
                          widget.numTelephone,
                          style: GoogleFonts.poppins(fontSize: 15),
                        )
                      : Text(
                          'Pas défini',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Description : ${widget.description}',
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 250,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                openDialog(context);
              },
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
                child:
                    const SquareTile(imagePath: 'assets/images/phone-call.png'),
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
    );
  }
}
