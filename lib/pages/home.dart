import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbsocialmediaapp/models/user.dart';
import 'package:fbsocialmediaapp/pages/activity_feed.dart';
import 'package:fbsocialmediaapp/pages/create_account.dart';
import 'package:fbsocialmediaapp/pages/profile.dart';
import 'package:fbsocialmediaapp/pages/search.dart';
import 'package:fbsocialmediaapp/pages/timeline.dart';
import 'package:fbsocialmediaapp/pages/upload.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final _usersRef = Firestore.instance.collection('users');
final DateTime timeStamp = DateTime.now();
User currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: pageIndex);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _handlerSignIn(account);
    }, onError: (err) {
      print('Error signed in! $err');
    });
    //Reautentica usuario silenciosamnete quando abre o app
    _googleSignIn.signInSilently(suppressErrors: false).then((GoogleSignInAccount account) {
      _handlerSignIn(account);
    }).catchError((err) {
      print('Error signed in! $err');
    });
  }

  _handlerSignIn(GoogleSignInAccount account) {
    if (account != null) {
      _createUserInFirebase();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  _createUserInFirebase() async {
    final GoogleSignInAccount user = _googleSignIn.currentUser;
    DocumentSnapshot doc = await _usersRef.document(user.id).get();
    
    if(!doc.exists){
      final username = await Navigator.push(context, MaterialPageRoute(builder: (_) => CreateAccount
        ()));
      
      _usersRef.document(user.id).setData({
        'id': user.id,
        'username': username,
        'photoUrl': user.photoUrl,
        'email': user.email,
        'displayName': user.displayName,
        'bio': '',
        'timestamp': timeStamp
      });
      doc = await _usersRef.document(user.id).get();
    }
    
    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.displayName);
    
  }

  void _login() {
    _googleSignIn.signIn();
  }

  void _logout() {
    _googleSignIn.signOut();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  void _onTap(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  Scaffold _buildAuthScreen() {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: <Widget>[
            //Timeline(),
            RaisedButton(
              child: Text('Logout'),
              onPressed: _logout,
            ),
            ActivityFeed(),
            Upload(),
            Search(),
            Profile(),
          ],
          controller: pageController,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: _onTap,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.photo_camera,
            size: 35,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

  Widget _buildUnAuthScreen() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'FlutterShare',
                style: TextStyle(
                  fontFamily: 'Signatra',
                  fontSize: 90,
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: _login,
                child: Container(
                  width: 260,
                  height: 60,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? _buildAuthScreen() : _buildUnAuthScreen();
  }
}
