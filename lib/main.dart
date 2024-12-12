import 'package:denis/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent)
      ),
      // animasi splash screen
      home: const SplashScreen(),
      routes: {
        'splash': (context) => const SplashScreen(),
        'home': (context) => const MyApp()
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.orange.shade500,
          centerTitle: true,
          // google fonts
          title: Text(
            'Profil',
            style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ),
        endDrawer: const AppNavigationDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 35,
              ),
              // animated logo
              const AnimatedLogo(),
              const SizedBox(
                height: 25,
              ),
              // google fonts
              Text(
                'Denis Manuhutu',
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    const Text(
                      "Halo, saya adalah seorang mahasiswa teknik informatika di ITB STIKOM AMBON tahun ke-3 lahir dan besar di Soahuku maluku tengah.",
                      style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 38,
                    ),
                    Row(
                      children: [
                        Text("Hobi", style: TextStyle(
                          fontSize: 18
                        ),)
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Chip(label: Text("Main Bola")),
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Chip(label: Text("Main Game")),
                        ),
                        Chip(label: Text("Ngoding")),

                      ],
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    Row(
                      children: [
                        Text("Makanan Kesukaan", style: TextStyle(
                            fontSize: 18
                        ),)
                      ],
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Chip(label: Text("Ayam goreng")),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Chip(label: Text("Sate Ayam")),
                        ),

                      ],
                    ),
                  ],
                )
              ),
            ],
          ),
        )
    );
  }
}

class AnimatedLogo extends StatefulWidget {
  const AnimatedLogo({super.key});

  @override
  State<AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> {
  bool isZoomed = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.only(bottom: isZoomed ? 50.0 : 0),
        child: GestureDetector(
          onTap: () {
            setState(() {
              isZoomed = !isZoomed;
            });
          },
          child: AnimatedScale(
            scale: isZoomed ? 1.3 : 1.0,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isZoomed ? 20 : 75),
                // Menambahkan border tipis agar terlihat lebih bagus
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(isZoomed ? 20 : 75),
                child: Image.asset(
                  fit: BoxFit.cover,
                  'assets/foto.jpeg',
                  width: 150,
                  height: 150, // Menambahkan height agar gambar tetap persegi
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text(
              'Denis Manuhutu',
              style: TextStyle(color: Colors.white),
            ),
            accountEmail: const Text('denistahanora2003@gmail.com',
                style: TextStyle(color: Colors.white)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  fit: BoxFit.cover,
                  'assets/foto.jpeg',
                  width: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(
                color: Colors.cyan,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/background.jpg")
                )
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              if(currentRoute == 'home') {
                Navigator.pop(context);
              } else {
                Navigator.of(context).pushReplacementNamed('home');
              }
            },
          ),
          ListTile(
            // font awesome icon
            leading: const Icon(FontAwesomeIcons.github),
            title: const Text('Github'),
            onTap: () async {
              final Uri url =
              Uri.parse('https://github.com/OnlyDenis17');
              if (await canLaunchUrl(url)) {
                await launchUrl(url,
                    mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          ListTile(
            // font awesome icon
            leading: const Icon(FontAwesomeIcons.instagram),
            title: const Text('Instagram'),
            onTap: () async {
              final Uri url =
              Uri.parse('https://www.instagram.com/den_manuhutu/');
              if (await canLaunchUrl(url)) {
                await launchUrl(url,
                    mode: LaunchMode.externalApplication);
              } else {
                throw 'Could not launch $url';
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    title: const Text('Logout'),
                    content:
                    const Text('Apakah anda yakin ingin keluar?'),
                    actions: [
                      TextButton(
                          child: const Text('Batal'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      TextButton(
                          child: const Text(
                            'Keluar',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            SystemNavigator.pop();
                          }),
                    ]),
              );
            },
          ),
        ],
      ),
    );
  }

}
