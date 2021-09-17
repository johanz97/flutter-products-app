import 'package:flutter/material.dart';
import 'package:productosapp/pages/page.dart';
import 'package:productosapp/services/auth_service.dart';
import 'package:provider/provider.dart';

class CheckAuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: Center(
          child: FutureBuilder(
              future: authService.readToken(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) return Text('');
                if (snapshot.data == '') {
                  Future.microtask(() {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => LoginPage(),
                            transitionDuration: Duration(seconds: 0)));
                  });
                } else {
                  Future.microtask(() {
                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (_, __, ___) => HomePage(),
                            transitionDuration: Duration(seconds: 0)));
                  });
                }
                return Container();
              })),
    );
  }
}
