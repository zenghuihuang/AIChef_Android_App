import 'package:flutter/material.dart';
import 'package:fridge_ai_flutter/src/views/home_screen.dart';
import 'package:fridge_ai_flutter/src/widgets/splash_screen.dart';
import 'src/views/more_screen.dart';
import 'src/views/recipe_screen.dart';
import 'src/views/trolley_screen.dart';
import 'src/views/camera_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async{
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fridge AI',
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const RecipeScreen(),
    const TrolleyScreen(),
    const MoreScreen(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CameraScreen()));
        },
        child: const Icon(Icons.camera_alt),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // Customize the navigation bar theme
          navigationBarTheme: const NavigationBarThemeData(
            indicatorColor: Colors.blueAccent, // Color for the indicator
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home'
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.soup_kitchen),
              icon: Icon(Icons.soup_kitchen_outlined),
              label: 'Recipes',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.shopping_cart),
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Trolley'
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.more_horiz),
              icon: Icon(Icons.more_horiz_outlined),
              label: 'More'
            )
          ],
        ),
      )
    );
  }
}
