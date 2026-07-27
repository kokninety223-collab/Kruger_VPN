import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kruger VPN',
      theme: ThemeData.dark(),
      home: const VPNHomeScreen(),
    );
  }
}

class VPNHomeScreen extends StatefulWidget {
  const VPNHomeScreen({super.key});

  @override
  State<VPNHomeScreen> createState() => _VPNHomeScreenState();
}

class _VPNHomeScreenState extends State<VPNHomeScreen> {
  bool isConnected = false;
  String statusText = "DISCONNECTED";

  void toggleConnection() {
    setState(() {
      if (isConnected) {
        isConnected = false;
        statusText = "DISCONNECTED";
      } else {
        isConnected = true;
        statusText = "CONNECTED";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kruger Personal VPN'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConnected ? Icons.shield : Icons.shield_outlined,
              size: 100,
              color: isConnected ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: toggleConnection,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                backgroundColor: isConnected ? Colors.red : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                isConnected ? 'DISCONNECT' : 'CONNECT',
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
