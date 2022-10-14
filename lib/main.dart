import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:kicaredfinal/color_schemes.g.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:kicaredfinal/core/constant/color.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:kicaredfinal/AccountPage.dart';
import 'package:kicaredfinal/AddNotes.dart';
import 'package:kicaredfinal/ListOfNotes.dart';
import 'package:kicaredfinal/SettingsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
final places =
GoogleMapsPlaces(apiKey: "AIzaSyDxHTMa3DWyVOJaKFtRJQsbpRbTq697X9U");
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomeScreen(),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
    );
  }
}
//Welcome Screen
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width:double.infinity,
        decoration: const BoxDecoration(
          image:
          DecorationImage(
            image: AssetImage("assets/welcome.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "KiCared",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ],
              ),
            ),
            const RoundedButton(),
          ],
        ),
      ),
    );
  }
}
//Welcome Button
class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:  () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MyPage(),
            ),
          );
        },
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 15),
                  blurRadius: 30,
                  color: const Color(0xFF666666).withOpacity(.11),
                ),
              ],
            ),
            child: const Text("Start caring", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Itim'))
        )
    );
  }
}
//Initial Setting
class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Authentication(),
    );
  }
}
//Authentication
class Authentication extends StatelessWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return const SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration()
            ],
          );
        }
        return Navifirst();
      },
    );
  }
}
class Navifirst extends StatefulWidget {
  Navifirst({Key? key}) : super(key: key);
  @override
  State<Navifirst> createState() => _NavifirstState();
}
class _NavifirstState extends State<Navifirst> {
  late PageController _myPage;
  int selectedPage = 0;
  void initState() {
    super.initState();
    _myPage = PageController(initialPage: 0);
    selectedPage = 0;
  }

  List<IconData> iconlist = [
    Icons.home_outlined,
    // Icons.book,
    Icons.child_care_rounded,
    Icons.perm_identity_rounded,

  ];
  List<Widget> _currentpage = [
    HomeScreen(),
    // ListOfNotes(),
    XY2(),
    Settings2(),

  ];
  int _bottomnavindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentpage[_bottomnavindex],
      floatingActionButtonLocation:
      FloatingActionButtonLocation.miniEndDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        shadow: BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 5,
          spreadRadius: 0.1,
        ),
        leftCornerRadius: 17,
        rightCornerRadius: 17,
        gapLocation: GapLocation.none,
        activeColor: Color(0xffe91e63),
        inactiveColor: Color(0xff0d47a1),
        icons: iconlist,
        activeIndex: _bottomnavindex,
        onTap: (index) => setState(() {
          _bottomnavindex = index;
          selectedPage = index;
        }),
      ),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final fb = FirebaseStorage.instance.ref().child("Profile");
  var currentUser = FirebaseAuth.instance.currentUser;
  String imageUrl = "";


  @override
  Widget build(BuildContext context) {
    fb.child(currentUser!.uid).child("picture").getDownloadURL().then((value) {
      if (mounted) {
        setState(() {
          imageUrl = value;
        });
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white
        ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('KiCared',
                      style: TextStyle(fontSize: 34, fontFamily: 'Itim', fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 380,
              height: 120,
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Keep your child happy', style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 23, fontFamily: 'Itim'
                  )),
                  Row(
                      children: const [
                        Text('Make the moment', style: TextStyle(fontSize: 18,  fontFamily: 'Itim') ),
                      ])
                ],
              ),
            ),
            const SizedBox(height: 30),

            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color:   Colors.grey[50],
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 10,
                                  )
                                ]
                            ),
                            child: Center(
                              child: Image.asset('assets/newhealth.png'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                  return HealthInformation();
                                })
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('Health',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )
                        ),
                      ]
                  ),
                  Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.yellow[50],
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 10,
                                  )
                                ]
                            ),
                            child: Center(
                              child: Image.asset('assets/vaccination.png'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                  return VaccinationInformation();
                                })
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('Vaccination',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )
                        ),
                      ]
                  ),

                  Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.pink[50],
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 10,
                                  )
                                ]
                            ),
                            child: Center(
                              child: Image.asset('assets/hospital.png'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                  return MedicalLocation();
                                })
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('Hospital',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )
                        ),
                      ]
                  ),

                ]
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color:  Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 10,
                                  )
                                ]
                            ),
                            child: Center(
                              child: Image.asset('assets/todo.png'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                  return ToDo();
                                })
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('To-Do',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )
                        ),
                      ]
                  ),
                  Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.teal[50],
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 10,
                                  )
                                ]
                            ),
                            child: Center(
                              child: Image.asset('assets/musicnew.png'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                  return MusicList();
                                })
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('Music',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )
                        ),
                      ]
                  ),

                  Column(
                      children: [
                        GestureDetector(
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue[50],
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 10,
                                  )
                                ]
                            ),
                            child: Center(
                              child: Image.asset('assets/pharmacy.png'),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                  return PharmacyLocation();
                                })
                            );
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text('Pharmacy',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            )
                        ),
                      ]
                  ),
                ]
            ),
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
                child: Container(
                    padding: const EdgeInsets.only(left: 10.0),
                    height: 110.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey.shade100
                    ),
                    child: Row(
                      children: <Widget> [
                        IconButton(
                          icon: Icon(Icons.book_rounded, color: Colors.pink[100],
                          ),
                          iconSize: 50.0,
                          onPressed: () {},
                        ),
                        const SizedBox(width: 5.0),
                        Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget> [
                                Text('Precious Diary',
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0
                                  ),
                                ),
                                const Text(
                                  'Add an update',
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  ),
                                )
                              ],
                            )
                        ),
                        const SizedBox(width: 100.0),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            iconSize: 25.0,
                            onPressed: (){
                              Navigator.push(context,
                                  MaterialPageRoute<void>(builder: (BuildContext context) {
                                    return ListOfNotes();
                                  })
                              );
                            }
                        ),
                      ],
                    )
                )
            ),
          ],
        ),
      ),


      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(25)),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${currentUser?.email}', style: TextStyle(fontFamily: 'Itim', fontSize: 15, color: Colors.blueGrey)),
              accountEmail: Text('Hello, beautiful day again! How are you?', style: TextStyle(fontFamily: 'Itim',fontSize: 15,color: Colors.blueGrey)),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute<void>(builder: (BuildContext context) {
                        return const Settings();
                      })
                  );
                },
              child: CircleAvatar(
                backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl): null,
              ),
              ),
              decoration: BoxDecoration(
                color:  Color(0xffefdada),
              ),
            ),
            ListTile(
              title: const Text('Health Information',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return const HealthInformation();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Vaccination Information',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return const VaccinationInformation();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Diary',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return ListOfNotes();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Pharmacy Nearby',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return PharmacyLocation();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Hospital Nearby',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return MedicalLocation();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Musics for Kids',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return const MusicList();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Xylophone',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return XY();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('To Do List',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return ToDo();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Profile',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (BuildContext context) {
                      return Settings();
                    })
                );
              },
            ),
            ListTile(
              title: const Text('Log Out',style: TextStyle(
                fontFamily: 'Itim',)),
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

//Health Information List
class HealthInformation extends StatefulWidget {
  const HealthInformation({Key? key}) : super(key: key);
  @override
  State<HealthInformation> createState() => _HealthInformationState();
}
class _HealthInformationState extends State<HealthInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Health Information", style: TextStyle(fontFamily: 'Itim', fontSize: 25)),
        ),
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                  children: [
                    Container(
                        width: 350,
                        child: Text("Respiratory", style: TextStyle(fontFamily: "Itim", fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left)

                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const CommonCold();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xffefdada),
                        ),
                        child: Row(
                          children: <Widget> [
                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Common Cold',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0

                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 175.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const Infuenza();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: Color(0xfffff3ef)
                        ),
                        child: Row(
                          children: <Widget> [

                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Influenza',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(
                                width: 210
                            ),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),

                    const SizedBox(height: 10.0),
                    Container(
                        width: 350,
                        child: Text("Eye/Ear", style: TextStyle(fontFamily: "Itim", fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left)

                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const Conjunctivitis();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xffefe6e9),
                        ),
                        child: Row(
                          children: <Widget> [

                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Conjunctivitis',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 180.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const EarInfections();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xfff9f0fa),
                        ),
                        child: Row(
                          children: <Widget> [
                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Ear Infections',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 180.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                        width: 350,
                        child: Text("Digestive", style: TextStyle(fontFamily: "Itim", fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left)

                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return Gastro();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color:    Color(0xfff8fae2),
                        ),
                        child: Row(
                          children: <Widget> [

                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Gastro',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 240.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color:  Color(0xfffffcf2),
                      ),
                      child: Row(
                        children: <Widget> [

                          const SizedBox(width: 5.0),
                          Padding(
                              padding: const EdgeInsets.only(top: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget> [
                                  Text(
                                    'Rotavirus',
                                    style: TextStyle(
                                        fontFamily: 'Itim',
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                                ],
                              )
                          ),
                          const SizedBox(width: 220.0),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              iconSize: 25.0,
                              onPressed: (){}
                          ),
                        ],
                      ),

                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xfff1eef5),
                      ),
                      child: Row(
                        children: <Widget> [

                          const SizedBox(width: 5.0),
                          Padding(
                              padding: const EdgeInsets.only(top: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget> [
                                  Text(
                                    'Tetanus',
                                    style: TextStyle(
                                        fontFamily: 'Itim',
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                                ],
                              )
                          ),
                          const SizedBox(width: 229.0),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              iconSize: 25.0,
                              onPressed: (){}
                          ),
                        ],
                      ),

                    ),

                  ]
              )
          ),
        )


    );
  }
}
//Vaccination Information
class VaccinationInformation extends StatefulWidget {
  const VaccinationInformation({Key? key}) : super(key: key);
  @override
  State<VaccinationInformation> createState() => _VaccinationInformationState();
}
class _VaccinationInformationState extends State<VaccinationInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Vaccination Information", style: TextStyle(fontFamily: 'Itim',fontSize: 25)),
        ),
        body: SafeArea(
            child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute<void>(builder: (BuildContext context) {
                            return const FirstV();
                          })
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xffefdada),
                      ),
                      child: Row(
                        children: <Widget> [
                          const SizedBox(width: 5.0),
                          Padding(
                              padding: const EdgeInsets.only(top: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget> [

                                  Text(
                                    'Hepatitis B',
                                    style: TextStyle(
                                        fontFamily: 'Itim',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              )
                          ),
                          const SizedBox(width: 193.0),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              iconSize: 25.0,
                              onPressed: (){}
                          ),
                        ],
                      ),

                    ),
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute<void>(builder: (BuildContext context) {
                            return const SecondV();
                          })
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color:     Color(0xffefe6e9),
                      ),
                      child: Row(
                        children: <Widget> [

                          const SizedBox(width: 5.0),
                          Padding(
                              padding: const EdgeInsets.only(top: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget> [

                                  Text(
                                    'Rotavirus',
                                    style: TextStyle(
                                        fontFamily: 'Itim',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                                ],
                              )
                          ),
                          const SizedBox(width: 210.0),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              iconSize: 25.0,
                              onPressed: (){}
                          ),
                        ],
                      ),

                    ),
                  ),
                  const SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute<void>(builder: (BuildContext context) {
                            return const ThirdV();
                          })
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color:     Color(0xfff9f0fa),
                      ),
                      child: Row(
                        children: <Widget> [
                          const SizedBox(width: 5.0),
                          Padding(
                              padding: const EdgeInsets.only(top: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget> [

                                  Text(
                                    'Diphtheris',
                                    style: TextStyle(
                                        fontFamily: 'Itim',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                                ],
                              )
                          ),
                          const SizedBox(width: 205.0),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              iconSize: 25.0,
                              onPressed: (){}
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    height: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color:     Color(0xfff1eef5),
                    ),
                    child: Row(
                      children: <Widget> [

                        const SizedBox(width: 5.0),
                        Padding(
                            padding: const EdgeInsets.only(top: 27.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget> [
                                Text(
                                  'Haemophilus Influenza type b',
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  ),
                                )
                              ],
                            )
                        ),
                        const SizedBox(width: 35.0),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            iconSize: 25.0,
                            onPressed: (){}
                        ),
                      ],
                    ),

                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    height: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color:     Color(0xfff8fae2),
                    ),
                    child: Row(
                      children: <Widget> [

                        const SizedBox(width: 5.0),
                        Padding(
                            padding: const EdgeInsets.only(top: 27.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget> [
                                Text(
                                  'Pneumococcal conjugate',
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  ),
                                )
                              ],
                            )
                        ),
                        const SizedBox(width: 80.0),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            iconSize: 25.0,
                            onPressed: (){}
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    height: 80.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color:     Color(0xfffffcf2),
                    ),
                    child: Row(
                      children: <Widget> [

                        const SizedBox(width: 5.0),
                        Padding(
                            padding: const EdgeInsets.only(top: 27.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget> [
                                Text(
                                  'Inactivated poliovirus',
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  ),
                                )
                              ],
                            )
                        ),
                        const SizedBox(width: 107.0),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            iconSize: 25.0,
                            onPressed: (){}
                        ),
                      ],
                    ),

                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    padding: const EdgeInsets.only(left: 30.0),
                    height: 80.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color:     Color(0xfffff3ef)
                    ),
                    child: Row(
                      children: <Widget> [

                        const SizedBox(width: 5.0),
                        Padding(
                            padding: const EdgeInsets.only(top: 27.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget> [
                                Text(
                                  'Varicella',
                                  style: TextStyle(
                                      fontFamily: 'Itim',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0
                                  ),
                                )
                              ],
                            )
                        ),
                        const SizedBox(width: 222.0),
                        IconButton(
                            icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                            iconSize: 25.0,
                            onPressed: (){}
                        ),
                      ],
                    ),

                  ),

                ]
            )
        )


    );
  }
}
//To-do-list
class ToDo extends StatefulWidget {

