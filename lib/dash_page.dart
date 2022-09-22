import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'configs/globals.dart';
import 'courses_page.dart';

class DashPage extends StatefulWidget {
  const DashPage({Key? key}) : super(key: key);

  @override
  _DashPageState createState() => _DashPageState();
}

class _DashPageState extends State<DashPage> {
  var subscription;
  bool isOnline = true;

  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isOnline = false;

        });
      } else {
        setState(() {
          isOnline = true;
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: 0,
          height: 60.0,
          items: const <Widget>[
            Icon(Icons.home_filled, size: 30, color: Colors.white),
            //Icon(Icons.calendar_today, size: 30, color: Colors.white),
            Icon(Icons.school, size: 30, color: Colors.white),
            //Icon(Icons.book, size: 30, color: Colors.white),
            Icon(Icons.settings, size: 30, color: Colors.white),
          ],
          color: primaryColor,
          buttonBackgroundColor: primaryColor,
          animationCurve: Curves.easeInOut,
          backgroundColor: Colors.transparent,
          animationDuration: const Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        body: _page == 0
            ? const CoursesPage()
            : _page == 1
                ? const CoursesPage()
                : _page == 2
                    ? const CoursesPage()
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(_page.toString(), textScaleFactor: 10.0),
                            ElevatedButton(
                              child: const Text('Go To Page of index 0'),
                              onPressed: () {
                                final CurvedNavigationBarState? navBarState =
                                    _bottomNavigationKey.currentState;
                                navBarState?.setPage(0);
                              },
                            )
                          ],
                        ),
                      ));
  }
}
