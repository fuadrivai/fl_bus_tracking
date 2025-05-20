// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bus_tracking/dao/student_dao.dart';
import 'package:bus_tracking/library/library.dart';
import 'package:bus_tracking/models/model.dart';
import 'package:bus_tracking/pages/home/data/home_api.dart';
import 'package:bus_tracking/pages/screen.dart';
import 'package:bus_tracking/pages/student/data/student_api.dart';
import 'package:bus_tracking/service/database_service.dart';
import 'package:bus_tracking/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';

class StudentScreen extends StatefulWidget {
  final File file;
  final String nopol;
  const StudentScreen({super.key, required this.nopol, required this.file});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen>
    with WidgetsBindingObserver {
  Uint8List? image;
  Timer? _timer;
  Future<Pickup>? _pickup;
  List<Student> students = [];
  List<Student> studentDb = [];
  bool isLoading = false;
  int index = 0;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final databaseService = DatabaseService();

  @override
  void initState() {
    onInit();
    saveDriverInformation();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      setTimeInterval();
    } else if (state == AppLifecycleState.paused) {
      setTimeInterval();
    } else if (state == AppLifecycleState.resumed) {
      setTimeInterval();
    } else {
      setTimeInterval();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Siswa"),
        actions: [
          IconButton(
            onPressed: () async {
              final db = await databaseService.database;
              StudentDao studentDao = db.studentDao;
              List<Student> studentDB = await studentDao.findAllStudent();
              await studentDao.deleteAllStudent(studentDB);
              _timer?.cancel();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeV2Screen()),
                    (route) => false);
              }
            },
            icon: const Icon(
              FontAwesomeIcons.powerOff,
              color: Colors.redAccent,
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
              future: _pickup,
              builder: (context, snapshot) {
                if (isLoading ||
                    snapshot.connectionState == ConnectionState.waiting) {
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
                List<Student> compareStudent = (snapshot.data?.students ?? [])
                    .where((data1) => !studentDb
                        .any((data2) => data1.childID == data2.childID))
                    .toList();

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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomeBadge(
                            text: "Berangkat",
                            backgroundColor:
                                index == 0 ? Colors.blueAccent : null,
                            width: MediaQuery.of(context).size.width * 45 / 100,
                            onTap: () {
                              index = 0;
                              setState(() {});
                            },
                          ),
                          CustomeBadge(
                            text: "Sampai",
                            backgroundColor:
                                index == 1 ? Colors.blueAccent : null,
                            width: MediaQuery.of(context).size.width * 45 / 100,
                            onTap: () {
                              index = 1;
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          index == 0
                              ? TextTitle(
                                  title:
                                      "Daftar Siswa : ${compareStudent.length}")
                              : TextTitle(
                                  title: "Daftar Siswa : ${studentDb.length}"),
                          TextTitle(title: "Dipilih : ${students.length}"),
                        ],
                      ),
                    ),
                    ListStudentWidget(
                      data: index == 0 ? compareStudent : studentDb,
                      students: students,
                      onChanged: (value, student) {
                        if (value ?? true) {
                          student.action = index == 0 ? "Pickup" : "Arrived";
                          students.add(student);
                          setState(() {});
                        } else {
                          students.removeWhere(
                              (val) => val.childID == student.childID);
                        }
                        setState(() {});
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal: 8,
                      ),
                      child: CustomButton(
                        label: "Simpan Check List",
                        onTap: () async {
                          isLoading = true;
                          setState(() {});
                          StudentApi.saveChecklist(
                            params: {
                              "nopol": widget.nopol,
                              "endpoint": "saveCheckList"
                            },
                            students: students.map((v) => v.toJson()).toList(),
                          ).then((val) async {
                            final db = await databaseService.database;
                            StudentDao studentDao = db.studentDao;
                            if (index == 0) {
                              await studentDao.insertStudents(students);
                            } else {
                              await studentDao.deleteAllStudent(students);
                            }
                            studentDb = await studentDao.findAllStudent();
                            if (context.mounted) {
                              Common.modalInfo(context,
                                  title: 'Sukses',
                                  message: "Data berhasil disimpan",
                                  icon: const Icon(
                                    FontAwesomeIcons.circleCheck,
                                    color: Colors.green,
                                  ));
                              students = [];
                              isLoading = false;
                            }
                            setState(() {});
                          });
                        },
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _pickup = StudentApi.getPickups(params: {"nopol": widget.nopol});
    setState(() {});
  }

  onInit() async {
    try {
      _pickup = StudentApi.getPickups(params: {"nopol": widget.nopol});
      _geolocatorPlatform.getServiceStatusStream();
      String? strImage = await Session.get("image");
      image = base64Decode(strImage!);
      Position position = await Common.determinePosition();
      await StudentApi.startTracking(
        params: {"nopol": widget.nopol, "endpoint": "start"},
        location: {
          "latitude": position.latitude,
          "longitude": position.longitude
        },
      );
      setTimeInterval();
    } catch (e) {
      print(e);
    }
  }

  setTimeInterval() async {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      Position position = await Common.determinePosition();
      await StudentApi.startTracking(
        params: {"nopol": widget.nopol, "endpoint": "start"},
        location: {
          "latitude": position.latitude,
          "longitude": position.longitude
        },
      );
      print("${position.latitude} - ${position.longitude}");
      setState(() {});
    });
  }

  saveDriverInformation() async {
    try {
      String filename = basename(widget.file.path);
      String? base64Image = await Common.imageToBase64(widget.file.path);
      Map<String, dynamic> param = {
        "endpoint": "driver",
        "mimeType": 'image/jpeg',
        "filename": filename
      };
      Map<String, dynamic> map = {
        "image": base64Image,
        "nopol": widget.nopol,
        "driverName": (await _pickup)?.driverName ?? "",
        "action": (await _pickup)?.mode ?? "",
      };
      await HomeApi.clockin(params: param, map: map);
    } catch (e) {
      print(e);
    }
  }
}

class ListStudentWidget extends StatelessWidget {
  final List<Student> students;
  final List<Student> data;
  final Function(bool?, Student) onChanged;
  const ListStudentWidget({
    super.key,
    required this.data,
    required this.onChanged,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: ListTile.divideTiles(
                context: context,
                tiles: data.map((student) {
                  Color? color;
                  switch (student.childDivision) {
                    case "Preschool":
                      color = const Color.fromARGB(255, 241, 173, 26);
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
                    onChanged: (value) => onChanged(value, student),
                    value:
                        students.any((val) => val.childID == student.childID),
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
