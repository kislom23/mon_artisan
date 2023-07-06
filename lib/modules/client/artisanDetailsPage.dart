// ignore_for_file: file_names

import 'package:flutter/material.dart';

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
        title: const Text('Détails de l\'artisan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nom: ${widget.nom}'),
            Text('Prénom: ${widget.prenom}'),
            Text('Email: ${widget.email}'),
            Text('Numéro de téléphone: ${widget.numTelephone}'),
            const SizedBox(height: 20),
            Text('Service: ${widget.nomDuService}'),
            Text('Catégorie: ${widget.categorie}'),
            Text('Description: ${widget.description}'),
          ],
        ),
      ),
    );
  }
}
