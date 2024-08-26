import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SpinKitCubeGrid(
          size: 140,
          duration: const Duration(seconds: 2),
          color: Colors.white,
        ),
      ),
    );
  }
}