  @override
  _ToDoState createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final fb = FirebaseDatabase.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('todos').child(currentUser!.uid);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[350],
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => addnote(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Todos',
          style: TextStyle(
            fontSize: 25,
            color: Color(0xff0d47a1),
            fontFamily: 'Itim',
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Color(0xfff1eef5),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.blueGrey[900],
                    ),
                    onPressed: () {
                      ref.child(snapshot.key!).remove();
                    },
                  ),
                  title: Text(
                    snapshot.value.toString(),
                    style: const TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
//to-do-list-addnote
class addnote extends StatelessWidget {
  TextEditingController title = TextEditingController();
  final fb = FirebaseDatabase.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('todos').child(currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todos", style: TextStyle(fontFamily: 'Itim')),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
              width: 10,
            ),
            // Container(
            //   decoration: BoxDecoration(borderColor: Colors.),
            TextField(
              controller: title,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                hintText: '   Add your todos',
                hintStyle: TextStyle(fontFamily: "Itim", fontSize: 20),
              ),
            ),
            // ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Color(0xffefe6e9),
              onPressed: () {
                ref
                    .push()
                    .set(
                  title.text,
                )
                    .asStream();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => ToDo()));
              },
              child: const Text(
                "Save",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Itim',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Music List
class MusicList extends StatefulWidget {
  const MusicList({Key? key}) : super(key: key);
  @override
  State<MusicList> createState() => _MusicListState();
}
class _MusicListState extends State<MusicList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music for kids", style: TextStyle(fontFamily: 'Itim', fontSize: 25)),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
              child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    Container(
                        width: 350,
                        child: Text("Lullaby", style: TextStyle(fontFamily: "Itim", fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left)

                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const MusicPlayer();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xffefdada),
                        ),
                        child: Row(
                          children: <Widget> [
                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Forest',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0

                                      ),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 240.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const Music2();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xffefe6e9),
                        ),
                        child: Row(
                          children: <Widget> [

                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Good Night',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 200.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return const Music3();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xfff9f0fa),
                        ),
                        child: Row(
                          children: <Widget> [
                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Soft Daydream',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 170.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                        width: 350,
                        child: Text("Living Noise", style: TextStyle(fontFamily: "Itim", fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left)

                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return vaccum();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xfff1eef5),
                        ),
                        child: Row(
                          children: <Widget> [

                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Vaccum Cleaner',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 160.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return Rain();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color:    Color(0xfff8fae2),
                        ),
                        child: Row(
                          children: <Widget> [

                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Rain',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 255.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute<void>(builder: (BuildContext context) {
                              return Siren();
                            })
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 30.0),
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color:  Color(0xfffffcf2),
                        ),
                        child: Row(
                          children: <Widget> [

                            const SizedBox(width: 5.0),
                            Padding(
                                padding: const EdgeInsets.only(top: 27.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const <Widget> [
                                    Text(
                                      'Siren',
                                      style: TextStyle(
                                          fontFamily: 'Itim',
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 20.0
                                      ),
                                    )
                                  ],
                                )
                            ),
                            const SizedBox(width: 255.0),
                            IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                                iconSize: 25.0,
                                onPressed: (){}
                            ),
                          ],
                        ),

                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                        width: 350,
                        child: Text("Relaxing", style: TextStyle(fontFamily: "Itim", fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.left)

                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute<void>(builder: (BuildContext context) {
                                return precious();
                              })
                          );
                        },
                    child: Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                          color: Color(0xfffff3ef)
                      ),
                      child: Row(
                        children: <Widget> [

                          const SizedBox(width: 5.0),
                          Padding(
                              padding: const EdgeInsets.only(top: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget> [
                                  Text(
                                    'Precious moment',
                                    style: TextStyle(
                                        fontFamily: 'Itim',
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                                ],
                              )
                          ),
                          const SizedBox(width: 150.0),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              iconSize: 25.0,
                              onPressed: (){}
                          ),
                        ],
                      ),

                    ),
                    ),
                    const SizedBox(height: 10.0),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute<void>(builder: (BuildContext context) {
                                return breeze();
                              })
                          );
                        },
                    child: Container(
                      padding: const EdgeInsets.only(left: 30.0),
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color(0xfff1eef5),
                      ),
                      child: Row(
                        children: <Widget> [

                          const SizedBox(width: 5.0),
                          Padding(
                              padding: const EdgeInsets.only(top: 27.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const <Widget> [
                                  Text(
                                    'Breeze',
                                    style: TextStyle(
                                        fontFamily: 'Itim',
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 20.0
                                    ),
                                  )
                                ],
                              )
                          ),
                          const SizedBox(width: 230.0),
                          IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                              iconSize: 25.0,
                              onPressed: (){}
                          ),
                        ],
                      ),

                    ),
                    ),

                  ]
              )
          )
      ),

    );
  }
}

