// ignore_for_file: file_names, unnecessary_null_comparison, avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nye_dowola/common/route.dart';
import 'package:nye_dowola/common/square_tile.dart';
import 'package:nye_dowola/modules/client/mapPage.dart';
import 'package:nye_dowola/modules/payement/cinetpay.dart';
import 'package:url_launcher/url_launcher.dart';

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
    super.key,
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
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

String nom = "";
String comment = "";
int nombreEtoiles = 1;
int idSer = 1;

final nomController = TextEditingController();
final commentController = TextEditingController();

Uri url = Uri.parse('$urlServer/api/v1/no/note_service/ajouter');

Future notez() async {
  nom = nomController.text;
  comment = commentController.text;

  if (nom.isEmpty || comment.isEmpty) {
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
      'nom_client': nom,
      'commentaire': comment,
      'etoile': nombreEtoiles,
      'prestationSer': {
        'id': idSer,
      },
    }),
  );

  if (res.statusCode == 200) {
    Fluttertoast.showToast(
      msg: "Artisan notez avec success",
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
    );
    nomController.clear();
    commentController.clear();
  } else {
    Fluttertoast.showToast(
      msg: "Erreur lors de la notation, ressayer plus tard",
      gravity: ToastGravity.BOTTOM,
      fontSize: 16,
    );
  }
}

Future openDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remplissez '),
        content: SizedBox(
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nomController,
                  decoration:
                      const InputDecoration(hintText: 'Entrer vôtre nom'),
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
                  onRatingUpdate: (index) {
                    nombreEtoiles = index.toInt();
                    print(nombreEtoiles);
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: commentController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Entrer vôtre commentaire',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              notez();
              Navigator.of(context).pop();
            },
            child: const Text(
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: widget.photo != null
                  ? Image.memory(
                      widget.photo!,
                      fit: BoxFit.cover,
                    )
                  : const Image(
                      image: AssetImage('assets/images/7309681.jpg'),
                    ),
            ),
            buttonArrow(context),
            scroll(),
          ],
        ),
      ),
    );
  }

  buttonArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          clipBehavior: Clip.hardEdge,
          height: 55,
          width: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.arrow_back_ios,
                  size: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  scroll() {
    return DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 1.0,
        minChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 5,
                          width: 35,
                          color: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${widget.nom} ${widget.prenom}',
                    style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.categorie,
                    style: GoogleFonts.poppins(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          widget.email,
                          style: GoogleFonts.poppins(color: Colors.black),
                        ),
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange,
                        child: Icon(
                          Icons.phone,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      widget.numTelephone != null &&
                              widget.numTelephone != 'null'
                          ? Text(
                              widget.numTelephone,
                            )
                          : Text(
                              'Pas défini',
                              style: GoogleFonts.poppins(),
                            ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      color: Colors.grey,
                      height: 4,
                    ),
                  ),
                  Text(
                    "Description",
                    style: GoogleFonts.poppins(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.description,
                    style: GoogleFonts.poppins(),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      color: Colors.grey,
                      height: 4,
                    ),
                  ),
                  Text(
                    "Opérations",
                    style: GoogleFonts.poppins(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => MapPage(
                                    artLon: widget.longitude,
                                    artLat: widget.latitude))),
                          );
                        },
                        child: const SquareTile(
                            imagePath: 'assets/images/map.png'),
                      ),

                      const SizedBox(width: 20),

                      GestureDetector(
                        onTap: () async {
                          /*String phoneNumber = widget.numTelephone;
                          if (phoneNumber == null || phoneNumber == "null") {
                            Fluttertoast.showToast(
                              msg: "L'artisan n'a pas mis à jour son profil",
                              gravity: ToastGravity.BOTTOM,
                              fontSize: 16,
                            );
                          }else{
                            FlutterPhoneDirectCaller.callNumber(phoneNumber);
                          }
                          */
                        },
                        child: const SquareTile(
                            imagePath: 'assets/images/phone-call.png'),
                      ),

                      const SizedBox(width: 20),

                      // whatsapp button
                      GestureDetector(
                        onTap: () {
                          String phoneNumber = widget.numTelephone;
                          if (phoneNumber == null || phoneNumber == "null") {
                            Fluttertoast.showToast(
                              msg: "L'artisan n'a pas mis à jour son profil",
                              gravity: ToastGravity.BOTTOM,
                              fontSize: 16,
                            );
                          } else {
                            final Uri url =
                                Uri.parse('https://wa.me/$phoneNumber');
                            launchUrl(url);
                          }
                        },
                        child: const SquareTile(
                            imagePath: 'assets/images/whatsapp.png'),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    child: Divider(
                      color: Colors.grey,
                      height: 4,
                    ),
                  ),
                  Text(
                    "Plus",
                    style: GoogleFonts.poppins(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              idSer = widget.prestationService;
                            });
                            print(idSer);
                            openDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: Text(
                            'Notez ${widget.prenom}',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 150,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const CinetPay())),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: Text(
                            'Payez ${widget.prenom}',
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
