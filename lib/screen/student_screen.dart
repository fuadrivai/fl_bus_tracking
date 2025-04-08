import 'dart:convert';
import 'dart:typed_data';
import 'package:bus_tracking/library/library.dart';
import 'package:bus_tracking/screen/screen.dart';
import 'package:bus_tracking/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  Uint8List? image;
  bool loading = true;

  @override
  void initState() {
    Session.get("image").then((val) {
      setState(() {
        image = base64Decode(val!);
        loading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Siswa"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeV2Screen()),
                  (route) => false);
            },
            icon: const Icon(
              FontAwesomeIcons.powerOff,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextTitle(title: "Informasi Driver"),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: loading
                    ? const DriverShimmer(height: 150)
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 30 / 100,
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..scale(-1.0, 1.0),
                              child: Image.memory(
                                image!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 60 / 100,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "A1234GB",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                  ),
                                ),
                                Text(
                                  "Muhammad Yusuf Baharudin Gemilang",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
              ),
            ),
            const TextTitle(title: "Daftar Siswa"),
            loading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
                        child: StudentShimmer(),
                      );
                    }).toList(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return const StudentCard(
                        cardHolder: "Fuad Rivai",
                        cardNumber: "1234 1234 1234 1234",
                        expiryDate: "12/25",
                        cvv: "123",
                      );
                    }).toList(),
                  )
          ],
        ),
      ),
    );
  }
}
