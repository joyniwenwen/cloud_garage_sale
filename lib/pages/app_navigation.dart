import 'package:flutter/material.dart';
import 'package:hyper_garage_sale/pages/browse_posts.dart';
import 'package:hyper_garage_sale/models/user_profile.dart';
import 'package:hyper_garage_sale/pages/newpost.dart';


class AppNavigation extends StatefulWidget {
  AppNavigation({this.userProfile, this.logoutCallback});

  final VoidCallback logoutCallback;
  final UserProfile userProfile;

  @override
  _AppNavigationState createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {

  int _selectedIndex = 0;
  List<Widget> _widgetOptions = [];
  UserProfile _userProfile;
  VoidCallback _logoutCallback;

  void addNewpostCallback() {
    _onItemTapped(0);
  }

  @override
  void initState() {
    super.initState();
    _userProfile = widget.userProfile;
    _logoutCallback = widget.logoutCallback;
    _widgetOptions = <Widget>[
      BrowsePosts(userProfile: _userProfile,),
      NewPost(userProfile: _userProfile, addNewpostCallback: addNewpostCallback),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Image.asset(
            'assets/logo.png',
             height: 60,
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: _logoutCallback,
                child: Icon(
                  Icons.logout,
                  size: 26.0,
                ),
              )
          ),
        ],

      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.collections),
            label: 'BrowsePost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'New Post',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