//First music
class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key}) : super(key: key);

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  //setting the project url
  String img_cover_url =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";
  late AudioPlayer advancedPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  void initPlayer() async {
    await advancedPlayer.setSource(AssetSource("forest.mp3"));
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    }); });
    advancedPlayer.onPositionChanged.listen((p) {setState(() {
      _position = p;
    }); });
  }

  //init the player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advancedPlayer = AudioPlayer();
    initPlayer();

  }

  @override
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Musics for Kids", style: TextStyle(fontFamily: "Itim",fontSize: 25)),),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/forest.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/forest.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Forest",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 6,  fontFamily: "Itim"),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 30.0, //50
              ),
              const SizedBox(
                height: 20.0, //50
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _position.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (value){},
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value:_position.inSeconds.toDouble(),
                    onChangeEnd: (double value){
                      setState((){
                        changeToSecond(value.toInt());
                        value = value;
                      });
                      advancedPlayer.pause();
                      advancedPlayer.seek(Duration(seconds: value.toInt()));
                      advancedPlayer.resume();
                    },

                    activeColor: Colors.white,
                  ),

                  Text(
                    _duration.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink),
                      ),
                      child: InkWell(
                        onTap: () async{
                          if (isPlaying) {
                            await advancedPlayer.pause();
                            setState((){
                              isPlaying = false;
                            });
                          } else {
                            await advancedPlayer.resume();
                            setState((){
                              isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause: Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
//2
class Music2 extends StatefulWidget {
  const Music2({Key? key}) : super(key: key);

  @override
  State<Music2> createState() => _Music2State();
}

class _Music2State extends State<Music2> {
  String img_cover_url =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";
  late AudioPlayer advancedPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  void initPlayer() async {
    await advancedPlayer.setSource(AssetSource("goodnight.mp3"));
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    }); });
    advancedPlayer.onPositionChanged.listen((p) {setState(() {
      _position = p;
    }); });
  }

  //init the player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advancedPlayer = AudioPlayer();
    initPlayer();

  }

  @override
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Musics for Kids", style: TextStyle(fontFamily: "Itim", fontSize: 25)),),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/goodnight.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/goodnight.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Goodnight",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 6, fontFamily: "Itim"),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 30.0, //50
              ),
              const SizedBox(
                height: 20.0, //50
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _position.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (value){},
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value:_position.inSeconds.toDouble(),
                    onChangeEnd: (double value){
                      setState((){
                        changeToSecond(value.toInt());
                        value = value;
                      });
                      advancedPlayer.pause();
                      advancedPlayer.seek(Duration(seconds: value.toInt()));
                      advancedPlayer.resume();
                    },

                    activeColor: Colors.white,
                  ),

                  Text(
                    _duration.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink),
                      ),
                      child: InkWell(
                        onTap: () async{
                          if (isPlaying) {
                            await advancedPlayer.pause();
                            setState((){
                              isPlaying = false;
                            });
                          } else {
                            await advancedPlayer.resume();
                            setState((){
                              isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause: Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}//

class Music3 extends StatefulWidget {
  const Music3({Key? key}) : super(key: key);

  @override
  State<Music3> createState() => _Music3State();
}

class _Music3State extends State<Music3> {
  //setting the project url
  String img_cover_url =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";
  late AudioPlayer advancedPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  void initPlayer() async {
    await advancedPlayer.setSource(AssetSource("softdaydream.mp3"));
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    }); });
    advancedPlayer.onPositionChanged.listen((p) {setState(() {
      _position = p;
    }); });
  }

  //init the player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advancedPlayer = AudioPlayer();
    initPlayer();

  }

  @override
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Musics for Kids", style: TextStyle(fontFamily: "Itim", fontSize: 25)),),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/softdaydream.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/softdaydream.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Soft Daydream",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 6,  fontFamily: "Itim"),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 30.0, //50
              ),
              const SizedBox(
                height: 20.0, //50
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _position.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (value){},
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value:_position.inSeconds.toDouble(),
                    onChangeEnd: (double value){
                      setState((){
                        changeToSecond(value.toInt());
                        value = value;
                      });
                      advancedPlayer.pause();
                      advancedPlayer.seek(Duration(seconds: value.toInt()));
                      advancedPlayer.resume();
                    },

                    activeColor: Colors.white,
                  ),

                  Text(
                    _duration.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink),
                      ),
                      child: InkWell(
                        onTap: () async{
                          if (isPlaying) {
                            await advancedPlayer.pause();
                            setState((){
                              isPlaying = false;
                            });
                          } else {
                            await advancedPlayer.resume();
                            setState((){
                              isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause: Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
//vaccum
class vaccum extends StatefulWidget {
  const vaccum({Key? key}) : super(key: key);

  @override
  State<vaccum> createState() => _vaccumState();
}

class _vaccumState extends State<vaccum> {
  //setting the project url
  String img_cover_url =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";
  late AudioPlayer advancedPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  void initPlayer() async {
    await advancedPlayer.setSource(AssetSource("vaccum.mp3"));
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    }); });
    advancedPlayer.onPositionChanged.listen((p) {setState(() {
      _position = p;
    }); });
  }

  //init the player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advancedPlayer = AudioPlayer();
    initPlayer();

  }

  @override
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Musics for Kids", style: TextStyle(fontFamily: "Itim", fontSize: 25)),),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/vaccum.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/vaccum.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Vaccum",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 6,  fontFamily: "Itim"),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _position.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (value){},
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value:_position.inSeconds.toDouble(),
                    onChangeEnd: (double value){
                      setState((){
                        changeToSecond(value.toInt());
                        value = value;
                      });
                      advancedPlayer.pause();
                      advancedPlayer.seek(Duration(seconds: value.toInt()));
                      advancedPlayer.resume();
                    },

                    activeColor: Colors.white,
                  ),

                  Text(
                    _duration.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink),
                      ),
                      child: InkWell(
                        onTap: () async{
                          if (isPlaying) {
                            await advancedPlayer.pause();
                            setState((){
                              isPlaying = false;
                            });
                          } else {
                            await advancedPlayer.resume();
                            setState((){
                              isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause: Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
//Rain
class Rain extends StatefulWidget {
  const Rain({Key? key}) : super(key: key);

  @override
  State<Rain> createState() => _RainState();
}

class _RainState extends State<Rain> {
  //setting the project url
  String img_cover_url =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";
  late AudioPlayer advancedPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  void initPlayer() async {
    await advancedPlayer.setSource(AssetSource("rain.mp3"));
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    }); });
    advancedPlayer.onPositionChanged.listen((p) {setState(() {
      _position = p;
    }); });
  }

  //init the player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advancedPlayer = AudioPlayer();
    initPlayer();

  }

  @override
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Musics for Kids", style: TextStyle(fontFamily: "Itim", fontSize: 25)),),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/rain.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/rain.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Rain",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 6,  fontFamily: "Itim"),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _position.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (value){},
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value:_position.inSeconds.toDouble(),
                    onChangeEnd: (double value){
                      setState((){
                        changeToSecond(value.toInt());
                        value = value;
                      });
                      advancedPlayer.pause();
                      advancedPlayer.seek(Duration(seconds: value.toInt()));
                      advancedPlayer.resume();
                    },

                    activeColor: Colors.white,
                  ),

                  Text(
                    _duration.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink),
                      ),
                      child: InkWell(
                        onTap: () async{
                          if (isPlaying) {
                            await advancedPlayer.pause();
                            setState((){
                              isPlaying = false;
                            });
                          } else {
                            await advancedPlayer.resume();
                            setState((){
                              isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause: Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
//Siren
class Siren extends StatefulWidget {
  const Siren({Key? key}) : super(key: key);

  @override
  State<Siren> createState() => _SirenState();
}

class _SirenState extends State<Siren> {
  //setting the project url
  String img_cover_url =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";
  late AudioPlayer advancedPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  void initPlayer() async {
    await advancedPlayer.setSource(AssetSource("rain.mp3"));
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    }); });
    advancedPlayer.onPositionChanged.listen((p) {setState(() {
      _position = p;
    }); });
  }

  //init the player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advancedPlayer = AudioPlayer();
    initPlayer();

  }

  @override
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Musics for Kids", style: TextStyle(fontFamily: "Itim", fontSize: 25)),),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/siren.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/siren.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Siren",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 6,  fontFamily: "Itim"),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 50.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _position.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (value){},
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value:_position.inSeconds.toDouble(),
                    onChangeEnd: (double value){
                      setState((){
                        changeToSecond(value.toInt());
                        value = value;
                      });
                      advancedPlayer.pause();
                      advancedPlayer.seek(Duration(seconds: value.toInt()));
                      advancedPlayer.resume();
                    },

                    activeColor: Colors.white,
                  ),

                  Text(
                    _duration.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink),
                      ),
                      child: InkWell(
                        onTap: () async{
                          if (isPlaying) {
                            await advancedPlayer.pause();
                            setState((){
                              isPlaying = false;
                            });
                          } else {
                            await advancedPlayer.resume();
                            setState((){
                              isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause: Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
//precious
class precious extends StatefulWidget {
  const precious({Key? key}) : super(key: key);

  @override
  State<precious> createState() => _preciousState();
}

class _preciousState extends State<precious> {
  //setting the project url
  String img_cover_url =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";
  late AudioPlayer advancedPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  void initPlayer() async {
    await advancedPlayer.setSource(AssetSource("precious.mp3"));
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    }); });
    advancedPlayer.onPositionChanged.listen((p) {setState(() {
      _position = p;
    }); });
  }
  Future<void> _precious() async {
    Navigator.push(context,
        MaterialPageRoute<void>(builder: (BuildContext context) {
          return const breeze();
        })
    );
  }

  //init the player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advancedPlayer = AudioPlayer();
    initPlayer();

  }

  @override
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Musics for Kids", style: TextStyle(fontFamily: "Itim", fontSize: 25)),),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/precious.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/precious.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Precious",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 6,  fontFamily: "Itim"),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 30.0, //50
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Music List", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 200),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute<void>(builder: (BuildContext context) {
                            return const breeze();
                          })
                      );
                    },
                    child: Text("Next", style: TextStyle(color: Colors.white)),
                  ),
                ],

              ),
              const SizedBox(
                height: 20.0, //50
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _position.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (value){},
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value:_position.inSeconds.toDouble(),
                    onChangeEnd: (double value){
                      setState((){
                        changeToSecond(value.toInt());
                        value = value;
                      });
                      advancedPlayer.pause();
                      advancedPlayer.seek(Duration(seconds: value.toInt()));
                      advancedPlayer.resume();
                    },

                    activeColor: Colors.white,
                  ),

                  Text(
                    _duration.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink),
                      ),
                      child: InkWell(
                        onTap: () async{
                          if (isPlaying) {
                            await advancedPlayer.pause();
                            setState((){
                              isPlaying = false;
                            });
                          } else {
                            await advancedPlayer.resume();
                            setState((){
                              isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause: Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
//breeze
class breeze extends StatefulWidget {
  const breeze({Key? key}) : super(key: key);

  @override
  State<breeze> createState() => _breezeState();
}

class _breezeState extends State<breeze> {
  //setting the project url
  String img_cover_url =
      "https://i.pinimg.com/736x/a7/a9/cb/a7a9cbcefc58f5b677d8c480cf4ddc5d.jpg";
  late AudioPlayer advancedPlayer;
  Duration _duration = new Duration();
  Duration _position = new Duration();
  bool isPlaying = false;
  bool isPaused = false;
  bool isLoop = false;

  void initPlayer() async {
    await advancedPlayer.setSource(AssetSource("breeze.mp3"));
    advancedPlayer.onDurationChanged.listen((d) {setState(() {
      _duration = d;
    }); });
    advancedPlayer.onPositionChanged.listen((p) {setState(() {
      _position = p;
    }); });
  }

  //init the player
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    advancedPlayer = AudioPlayer();
    initPlayer();

  }

  @override
  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    advancedPlayer.seek(newDuration);
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Musics for Kids", style: TextStyle(fontFamily: "Itim", fontSize: 25)),),
      body: Stack(
        children: [
          Container(
            constraints: const BoxConstraints.expand(),
            height: 300.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/breeze.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
              child: Container(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //setting the music cover
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.asset(
                  "assets/breeze.jpg",
                  width: 250.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text(
                "Breeze",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, letterSpacing: 6,  fontFamily: "Itim"),
              ),
              //Setting the seekbar
              const SizedBox(
                height: 30.0, //50
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      // Navigator.push(context,
                      //     MaterialPageRoute<void>(builder: (BuildContext context) {
                      //       return const precious();
                      //     })
                      // );
                    },
                    child: Text("Music List", style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 200),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute<void>(builder: (BuildContext context) {
                            return const breeze();
                          })
                      );
                    },
                    child: Text("Next", style: TextStyle(color: Colors.white)),
                  ),
                ],

              ),

              const SizedBox(
                height: 20.0, //50
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _position.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Slider.adaptive(
                    onChanged: (value){},
                    min: 0.0,
                    max: _duration.inSeconds.toDouble(),
                    value:_position.inSeconds.toDouble(),
                    onChangeEnd: (double value){
                      setState((){
                        changeToSecond(value.toInt());
                        value = value;
                      });
                      advancedPlayer.pause();
                      advancedPlayer.seek(Duration(seconds: value.toInt()));
                      advancedPlayer.resume();
                    },

                    activeColor: Colors.white,
                  ),

                  Text(
                    _duration.toString().split(".")[0],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
              const SizedBox(
                height: 60.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(0.5);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_rewind_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                      width: 50.0,
                      height: 50.0,
                      decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.black87,
                        border: Border.all(color: Colors.pink),
                      ),
                      child: InkWell(
                        onTap: () async{
                          if (isPlaying) {
                            await advancedPlayer.pause();
                            setState((){
                              isPlaying = false;
                            });
                          } else {
                            await advancedPlayer.resume();
                            setState((){
                              isPlaying = true;
                            });
                          }
                        },
                        child: Icon(
                          isPlaying ? Icons.pause: Icons.play_arrow,
                          color: Colors.white,
                        ),
                      )
                  ),
                  const SizedBox(
                    width: 60.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.black87,
                      border: Border.all(color: Colors.white38),
                    ),
                    width: 50.0,
                    height: 50.0,
                    child: InkWell(
                      onTapDown: (details) {
                        advancedPlayer.setPlaybackRate(2);
                      },
                      onTapUp: (details) {
                        advancedPlayer.setPlaybackRate(1);
                      },
                      child: const Center(
                        child: Icon(
                          Icons.fast_forward_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
//health information
//Common Cold
class CommonCold extends StatefulWidget {
  const CommonCold({Key? key}) : super(key: key);

  @override
  State<CommonCold> createState() => _CommonColdState();
}

class _CommonColdState extends State<CommonCold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Commmon Cold", style: TextStyle(fontFamily: 'Itim')),),
        body: Column(
            children: [
              Container(
                width: 900,
                height: MediaQuery.of(context).size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                  Image.asset('assets/cold.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0), //280
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 100,
                        height: Get.height * 0.600,  //690
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: AppColor.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 61, 61, 61).withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.02),  //0.05
                              Text(
                                "Common Cold",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 30,
                                    color: AppColor.primaryDarkColor),
                              ),
                              SizedBox(height: Get.height * 0.01), //0.03
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("The common cold is a viral infection of your nose and throat. It's usually harmless, although it might not feel that way. Many types of viruses can cause a common cold."),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "Symptoms",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Runny or stuffy nose \n2. Sore throat, cough \n3.Bodyache"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "What to do",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Take some cold medicine \n2. If the symptom is still there,recommend to go to hospital"),
                              SizedBox(height: Get.height * 0.01), //0.02
                              Container(
                                height: MediaQuery.of(context).size.height*0.10,
                                width: 370,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 8,
                                        blurRadius: 7,
                                        offset:
                                        const Offset(1, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child:
                                        Text(
                                          "Hospital near me",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Oswald',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return MedicalLocation();
                                                })
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height:MediaQuery.of(context).size.height * 0.05,
                                            width:
                                            MediaQuery.of(context).size.width * 0.90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(
                                                      1, 1), // changes position of shadow
                                                ),
                                              ],
                                              color: AppColor.primaryDarkColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 233, 229, 229),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
//Infuenza
class Infuenza extends StatefulWidget {
  const Infuenza({Key? key}) : super(key: key);

  @override
  State<Infuenza> createState() => _InfuenzaState();
}

class _InfuenzaState extends State<Infuenza> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Influenza", style: TextStyle(fontFamily: 'Itim')),),
        body: Column(
            children: [
              Container(
                // width: double.infinity,
                width: 900,
                height: MediaQuery.of(context).size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                  Image.asset('assets/influenza.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0), //280
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 100,
                        height: Get.height * 0.599,  //690
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: AppColor.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 61, 61, 61).withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * 0.02),  //0.05
                              Text(
                                "Influenza",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 30,
                                    color: AppColor.primaryDarkColor),
                              ),
                              SizedBox(height: Get.height * 0.01), //0.03
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("Flu is a contagious respiratory illness caused by\ninfluenza viruses that infect the nose, throat, and sometimes the lungs. It can cause mild to severe illness,\nand at times can lead to death"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "Symptoms",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Fever \n2.Cough \n3. Muscle or body aches"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "What to do",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Take some cold medicine \n2. Drink hot water and rest well"),
                              SizedBox(height: Get.height * 0.01), //0.02
                              Container(
                                height: MediaQuery.of(context).size.height*0.12,
                                width: 370,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 8,
                                        blurRadius: 7,
                                        offset:
                                        const Offset(1, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child:
                                        Text(
                                          "Hospital near me",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Oswald',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return MedicalLocation();
                                                })
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: MediaQuery.of(context).size.height * 0.04,
                                            width:
                                            MediaQuery.of(context).size.width * 0.90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(
                                                      1, 1), // changes position of shadow
                                                ),
                                              ],
                                              color: AppColor.primaryDarkColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 233, 229, 229),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
//Conjunctivitis
class Conjunctivitis extends StatefulWidget {
  const Conjunctivitis({Key? key}) : super(key: key);

  @override
  State<Conjunctivitis> createState() => _ConjunctivitisState();
}

class _ConjunctivitisState extends State<Conjunctivitis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Conjunctivitis"),),
        body: Column(
            children: [
              Container(
                // width: double.infinity,
                width: 900,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                  Image.asset('assets/conjunctivitis.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0), //280
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 100,
                        height: Get.height * 0.599,  //690
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: AppColor.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 61, 61, 61).withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.01),  //0.05
                              Text(
                                "Conjunctivitis",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: AppColor.primaryDarkColor),
                              ),
                              SizedBox(height: Get.height * 0.01), //0.03
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("Conjunctivitis is an inflammation or infection of the transparent membrane that lines your eyelid and covers the white part of your eyeball."),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "Symptoms",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Redness in one or both eyes \n2. Swelling of the conjunctiva\n3. Itching, irritation, and/or burning"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "What to do",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Gently wiping eyelashes with water to clean off crusts with a clean cotton wool pad \n 2. Hold a cold flannel on eyes for a few minutes to cool them down. \n 3. If the symptom is still there,recommend to go to hospital"),
                              SizedBox(height: Get.height * 0.01), //0.02
                              Container(
                                height: 80,
                                width: 370,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 8,
                                        blurRadius: 7,
                                        offset:
                                        const Offset(1, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute<void>(builder: (BuildContext context) {
                                            return MedicalLocation();
                                          })
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:
                                          Text(
                                            "Hospital near me",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: "OpenSans",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 25,
                                            width:
                                            MediaQuery.of(context).size.width * 0.90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(
                                                      1, 1), // changes position of shadow
                                                ),
                                              ],
                                              color: AppColor.primaryDarkColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 233, 229, 229),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
//EarInfections
class EarInfections extends StatefulWidget {
  const EarInfections({Key? key}) : super(key: key);

  @override
  State<EarInfections> createState() => _EarInfectionsState();
}

class _EarInfectionsState extends State<EarInfections> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Ear Infections", style: TextStyle(fontFamily: 'Itim', fontSize: 25)),),
        body: Column(
            children: [
              Container(
                // width: double.infinity,
                width: 900,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                  Image.asset('assets/earinfection.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0), //280
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 100,
                        height: Get.height * 0.599,  //690
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: AppColor.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 61, 61, 61).withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.02),  //0.05
                              Text(
                                "Ear Infections",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: AppColor.primaryDarkColor),
                              ),
                              SizedBox(height: Get.height * 0.01), //0.03
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("Ear infection is an infection of the middle ear, the air-filled space behind the eardrum that contains the tiny vibrating bones of the ear."),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "Symptoms",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Ear pain, especially when lying down \n 2. Tugging or pulling at an ear \n 3. Trouble sleeping \n 4.Loss of balance"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "What to do",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Place a warm or cold flannel on the ear \n 2. Remove any discharge by wiping the ear with cotton \n 3. If symptoms are still there,recommend to go to hospital"),
                              SizedBox(height: Get.height * 0.02), //0.02
                              Container(
                                height: 100,
                                width: 370,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 8,
                                        blurRadius: 7,
                                        offset:
                                        const Offset(1, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute<void>(builder: (BuildContext context) {
                                            return MedicalLocation();
                                          })
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child:
                                          Text(
                                            "Hospital near me",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: "OpenSans",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width:
                                            MediaQuery.of(context).size.width * 0.90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(
                                                      1, 1), // changes position of shadow
                                                ),
                                              ],
                                              color: AppColor.primaryDarkColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 233, 229, 229),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
//Gastro
class Gastro extends StatefulWidget {
  const Gastro({Key? key}) : super(key: key);

  @override
  State<Gastro> createState() => _GastroState();
}

class _GastroState extends State<Gastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Gastro", style: TextStyle(fontFamily: 'Itim')),),
        body: Column(
            children: [
              Container(
                // width: double.infinity,
                width: 900,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                  Image.asset('assets/gastro1.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0), //280
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 100,
                        height: Get.height * 0.599,  //690
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: AppColor.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 61, 61, 61).withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.02),  //0.05
                              Text(
                                "Gastro",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 30,
                                    color: AppColor.primaryDarkColor),
                              ),
                              SizedBox(height: Get.height * 0.01), //0.03
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("Gastro is a common and often highly infectious condition that affects the stomach and intestines. It can cause vomiting and diarrhoea."),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "Symptoms",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Stomach pain \n 2. Cramping \n 3. Fever \n 4.Nausea"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "What to do",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.blue[200]),
                              ),
                              const Text("1. Stop eating solid foods\n2. Try anti-diarrhea medications\n3. Get plenty of rest \n 3. If the symptom is still there,recommend to go to hospital"),
                              SizedBox(height: Get.height * 0.01), //0.02
                              Container(
                                height: 100,
                                width: 370,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 8,
                                        blurRadius: 7,
                                        offset:
                                        const Offset(1, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child:
                                        Text(
                                          "Hospital near me",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Oswald',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return MedicalLocation();
                                                })
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width:
                                            MediaQuery.of(context).size.width * 0.90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(
                                                      1, 1), // changes position of shadow
                                                ),
                                              ],
                                              color: AppColor.primaryDarkColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 233, 229, 229),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
//Vaccination 1
class FirstV extends StatefulWidget {
  const FirstV({Key? key}) : super(key: key);

  @override
  State<FirstV> createState() => _FirstVState();
}

class _FirstVState extends State<FirstV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Hepatitis B", style: TextStyle(fontFamily: 'Itim')),),
        body: Column(
            children: [
              Container(
                // width: double.infinity,
                width: 1000,
                height: 230,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                  Image.asset('assets/HB.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0), //280
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 100,
                        height: Get.height * 0.599,  //690
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: AppColor.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 61, 61, 61).withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.02),  //0.05
                              Text(
                                "Hepatitis B",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 32,
                                    color: AppColor.primaryDarkColor),
                              ),
                              SizedBox(height: Get.height * 0.01), //0.03
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("Hepatitis B is a vaccine-preventable liver infection\ncaused by the hepatitis B virus. Hepatitis B is spread\nwhen blood, semen, or other body fluids from a person infected with the virus enters the body of someone who is not infected. "),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "Number of Doses",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("3"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "When",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("First dose: Birth \nSecond dose: Between 1 month and 2 months \nThird dose: Between 6 months and 18 months"),
                              SizedBox(height: Get.height * 0.01), //0.02

                              Container(
                                height: 100,
                                width: 370,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 8,
                                        blurRadius: 7,
                                        offset:
                                        const Offset(1, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child:
                                        Text(
                                          "Hospital near me",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Oswald',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return MedicalLocation();
                                                })
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width:
                                            MediaQuery.of(context).size.width * 0.90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(
                                                      1, 1), // changes position of shadow
                                                ),
                                              ],
                                              color: AppColor.primaryDarkColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 233, 229, 229),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
//Second V
class SecondV extends StatefulWidget {
  const SecondV({Key? key}) : super(key: key);

  @override
  State<SecondV> createState() => _SecondVState();
}

class _SecondVState extends State<SecondV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Rotavirus", style: TextStyle(fontFamily: 'Itim')),),
        body: Column(
            children: [
              Container(
                // width: double.infinity,
                width: 1000,
                height: 230,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                  Image.asset('assets/rotavirus.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0), //280
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 100,
                        height: Get.height * 0.599,  //690
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: AppColor.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 61, 61, 61).withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.02),  //0.05
                              Text(
                                "Rotavirus",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 32,
                                    color: AppColor.primaryDarkColor),
                              ),
                              SizedBox(height: Get.height * 0.01), //0.03
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("Rotavirus is a very contagious virus that causes diarrhea.\n It’s very contagious and is the most common cause of diarrhea in infants and young children worldwide."),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "Number of Doses",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("3"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "When",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("First dose: 2 months \nSecond dose: 4 months \nThird dose: 6 months"),
                              SizedBox(height: Get.height * 0.01), //0.02
                              SizedBox(height: 15),
                              Container(
                                height: 100,
                                width: 370,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 8,
                                        blurRadius: 7,
                                        offset:
                                        const Offset(1, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child:
                                        Text(
                                          "Hospital near me",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Oswald',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return MedicalLocation();
                                                })
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width:
                                            MediaQuery.of(context).size.width * 0.90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(
                                                      1, 1), // changes position of shadow
                                                ),
                                              ],
                                              color: AppColor.primaryDarkColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 233, 229, 229),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}
//Third V
class ThirdV extends StatefulWidget {
  const ThirdV({Key? key}) : super(key: key);

  @override
  State<ThirdV> createState() => _ThirdVState();
}

class _ThirdVState extends State<ThirdV> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Diphtheris", style: TextStyle(fontFamily: 'Itim')),),
        body: Column(
            children: [
              Container(
                // width: double.infinity,
                width: 1000,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child:
                  Image.asset('assets/diphtheria.jpg', fit: BoxFit.cover),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 0), //280
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 100,
                        height: Get.height * 0.599,  //690
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40),
                          ),
                          color: AppColor.backgroundColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 61, 61, 61).withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(3, 4), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: Get.height * 0.02),  //0.05
                              Text(
                                "Diphetheria",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 32,
                                    color: AppColor.primaryDarkColor),
                              ),
                              SizedBox(height: Get.height * 0.01), //0.03
                              Text(
                                "Description",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("The common cold is a viral infection of your nose and throat. It's usually harmless, although it might not feel that way. Many types of viruses can cause a common cold."),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "Number of doses",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("5"),
                              SizedBox(height: Get.height * 0.01),
                              Text(
                                "When",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Oswald',
                                    fontSize: 20,
                                    color: Colors.pink[200]),
                              ),
                              const Text("First dose: 2 months\nSecond dose: 4 months\nThird dose: Between 7 months and 17 months\nFourth dose: 18 months\nFifth dose: 4-6 years"),
                              SizedBox(height: Get.height * 0.01), //0.02
                              SizedBox(height: 15),
                              Container(
                                height: 100,
                                width: 370,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 8,
                                        blurRadius: 7,
                                        offset:
                                        const Offset(1, 1), // changes position of shadow
                                      ),
                                    ],
                                    color: AppColor.backgroundColor,
                                    borderRadius: BorderRadius.circular(17)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child:
                                        Text(
                                          "Hospital near me",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Oswald',
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute<void>(builder: (BuildContext context) {
                                                  return MedicalLocation();
                                                })
                                            );
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 30,
                                            width:
                                            MediaQuery.of(context).size.width * 0.90,
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey.withOpacity(0.2),
                                                  spreadRadius: 1,
                                                  blurRadius: 2,
                                                  offset: const Offset(
                                                      1, 1), // changes position of shadow
                                                ),
                                              ],
                                              color: AppColor.primaryDarkColor,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Text(
                                              "Search",
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 233, 229, 229),
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]
        )
    );
  }
}

