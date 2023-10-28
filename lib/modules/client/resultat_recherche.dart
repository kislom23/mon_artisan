// ignore_for_file: avoid_print, unnecessary_null_comparison, depend_on_referenced_packages, prefer_interpolation_to_compose_strings, unrelated_type_equality_checks

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nye_dowola/common/route.dart';
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

  bool isLoading = true;
  Future<void> getLocationAndSearch() async {
    setState(() {
      // Ajouter cette ligne
      isLoading = true;
    });
    await checkLocationService();
    await search();

    setState(() {
      // Ajouter cette ligne
      isLoading = false;
    });
  }

  double? clientLatitude = 1.1;
  double? clientLongitude = 1.1;

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

  double calculateDistance(
    double? clientLatitude,
    double? clientLongitude,
    double? artisanLatitude,
    double? artisanLongitude,
  ) {
    if (clientLatitude == null ||
        clientLongitude == null ||
        artisanLatitude == null ||
        artisanLongitude == null) {
      // Afficher un message d'erreur ou retourner une valeur par défaut
      return 0;
    }

    final clientLat = clientLatitude.toDouble();
    final clientLon = clientLongitude.toDouble();
    final artisanLat = artisanLatitude.toDouble();
    final artisanLon = artisanLongitude.toDouble();

    if (clientLat.isNaN ||
        clientLon.isNaN ||
        artisanLat.isNaN ||
        artisanLon.isNaN) {
      // Afficher un message d'erreur ou retourner une valeur par défaut
      return 0;
    }

    final distanceInMeters = Geolocator.distanceBetween(
      clientLat,
      clientLon,
      artisanLat,
      artisanLon,
    );

    // Convertir la distance en kilomètres
    final distanceInKm = distanceInMeters / 1000;

    return distanceInKm;
  }

  TextEditingController searchController = TextEditingController();

  Future<void> search() async {
    if (clientLatitude == null || clientLongitude == null) {
      // Afficher un message d'erreur ou retourner une valeur par défaut
      return;
    }

    final url = Uri.parse('$urlServer/api/v1/auth/offre-service/$searchTerm');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List<dynamic>;

      final data = responseData.map((artisan) {
        final localisation = artisan['localisation'];

        double? artisanLatitude;
        double? artisanLongitude;

        if (localisation != null && localisation is Map) {
          final latitude = localisation['latitude'];
          final longitude = localisation['longitude'];
          if (latitude != null && longitude != null) {
            final latitudeStr = latitude.toString();
            final longitudeStr = longitude.toString();

            // Vérifier que les valeurs de latitude et longitude sont valides (peuvent être converties en double).
            if (double.tryParse(latitudeStr) != null &&
                double.tryParse(longitudeStr) != null) {
              artisanLatitude = double.parse(latitudeStr);
              artisanLongitude = double.parse(longitudeStr);
              print('Latitude: $artisanLatitude, Longitude: $artisanLongitude');
            } else {
              print('Erreur de conversion de latitude ou longitude');
            }
          } else {
            // Gérer le cas où latitude ou longitude sont nulles ici.
            print('Latitude ou longitude nulle');
          }
        } else {
          // Gérer le cas où localisation est nulle ici.
          print('Localisation nulle');
        }

        if (artisanLatitude != null && artisanLongitude != null) {
          final artisanDistance = calculateDistance(
            clientLatitude!,
            clientLongitude!,
            artisanLatitude,
            artisanLongitude,
          );

          // Ajouter la distance à l'objet artisan
          artisan['distance'] = artisanDistance;

          return artisan;
        } else {
          // Gérer le cas où artisanLatitude ou artisanLongitude ne sont pas valides.
          return {...artisan, 'distance': double.infinity};
        }
      }).toList();

      data.sort((a, b) => a['distance'].compareTo(b['distance']));

      setState(() {
        this.data = data;
        print(data);
      });
    }
  }

  Future<void> search2() async {
    String term = searchController.text;
    print(term);

    final url = Uri.parse('$urlServer/api/v1/auth/offre-service/$term');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List<dynamic>;

      final data = responseData.map((artisan) {
        final localisation = artisan['localisation'];

        double? artisanLatitude;
        double? artisanLongitude;

        if (localisation != null && localisation is Map) {
          final latitude = localisation['latitude'];
          final longitude = localisation['longitude'];
          if (latitude != null && longitude != null) {
            final latitudeStr = latitude.toString();
            final longitudeStr = longitude.toString();

            // Vérifier que les valeurs de latitude et longitude sont valides (peuvent être converties en double).
            if (double.tryParse(latitudeStr) != null &&
                double.tryParse(longitudeStr) != null) {
              artisanLatitude = double.parse(latitudeStr);
              artisanLongitude = double.parse(longitudeStr);
              print('Latitude: $artisanLatitude, Longitude: $artisanLongitude');
            } else {
              print('Erreur de conversion de latitude ou longitude');
            }
          } else {
            // Gérer le cas où latitude ou longitude sont nulles ici.
            print('Latitude ou longitude nulle');
          }
        } else {
          // Gérer le cas où localisation est nulle ici.
          print('Localisation nulle');
        }

        if (artisanLatitude != null && artisanLongitude != null) {
          final artisanDistance = calculateDistance(
            clientLatitude!,
            clientLongitude!,
            artisanLatitude,
            artisanLongitude,
          );

          // Ajouter la distance à l'objet artisan
          artisan['distance'] = artisanDistance;

          return artisan;
        } else {
          // Gérer le cas où artisanLatitude ou artisanLongitude ne sont pas valides.
          return {...artisan, 'distance': double.infinity};
        }
      }).toList();

      data.sort((a, b) => a['distance'].compareTo(b['distance']));

      setState(() {
        this.data = data;
        print(data);
        searchController.clear();
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
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : data.isEmpty
                      ? Center(
                          child: Text(
                          "Aucune donnée à afficher",
                          style: GoogleFonts.poppins(fontSize: 15),
                        ))
                      : ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final artisan = data[index];
                            final artisanName = artisan['nom'];
                            final artisanPrenom = artisan['prenom'];
                            final artisanPhoto = artisan['photo_profil'];
                            final artisanServices = artisan['offreServices'];
                            final artisanPrestations = artisan['prestations'];
                            final artisanDis = artisan['distance'];
                            String km = artisanDis.toStringAsFixed(1);
                            final artisanPrestationService =
                                artisanPrestations[0]['id'];
                            final localisation = artisan['localisation'];
                            print(localisation);

                            String artisanLatitude = '0.0';
                            String artisanLongitude = '0.0';
                            if (localisation != null && localisation is Map) {
                              artisanLatitude =
                                  localisation['latitude'].toString();
                              artisanLongitude =
                                  localisation['longitude'].toString();
                            }

                            Uint8List? photoProfil;

                            if (artisanPhoto != null) {
                              photoProfil = Uint8List.fromList(
                                  base64Decode(artisanPhoto));
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
                                    categorieService['categorieService'] !=
                                        null) {
                                  categorie =
                                      categorieService['categorieService'];
                                }

                                return Card(
                                  color: Colors.white,
                                  elevation: 1.0,
                                  child: ListTile(
                                    leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
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
                                      child: SizedBox(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '$km km',
                                            ),
                                            const Icon(
                                              Icons.arrow_right,
                                              size: 30,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
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
