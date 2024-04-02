import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Connection extends StatefulWidget {
  const Connection({super.key});

  @override
  State<Connection> createState() => _ConnectionState();
}

class _ConnectionState extends State<Connection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, snapshot) {
            return Scaffold(
              appBar: AppBar(title: const Text("Check Internet Connection")),
              body: Center(
                child: snapshot.data == ConnectivityResult.none
                    ? const Text("Offline")
                    : const Text("Online"),
              ),
            );
          });
  }
}