class MedicalLocation extends StatefulWidget {
  const MedicalLocation({Key? key}) : super(key: key);

  @override
  State<MedicalLocation> createState() => _MedicalLocationState();
}

class _MedicalLocationState extends State<MedicalLocation> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Hospital Near Me", style: TextStyle(fontFamily: 'Itim')), backgroundColor: Colors.white,),
        body: FoodieMap()
    );
  }
}

class FoodieMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FoodieMapState();
  }
}

class _FoodieMapState extends State<FoodieMap> {
  Future<Position>? _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = Geolocator.getCurrentPosition();
  }

  Future<void> _retrieveNearbyRestaurants(LatLng _userLocation) async {
    PlacesSearchResponse _response = await places.searchNearbyWithRadius(
        Location(lat: _userLocation.latitude, lng: _userLocation.longitude), 10000,
        type: "hospital");

    Set<Marker> _restaurantMarkers = _response.results
        .map((result) => Marker(
        markerId: MarkerId(result.name),
        // Use an icon with different colors to differentiate between current location
        // and the restaurants
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
            title: result.name,
            snippet: "Ratings: " + (result.rating?.toString() ?? "Not Rated")),
        position: LatLng(
            result.geometry!.location.lat, result.geometry!.location.lng)))
        .toSet();

    setState(() {
      _markers.addAll(_restaurantMarkers);
    });
  }
  // + "Address:" + (result.openingHours?.toString() ?? "No address")
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _currentLocation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // The user location returned from the snapshot
              Position snapshotData = snapshot.data as Position;
              LatLng _userLocation =
              LatLng(snapshotData.latitude, snapshotData.longitude);

              if (_markers.isEmpty) {
                _retrieveNearbyRestaurants(_userLocation);
              }

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 12,
                ),
                markers: _markers
                  ..add(Marker(
                      markerId: const MarkerId("User Location"),
                      infoWindow: const InfoWindow(title: "User Location"),
                      position: _userLocation)),
              );
            } else {
              return const Center(child: Text("Failed to get user location. Please allow your location allowance"));
            }
          }
          // While the connection is not in the done state yet
          return const Center(child: const CircularProgressIndicator());
        });
  }
}
//pharmacy location
class PharmacyLocation extends StatefulWidget {
  const PharmacyLocation({Key? key}) : super(key: key);

