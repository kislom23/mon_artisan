import 'package:flutter/material.dart';

class ResultatPage extends StatefulWidget {
  final String searchTerm;

  const ResultatPage({Key? key, required this.searchTerm}) : super(key: key);

  @override
  State<ResultatPage> createState() => _ResultatPageState();
}

class _ResultatPageState extends State<ResultatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultats de recherche'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Résultats de recherche pour :',
              style: TextStyle(fontSize: 20.0),
            ),

            const SizedBox(height: 16.0),
            // Autre barre de recherche pour de nouvelles recherches
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nouveau terme de recherche',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) {
                // Effectuer une nouvelle recherche avec le nouveau terme
              },
            ),
          ],
        ),
      ),
    );
  }
}
