import 'package:elmira_works_app/profile/book_conference_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elmira_works_app/authentication/login_page.dart';
import 'package:elmira_works_app/authentication/fire_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> getData(String uid) async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final userData =
        querySnapshot.docs.firstWhere((element) => element.id == uid)["foo"];

    debugPrint(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'NAME: ${_currentUser.displayName}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16.0),
            Text(
              'EMAIL: ${_currentUser.email}',
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(height: 16.0),
            _currentUser.emailVerified
                ? Text(
                    'Email verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.green),
                  )
                : Text(
                    'Email not verified',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.red),
                  ),
            const SizedBox(height: 16.0),
            _isSendingVerification
                ? const CircularProgressIndicator()
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            _isSendingVerification = true;
                          });
                          await _currentUser.sendEmailVerification();
                          setState(() {
                            _isSendingVerification = false;
                          });
                        },
                        child: const Text('Verify email'),
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          User? user = await FireAuth.refreshUser(_currentUser);
                          if (user != null) {
                            await getData(user.uid);
                          }
                          if (user != null) {
                            setState(() {
                              _currentUser = user;
                            });
                          }
                        },
                      ),
                    ],
                  ),
            const SizedBox(height: 16.0),
            _isSigningOut
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isSigningOut = true;
                      });
                      await FirebaseAuth.instance.signOut();
                      setState(() {
                        _isSigningOut = false;
                      });
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: const Text('Sign out'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
            const SizedBox(height: 16),
            TextButton(
                child: const Text('Book conference room'),
                onPressed: () => {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              BookConferencePage(user: _currentUser),
                        ),
                      )
                    })
          ],
        ),
      ),
    );
  }
}
