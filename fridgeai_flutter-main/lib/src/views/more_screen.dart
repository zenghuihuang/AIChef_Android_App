import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MoreScreen> {
  String _appVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    _initAppVersion();
  }

  Future<void> _initAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
      ),
      body: ListView(
        children: <Widget>[
          const ListTile(
            title: Text('About the Fridge AI App'),
      subtitle: Text("""
In today's fast-paced world, food waste has become a significant issue, with countless households discarding perfectly good ingredients simply because they're unsure how to use them. Fridge AI aims to combat this problem by transforming the way we view and utilize our kitchen's contents.

Our innovative app empowers you to scan your fridge and pantry, instantly receiving personalized recipes that make the most of what you already have. By suggesting meals based on your current ingredients, Fridge AI not only helps you save money and time but also significantly reduces food waste, making a positive impact on the environment.

Whether you're a cooking enthusiast or someone who's looking for a quick and easy meal solution, Fridge AI is designed to cater to all culinary levels and preferences. With our app, your kitchen becomes a treasure trove of possibilities, turning everyday ingredients into extraordinary meals.

Join us in our mission to reduce food waste and discover the joy of creating delicious, sustainable meals right from your fridge. Fridge AI: Where smart technology meets culinary creativity, one ingredient at a time.
      """),),
          const ListTile(
            title: Text('Developer Name'),
            subtitle: Text('Zenghui Huang'),
          ),
          const ListTile(
            title: Text('Contact Information'),
            subtitle: Text('zeng.huang@outlook.com'),
          ),
          ListTile(
            title: const Text('App Version'),
            subtitle: Text(_appVersion),
            onTap: () {
              // Implement navigation to website
            },
          ),
          // Add more list tiles for each piece of information
        ],
      ),
    );
  }
}
