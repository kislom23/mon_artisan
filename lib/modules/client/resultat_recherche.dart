// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nye_dowola/modules/client/artisanDetailsPage.dart';

class ResultatPage extends StatefulWidget {
  final String searchTerm;

  const ResultatPage({Key? key, required this.searchTerm}) : super(key: key);

  @override
  State<ResultatPage> createState() => _ResultatPageState();
}

class _ResultatPageState extends State<ResultatPage> {
  late String searchTerm;
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    searchTerm = widget.searchTerm;
    search();
  }

  TextEditingController searchController = TextEditingController();

  Future<void> search() async {
    final url =
        Uri.parse('http://10.0.2.2:9000/api/v1/auth/offre-service/$searchTerm');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      setState(() {
        data = responseData;
        print(data);
      });
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

  Future<void> search2() async {
    String term = searchController.text;
    print(term);

    final url =
        Uri.parse('http://10.0.2.2:9000/api/v1/auth/offre-service/$term');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      setState(() {
        data = responseData;
        print(data);
        setState(() {
          searchController.clear();
        });
      });
    } else {
      print("Erreur: ${response.statusCode}");

      setState(() {
        data = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 35),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true,
                      //fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Quel service avez besoin ?",
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.orange,
                    ),
                    onSubmitted: (value) {
                      searchTerm = value;
                      search2();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: data.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun Résultat',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final artisan = data[index];
                        final artisanName = artisan['nom'];
                        final artisanPrenom = artisan['prenom'];
                        final artisanPhoto = artisan['photo_profil'];
                        final artisanServices = artisan['offreServices'];
                        final artisanPrestations = artisan['prestations'];
                        final artisanPrestationService =
                            artisanPrestations[0]['id'];
                        Uint8List? photoProfil;

                        if (artisanPhoto != null) {
                          photoProfil =
                              Uint8List.fromList(base64Decode(artisanPhoto));
                        }

                        for (var service in artisanServices) {
                          if (service != null &&
                              service is Map &&
                              service['nomDuService'] != null &&
                              service['nomDuService']
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchTerm.toLowerCase())) {
                            final serviceName =
                                service['nomDuService'].toString();
                            final categorieService =
                                service['categorieDeService'];

                            String categorie = "";
                            if (categorieService != null &&
                                categorieService['categorieService'] != null) {
                              categorie = categorieService['categorieService'];
                            }

                            return Card(
                              color: Colors.white,
                              elevation: 1.0,
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(60),
                                      child: photoProfil != null
                                          ? Image.memory(
                                              photoProfil,
                                              fit: BoxFit.cover,
                                            )
                                          : const Image(
                                              image: AssetImage(
                                                  'assets/images/télécharger.png')),
                                    )),
                                title: Text(
                                  '$artisanName $artisanPrenom',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  serviceName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: ((context) => DetailsPage(
                                              prestationService:
                                                  artisanPrestationService,
                                              photo: photoProfil,
                                              nom: artisanName,
                                              prenom: artisanPrenom,
                                              email: artisan['email'],
                                              numTelephone:
                                                  artisan['num_telephone']
                                                      .toString(),
                                              nomDuService:
                                                  service['nomDuService'],
                                              categorie: categorie,
                                              description: service[
                                                  'descriptionDuService'],
                                            )),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.arrow_right,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }
                        }
                        // Si aucun service ne correspond à la recherche pour cet artisan, on retourne un widget vide
                        return const SizedBox.shrink();
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
