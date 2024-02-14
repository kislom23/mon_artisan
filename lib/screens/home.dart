// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers, avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nye_dowola/modules/auth/Register.dart';
import 'package:nye_dowola/modules/client/resultat_recherche.dart';
import 'package:nye_dowola/screens/components/categories_card.dart';
import 'package:url_launcher/url_launcher.dart';

import '../modules/auth/Login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List imagesList = [
    {
      "id": 1,
      "image_url":
          "https://st2.depositphotos.com/1010613/11754/i/950/depositphotos_117548714-stock-photo-plumber-repairing-sink-in-bathroom.jpg"
    },
    {
      "id": 2,
      "image_url":
          "https://images.unsplash.com/photo-1534789266363-adfa086f3f63?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
    },
    {
      "id": 3,
      "image_url":
          "https://images.unsplash.com/photo-1505798577917-a65157d3320a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"
    },
  ];
  final CarouselController carouselController = CarouselController();
  int curentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //slider
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 0),
              child: CarouselSlider(
                items: imagesList
                    .map((item) => ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            item['image_url'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ))
                    .toList(),
                carouselController: carouselController,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  height: 150,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 2,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      curentIndex = index;
                    });
                  },
                ),
              ),
            ),
            //slider select
            Positioned(
              bottom: 5,
              top: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imagesList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => carouselController.animateToPage(entry.key),
                    child: Container(
                      width: curentIndex == entry.key ? 17 : 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: curentIndex == entry.key
                              ? Colors.orange
                              : Colors.grey),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            //Services
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                height: 40,
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Categories',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Tout voir >',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            //Services card
            Container(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  CustomCard(
                      text: "Artisanat",
                      imagePath: "assets/images/pottery.png",
                      onTap: () {}),
                  CustomCard(
                      text: "Bâtiment",
                      imagePath: "assets/images/skyline.png",
                      onTap: () {}),
                  CustomCard(
                      text: "Alimentation",
                      imagePath: "assets/images/wheat.png",
                      onTap: () {}),
                  CustomCard(
                      text: "Commerce",
                      imagePath: "assets/images/store.png",
                      onTap: () {})
                ],
              ),
            ),
            //Recommend for
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                height: 40,
                child: const Column(children: [
                  Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Recommander pour vous',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                      )),
                    ],
                  ),
                ]),
              ),
            ),
            //Recommend user
            Container(
              height: 260,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 228, 228, 228),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/Profil_artisan_contenu_btp-1024x683.jpg",
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "John DOE",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Lomé - Vakpossito",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              RatingBar.builder(
                                initialRating: 4,
                                minRating: 4,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 14,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orange),
                                onRatingUpdate: (index) {},
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(120, 30),
                                    backgroundColor: Colors.orange,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Voir plus',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 228, 228, 228),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/artisan.jpg",
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "DEH Kodzo",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Lomé - Minamadou",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              RatingBar.builder(
                                initialRating: 3,
                                minRating: 3,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 14,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orange),
                                onRatingUpdate: (index) {},
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(120, 30),
                                    backgroundColor: Colors.orange,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Voir plus',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 20),
                    child: InkWell(
                      onTap: () {},
                      child: Container(
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 228, 228, 228),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/images/7309681.jpg",
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                "Eugène LARE",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Lomé - Hedzanawoe",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              RatingBar.builder(
                                initialRating: 4,
                                minRating: 4,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 14,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.orange),
                                onRatingUpdate: (index) {},
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(120, 30),
                                    backgroundColor: Colors.orange,
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    'Voir plus',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Rej comm
            const SizedBox(height: 40),
            //Dev artisan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Rejoingnez la communauté,',
                  style: TextStyle(
                      color: Colors.grey, fontFamily: 'Poppins', fontSize: 14),
                ),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()));
                  },
                  child: const Text(
                    'Devenez artisan',
                    style: TextStyle(
                      color: Colors.orange,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

enum _MenuValue { devenirartisan, contacter, asistance }

class AppBar extends StatefulWidget implements PreferredSizeWidget {
  const AppBar({
    super.key,
  });

  @override
  State<AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _AppBarState extends State<AppBar> {
  TextEditingController searchController = TextEditingController();

  void pageRecherche() {
    String searchTerm = searchController.text;

    if (searchTerm.isNotEmpty) {
      print(searchTerm);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultatPage(searchTerm: searchTerm),
        ),
      );
      searchController.clear();
    } else {
      print("searchTerm vide");
    }
  }

  void _sendEmail() async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: 'nyedowolatogo@gmail.com',
      query: 'subject=ASSISANCE&body=Mon%20corps%20du%20message',
    );

    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      throw 'Impossible de lancer ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Image(
                image: AssetImage("assets/images/LOGO-01.png"),
                height: 60,
              ),
              PopupMenuButton<_MenuValue>(
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: _MenuValue.devenirartisan,
                    child: Text('Se connecter'),
                  ),
                  const PopupMenuItem(
                      value: _MenuValue.contacter,
                      child: Text('Nous contacter')),
                  const PopupMenuItem(
                      value: _MenuValue.asistance, child: Text('Assistance')),
                ],
                onSelected: (value) {
                  switch (value) {
                    case _MenuValue.devenirartisan:
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (c) => const LoginPage()));
                      break;
                    case _MenuValue.contacter:
                      _sendEmail();
                      break;
                    case _MenuValue.asistance:
                      _sendEmail();
                      break;
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 0),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 0),
            width: MediaQuery.of(context).size.width,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(60, 199, 199, 199),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextFormField(
              controller: searchController,
              onFieldSubmitted: (_) => pageRecherche(),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Rechercher le service dont vous avez besoin...",
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.9),
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
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