  @override
  State<PharmacyLocation> createState() => _PharmacyLocationState();
}

class _PharmacyLocationState extends State<PharmacyLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Pharmacy Near Me", style: TextStyle(fontFamily: 'Itim')), backgroundColor: Colors.white,),
        body: PharmacyMap());
  }
}

class PharmacyMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _PharmacyMapState();
  }
}

class _PharmacyMapState extends State<PharmacyMap> {
  Future<Position>? _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = Geolocator.getCurrentPosition();
  }

  Future<void> _retrieveNearbyRestaurants(LatLng _userLocation) async {
    PlacesSearchResponse _response = await places.searchNearbyWithRadius(
        Location(lat: _userLocation.latitude, lng: _userLocation.longitude), 10000,
        type: "pharmacy");

    Set<Marker> _pharmacyMarkers = _response.results
        .map((result) => Marker(
        markerId: MarkerId(result.name),
        // Use an icon with different colors to differentiate between current location
        // and the restaurants
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
            title: result.name,
            snippet: "Ratings: " + (result.rating?.toString() ?? "Not Rated")),
        position: LatLng(
            result.geometry!.location.lat, result.geometry!.location.lng)))
        .toSet();

    setState(() {
      _markers.addAll(_pharmacyMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _currentLocation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // The user location returned from the snapshot
              Position snapshotData = snapshot.data as Position;
              LatLng _userLocation =
              LatLng(snapshotData.latitude, snapshotData.longitude);

              if (_markers.isEmpty) {
                _retrieveNearbyRestaurants(_userLocation);
              }

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 12,
                ),
                markers: _markers
                  ..add(Marker(
                      markerId: const MarkerId("User Location"),
                      infoWindow: const InfoWindow(title: "User Location"),
                      position: _userLocation)),
              );
            } else {
              return const Center(child: Text("Failed to get user location. Please allow your location allowance"));
            }
          }
          // While the connection is not in the done state yet
          return const Center(child: CircularProgressIndicator());
        });
  }
}


