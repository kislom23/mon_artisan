// ignore_for_file: avoid_print, unnecessary_null_comparison, depend_on_referenced_packages, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
    getLocationAndSearch();
  }

  Future<void> getLocationAndSearch() async {
    await checkLocationService();
    search();
  }

  double clientLatitude = 0.0;
  double clientLongitude = 0.0;

  Future<void> checkLocationService() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
    } else if (permission == LocationPermission.denied) {
      await Geolocator.openAppSettings();
    } else {
      Position? position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (position != null) {
        setState(() {
          clientLatitude = position.latitude;
          clientLongitude = position.longitude;
          print(clientLatitude);
          print(clientLongitude);
        });
      } else {
        // La position du client est null
        print('Impossible d\'obtenir la position du client');
      }
    }
  }

  double calculateDistance(double? artisanLatitude, double? artisanLongitude) {
    if (artisanLatitude == null || artisanLongitude == null) {
      return double.infinity;
    }

    if (clientLatitude == 0.0 || clientLongitude == 0.0) {
      return double.infinity;
    }

    final clientLat = clientLatitude.toDouble();
    final clientLon = clientLongitude.toDouble();
    final artisanLat = artisanLatitude.toDouble();
    final artisanLon = artisanLongitude.toDouble();

    final distanceInMeters = Geolocator.distanceBetween(
      clientLat,
      clientLon,
      artisanLat,
      artisanLon,
    );

    return distanceInMeters;
  }

  TextEditingController searchController = TextEditingController();

  Future<void> search() async {
    final url =
        Uri.parse('http://10.0.2.2:9000/api/v1/auth/offre-service/$searchTerm');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);

      for (final artisan in responseData) {
        final localisation = artisan['localisation'];

        double artisanLatitude;
        double artisanLongitude;

        if (localisation != null &&
            localisation != 'null' &&
            localisation is Map) {
          final latitude = localisation['latitude'];
          final longitude = localisation['longitude'];
          if (latitude != null && longitude != null) {
            artisanLatitude = double.tryParse(latitude.toString()) ?? 0.0;
            artisanLongitude = double.tryParse(longitude.toString()) ?? 0.0;
            print(artisanLatitude);
            print(artisanLongitude);
          } else {
            // Gérer le cas où latitude ou longitude sont nulles ici.
            artisanLatitude = 0.0;
            artisanLongitude = 0.0;
          }
        } else {
          // Gérer le cas où localisation est nulle ici.
          artisanLatitude = 0.0;
          artisanLongitude = 0.0;
        }

        if (artisanLatitude != null && artisanLongitude != null) {
          final artisanDistance =
              calculateDistance(artisanLatitude, artisanLongitude);

          // Ajouter la distance à l'objet artisan
          artisan['distance'] = artisanDistance;

          responseData.sort((a, b) => a['distance'].compareTo(b['distance']));
        } else {
          // Gérer le cas où artisanLatitude ou artisanLongitude sont nuls ici.
          artisan['distance'] = double.infinity;
        }
      }

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

      for (final artisan in responseData) {
        final localisation = artisan['localisation'];
        double artisanLatitude;
        double artisanLongitude;

        if (localisation != null && localisation is Map) {
          final latitude = localisation['latitude'];
          final longitude = localisation['longitude'];
          if (latitude != null && longitude != null) {
            artisanLatitude = double.tryParse(latitude.toString()) ?? 0.0;
            artisanLongitude = double.tryParse(longitude.toString()) ?? 0.0;
            print(artisanLatitude);
            print(artisanLongitude);
          } else {
            // Gérer le cas où latitude ou longitude sont nulles ici.
            artisanLatitude = 0.0;
            artisanLongitude = 0.0;
          }
        } else {
          // Gérer le cas où localisation est nulle ici.
          artisanLatitude = 0.0;
          artisanLongitude = 0.0;
        }

        if (artisanLatitude != null && artisanLongitude != null) {
          final artisanDistance =
              calculateDistance(artisanLatitude, artisanLongitude);

          // Ajouter la distance à l'objet artisan
          artisan['distance'] = artisanDistance;

          responseData.sort((a, b) => a['distance'].compareTo(b['distance']));
        } else {
          // Gérer le cas où artisanLatitude ou artisanLongitude sont nuls ici.
          artisan['distance'] = double.infinity;
        }
      }

      setState(() {
        data = responseData;

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
                        final localisation = artisan['localisation'];
                        print(localisation);

                        String artisanLatitude = '0.0';
                        String artisanLongitude = '0.0';
                        if (localisation != null && localisation is Map) {
                          artisanLatitude = localisation['latitude'].toString();
                          artisanLongitude =
                              localisation['longitude'].toString();
                        }

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
                                                  'assets/images/LOGO-01.png')),
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
                                              latitude: artisanLatitude,
                                              longitude: artisanLongitude,
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
