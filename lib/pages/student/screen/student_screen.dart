import 'dart:convert';
import 'dart:typed_data';
import 'package:bus_tracking/library/library.dart';
import 'package:bus_tracking/models/model.dart';
import 'package:bus_tracking/pages/screen.dart';
import 'package:bus_tracking/pages/student/data/student_api.dart';
import 'package:bus_tracking/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentScreen extends StatefulWidget {
  final String nopol;
  const StudentScreen({super.key, required this.nopol});

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
        child: FutureBuilder(
            future: StudentApi.getPickups(params: {"nopol": widget.nopol}),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 4.0,
                        horizontal: 8,
                      ),
                      child: StudentShimmer(),
                    );
                  }).toList(),
                );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextTitle(title: "Informasi Driver"),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: size.width * 30 / 130,
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
                            width: size.width * 60 / 85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?.nopol ?? "--",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25,
                                    color: Color.fromARGB(255, 112, 112, 112),
                                  ),
                                ),
                                Text(
                                  snapshot.data?.driverName ?? "--",
                                  style: const TextStyle(
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
                  ListStudentWidget(pickups: snapshot.data?.students ?? []),
                ],
              );
            }),
      ),
    );
  }
}

class ListStudentWidget extends StatelessWidget {
  final List<Student> pickups;
  const ListStudentWidget({super.key, required this.pickups});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: ListTile.divideTiles(
                context: context,
                tiles: pickups.map((student) {
                  Color? color;
                  switch (student.childDivision) {
                    case "Preschool":
                      color = const Color.fromARGB(255, 241, 220, 26);
                      break;
                    case "Primary":
                      color = const Color.fromARGB(255, 26, 118, 29);
                      break;
                    case "Secondary":
                      color = const Color.fromARGB(255, 15, 97, 164);
                      break;
                    default:
                      color = const Color.fromARGB(255, 130, 19, 150);
                  }
                  return CheckboxListTile(
                    onChanged: (value) {},
                    value: true,
                    dense: false,
                    visualDensity: const VisualDensity(vertical: -1),
                    controlAffinity: ListTileControlAffinity.platform,
                    title: Text(
                      student.childName ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(student.childDivision ?? "-"),
                    secondary: Icon(
                      FontAwesomeIcons.userAstronaut,
                      size: 35,
                      color: color,
                    ),
                  );
                }).toList())
            .toList(),
      ),
    );
  }
}