class Restaurant extends StatefulWidget {
  const Restaurant({Key? key}) : super(key: key);

  @override
  State<Restaurant> createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Pharmacy Near Me", style: TextStyle(fontFamily: 'Itim')), backgroundColor: Colors.white,),
        body: RestaurantMap());
  }
}

// class Pharmacy extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         // We'll change the AppBar title later
//           appBar: AppBar(title: const Text("Pharmacy Near Me"), backgroundColor: Colors.black,),
//           body: PharmacyMap()),
//     );
//   }
// }
class RestaurantMap extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RestaurantMapState();
  }
}

class _RestaurantMapState extends State<RestaurantMap> {
  Future<Position>? _currentLocation;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _currentLocation = Geolocator.getCurrentPosition();
  }

  Future<void> _retrieveNearbyRestaurants(LatLng _userLocation) async {
    PlacesSearchResponse _response = await places.searchNearbyWithRadius(
        Location(lat: _userLocation.latitude, lng: _userLocation.longitude), 10000,
        type: "restaurant");

    Set<Marker> _pharmacyMarkers = _response.results
        .map((result) => Marker(
        markerId: MarkerId(result.name),
        // Use an icon with different colors to differentiate between current location
        // and the restaurants
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: InfoWindow(
            title: result.name,
            snippet: "Ratings: " + (result.rating?.toString() ?? "Not Rated")),
        position: LatLng(
            result.geometry!.location.lat, result.geometry!.location.lng)))
        .toSet();

    setState(() {
      _markers.addAll(_pharmacyMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _currentLocation,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // The user location returned from the snapshot
              Position snapshotData = snapshot.data as Position;
              LatLng _userLocation =
              LatLng(snapshotData.latitude, snapshotData.longitude);

              if (_markers.isEmpty) {
                _retrieveNearbyRestaurants(_userLocation);
              }

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 12,
                ),
                markers: _markers
                  ..add(Marker(
                      markerId: const MarkerId("User Location"),
                      infoWindow: const InfoWindow(title: "User Location"),
                      position: _userLocation)),
              );
            } else {
              return const Center(child: Text("Failed to get user location. Please allow your location allowance"));
            }
          }
          // While the connection is not in the done state yet
          return const Center(child: CircularProgressIndicator());
        });
  }
}

class XY extends StatefulWidget {
  const XY({Key? key}) : super(key: key);

  @override
  State<XY> createState() => _XYState();
}

class _XYState extends State<XY> {
  void playTune(int tuneNumber) async {
    final player = AudioPlayer();
    await player.play(AssetSource('note$tuneNumber.wav'));
  }

  Expanded xyloKey(Color color, int tuneNumber) {
    return Expanded(
      child: MaterialButton(
        // shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
        onPressed: () {
          playTune(tuneNumber);
        },
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Xylophone', style: TextStyle(fontFamily: "Itim")),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            xyloKey(Colors.deepPurple, 1),
            xyloKey(Colors.blue, 2),
            xyloKey(Colors.lightBlueAccent, 3),
            xyloKey(Colors.green, 4),
            xyloKey(Colors.yellow, 5),
            xyloKey(Colors.orange, 6),
            xyloKey(Colors.red, 7),
          ],
        ),
      ),
    );
  }
} //automaticallyImplyLeading: false,
//Settings2
class Settings2 extends StatefulWidget {
  const Settings2({Key? key}) : super(key: key);

  @override
  State<Settings2> createState() => _Settings2State();
}

class _Settings2State extends State<Settings2> {
  final fb = FirebaseStorage.instance.ref().child("Profile");
  var currentUser = FirebaseAuth.instance.currentUser;
  File? _image;
  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  String imageUrl = "";
  final pathReference = FirebaseStorage.instance.ref().child("Profile").child("picture");

  Future<void> _pickedImage() async {
    _pickedFile =
    await _picker.getImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      setState(() {
        _image = File(_pickedFile!.path);
      }
      );
    }
    await fb.child(currentUser!.uid).child("picture").putFile(File(_image!.path));
    // fb.child(currentUser!.uid).child("picture").getDownloadURL().then((value) {
    //   print(value);
    //   setState(() {
    //     imageUrl = value;
    //   });
    // });
    // try {
    //   final ref = FirebaseDatabase.instance.ref().child('profile').child(currentUser!.uid);
    //   await ref.putFile(_image!);
    // }
    // if (_image != null){
    //   final ref = fb.ref().child('profile').child(currentUser!.uid);
    //   ref
    //       .putFile(_image!)
    //       .onComplete;
    // }
    // if (_image != null) {
    //   //Upload to Firebase
    //   var snapshot = await fb.ref()
    //       .child('profiles')
    //       .push()
    //       .set(_image!.path);
    // }
  }
  @override
  Widget build(BuildContext context) {
    fb.child(currentUser!.uid).child("picture").getDownloadURL().then((value) {
      if (mounted) {
        setState(() {
          imageUrl = value;
        });
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Profile", style: TextStyle(fontFamily: "Itim",fontSize: 25)),
          backgroundColor: Colors.white,
          elevation: 1,
          automaticallyImplyLeading: false,
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.settings,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                // Text("User Profile",
                //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, fontFamily: 'Itim'),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                Center(
                  child: Stack(
                    children: [
                      // Container(
                      //     width: 130,
                      //     height: 130,
                      //     decoration: BoxDecoration(
                      //       border: Border.all(
                      //         width: 4,
                      //         color: Colors.blueGrey,
                      //       ),
                      //       shape: BoxShape.circle,
                      //       // image: Image(image: FileImage(_image!.path))
                      //     ),
                      // ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        // backgroundImage: _image == null ? null : FileImage(
                        //     _image!)
                        // imageUrl.isNotEmpty ? NetworkImage(imageUrl): null,
                        backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl): null,
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Color(0xffefe6e9),
                              ),
                              color: Color(0xffefe6e9),
                            ),
                            child: GestureDetector(
                              child: const Icon(
                                Icons.edit,
                                color: Colors.grey,),
                              onTap: () => _pickedImage(),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), //ref.getAuth().password.email
                Text(
                    "ID: ${currentUser?.uid}", style: TextStyle(fontFamily: 'Itim', color: Colors.black, fontSize: 15)
                ),
                SizedBox(height: 20), //ref.getAuth().password.email
                Text(
                    "Email: ${currentUser?.email}", style: TextStyle(fontFamily: 'Itim', color: Colors.black, fontSize: 16)
                ),
                SizedBox(height: 20), //ref.ge
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: new Text("Logout", style: TextStyle(fontFamily: 'Itim', color: Color(0xff0d47a1), fontSize: 16)
                  ),
                ),
              ],
            )
        )
    );
  }
}



//Settings
class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final fb = FirebaseStorage.instance.ref().child("Profile");
  var currentUser = FirebaseAuth.instance.currentUser;
  File? _image;
  PickedFile? _pickedFile;
  final _picker = ImagePicker();
  String imageUrl = "";
  final pathReference = FirebaseStorage.instance.ref().child("Profile").child("picture");

  Future<void> _pickedImage() async {
    _pickedFile =
    await _picker.getImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      setState(() {
        _image = File(_pickedFile!.path);
      }
      );
    }
    await fb.child(currentUser!.uid).child("picture").putFile(File(_image!.path));
    // fb.child(currentUser!.uid).child("picture").getDownloadURL().then((value) {
    //   print(value);
    //   setState(() {
    //     imageUrl = value;
    //   });
    // });
    // try {
    //   final ref = FirebaseDatabase.instance.ref().child('profile').child(currentUser!.uid);
    //   await ref.putFile(_image!);
    // }
    // if (_image != null){
    //   final ref = fb.ref().child('profile').child(currentUser!.uid);
    //   ref
    //       .putFile(_image!)
    //       .onComplete;
    // }
    // if (_image != null) {
    //   //Upload to Firebase
    //   var snapshot = await fb.ref()
    //       .child('profiles')
    //       .push()
    //       .set(_image!.path);
    // }
  }
  @override
  Widget build(BuildContext context) {
    fb.child(currentUser!.uid).child("picture").getDownloadURL().then((value) {
      if (mounted) {
        setState(() {
          imageUrl = value;
        });
      }
    });
    return Scaffold(
        appBar: AppBar(
          title: const Text("User Profile", style: TextStyle(fontFamily: "Itim",fontSize: 25)),
          backgroundColor: Colors.white,
          elevation: 1,
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //       Icons.settings,
          //       color: Colors.black,
          //     ),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                // Text("User Profile",
                //   style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, fontFamily: 'Itim'),
                // ),
                // SizedBox(
                //   height: 15,
                // ),
                Center(
                  child: Stack(
                    children: [
                      // Container(
                      //     width: 130,
                      //     height: 130,
                      //     decoration: BoxDecoration(
                      //       border: Border.all(
                      //         width: 4,
                      //         color: Colors.blueGrey,
                      //       ),
                      //       shape: BoxShape.circle,
                      //       // image: Image(image: FileImage(_image!.path))
                      //     ),
                      // ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 80,
                        // backgroundImage: _image == null ? null : FileImage(
                        //     _image!)
                        // imageUrl.isNotEmpty ? NetworkImage(imageUrl): null,
                        backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl): null,
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Color(0xffefe6e9),
                              ),
                              color: Color(0xffefe6e9),
                            ),
                            child: GestureDetector(
                              child: const Icon(
                                Icons.edit,
                                color: Colors.grey,),
                              onTap: () => _pickedImage(),
                            ),
                          )
                      ),
                    ],
                  ),
                ),
                // const TextField(
                //     decoration: InputDecoration(
                //         labelText: "ID",
                //         floatingLabelBehavior: FloatingLabelBehavior.always,
                //     )
                // )
                SizedBox(height: 20), //ref.getAuth().password.email
                Text(
                    "ID: ${currentUser?.uid}", style: TextStyle(fontFamily: 'Itim', color: Colors.black, fontSize: 15)
                ),
                SizedBox(height: 20), //ref.getAuth().password.email
                Text(
                    "Email: ${currentUser?.email}", style: TextStyle(fontFamily: 'Itim', color: Colors.black, fontSize: 16)
                ),
                SizedBox(height: 20), //ref.ge
                GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: new Text("Logout", style: TextStyle(fontFamily: 'Itim', color: Color(0xff0d47a1), fontSize: 16)
                  ),
                ),
              ],
            )
        )
    );
  }
}

class ToDo2 extends StatefulWidget {

  @override
  _ToDo2State createState() => _ToDo2State();
}

class _ToDo2State extends State<ToDo2> {
  final fb = FirebaseDatabase.instance;
  var currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('todos').child(currentUser!.uid);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[350],
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => addnote2(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text(
          'Todos',
          style: TextStyle(
            fontSize: 25,
            color: Color(0xff0d47a1),
            fontFamily: 'Itim',
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FirebaseAnimatedList(
        query: ref,
        shrinkWrap: true,
        itemBuilder: (context, snapshot, animation, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  tileColor: Color(0xfff1eef5),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.blueGrey[900],
                    ),
                    onPressed: () {
                      ref.child(snapshot.key!).remove();
                    },
                  ),
                  title: Text(
                    snapshot.value.toString(),
                    style: const TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
//to-do-list-addnote
class addnote2 extends StatelessWidget {
  TextEditingController title = TextEditingController();
  final fb = FirebaseDatabase.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final ref = fb.ref().child('todos').child(currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Todos", style: TextStyle(fontFamily: 'Itim')),
        backgroundColor: Colors.white,
        leading: IconButton (
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Navifirst()));
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
              width: 10,
            ),
            // Container(
            //   decoration: BoxDecoration(borderColor: Colors.),
            TextField(
              controller: title,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                ),
                hintText: '   Add your todos',
                hintStyle: TextStyle(fontFamily: "Itim", fontSize: 20),
              ),
            ),
            // ),
            const SizedBox(
              height: 10,
            ),
            MaterialButton(
              color: Color(0xffefe6e9),
              onPressed: () {
                ref
                    .push()
                    .set(
                  title.text,
                )
                    .asStream();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => Navifirst()));
              },
              child: const Text(
                "Save",
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Itim',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class XY2 extends StatefulWidget {
  const XY2({Key? key}) : super(key: key);

  @override
  State<XY2> createState() => _XY2State();
}

class _XY2State extends State<XY2> {
  void playTune(int tuneNumber) async {
    final player = AudioPlayer();
    await player.play(AssetSource('note$tuneNumber.wav'));
  }

  Expanded xyloKey(Color color, int tuneNumber) {
    return Expanded(
      child: MaterialButton(
        // shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
        onPressed: () {
          playTune(tuneNumber);
        },
        color: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: Text('Xylophone', style: TextStyle(fontFamily: "Itim")),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            xyloKey(Colors.deepPurple, 1),
            xyloKey(Colors.blue, 2),
            xyloKey(Colors.lightBlueAccent, 3),
            xyloKey(Colors.green, 4),
            xyloKey(Colors.yellow, 5),
            xyloKey(Colors.orange, 6),
            xyloKey(Colors.red, 7),
          ],
        ),
      ),
    );
  }
} //a