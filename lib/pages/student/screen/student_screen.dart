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
  final File? file;
  final String isLogin;
  const StudentScreen({super.key, this.file, required this.isLogin});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen>
    with WidgetsBindingObserver {
  Uint8List? image;
  Timer? _timer;
  Future<Pickup>? _pickup;

  List<Student> studentCheck = [];
  List<Student> studentsApi = [];
  List<Student> studentsDb = [];
  List<Student> studentsView = [];

  String? nopol;
  bool isLoading = false, checkAll = false;
  int index = 0;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  final databaseService = DatabaseService();

  @override
  void initState() {
    isLoading = true;
    Session.get("nopol").then((val) {
      nopol = val;
      onInit();
      isLoading = false;
      setState(() {});
    });
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
            onPressed: () {
              Common.modalInfo(context,
                  title: "Yakin Akan Keluar?",
                  message: "Anda akan mengulangi semua proses jika keluar. !",
                  icon: const Icon(
                    FontAwesomeIcons.triangleExclamation,
                    color: Colors.amber,
                  ),
                  mode: MODE.error,
                  buttonAction: TextButton(
                    onPressed: () async {
                      final db = await databaseService.database;
                      StudentDao studentDao = db.studentDao;
                      await studentDao.deleteAllStudent(studentsDb);
                      await Session.clear();
                      _timer?.cancel();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomeV2Screen()),
                            (route) => false);
                      }
                    },
                    child: const Text("Logout"),
                  ));
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                        horizontal: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomeBadge(
                              text: "Berangkat",
                              backgroundColor:
                                  index == 0 ? Colors.blueAccent : null,
                              onTap: () {
                                index = 0;
                                setIndexData(index);
                              },
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: CustomeBadge(
                              text: "Sampai",
                              backgroundColor:
                                  index == 1 ? Colors.blueAccent : null,
                              onTap: () {
                                index = 1;
                                setIndexData(index);
                              },
                            ),
                          ),
                          const SizedBox(width: 2),
                          Expanded(
                            child: CustomeBadge(
                              text: "Selesai",
                              backgroundColor:
                                  index == 2 ? Colors.blueAccent : null,
                              onTap: () {
                                index = 2;
                                setIndexData(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextTitle(
                              title: "Daftar Siswa : ${studentsView.length}"),
                          TextTitle(title: "Dipilih : ${studentCheck.length}"),
                          (index < 2)
                              ? Checkbox(
                                  value: checkAll,
                                  onChanged: (val) {
                                    checkAll = val ?? false;
                                    for (var student in studentsView) {
                                      student.action =
                                          index == 0 ? "Pickup" : "Arrived";
                                    }
                                    studentCheck = checkAll ? studentsView : [];
                                    setState(() {});
                                  },
                                  visualDensity: const VisualDensity(
                                    vertical: -1,
                                  ),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                    ListStudentWidget(
                      index: index,
                      data: studentsView,
                      students: studentCheck,
                      onChanged: (value, student) {
                        if (value ?? true) {
                          student.action = index == 0 ? "Pickup" : "Arrived";
                          studentCheck.add(student);
                          setState(() {});
                        } else {
                          studentCheck.removeWhere(
                              (val) => val.childID == student.childID);
                        }
                        setState(() {});
                      },
                      onSlidePressed: (student) {
                        student.action = index == 2 ? "Pickup" : null;
                        onDeleteStudent(
                          context,
                          action: student.action,
                          student: student,
                        );
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
                          saveToDb(context);
                          // saveChecklist(context);
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

  saveToDb(BuildContext context) async {
    isLoading = true;
    final db = await databaseService.database;
    StudentDao studentDao = db.studentDao;
    if (index == 0) {
      await studentDao.insertStudents(studentCheck);
    } else {
      for (Student val in studentCheck) {
        await studentDao.updateStudent(val);
      }
    }
    setIndexData(index);
    if (context.mounted) {
      Common.modalInfo(context,
          title: 'Sukses',
          mode: MODE.success,
          message: "Data berhasil disimpan",
          icon: const Icon(
            FontAwesomeIcons.circleCheck,
            color: Colors.green,
          ));
      studentCheck = [];
      isLoading = false;
    }
    setState(() {});
  }

  saveChecklist(BuildContext context) async {
    isLoading = true;
    setState(() {});
    StudentApi.saveChecklist(
      params: {"nopol": nopol, "endpoint": "saveCheckList"},
      students: studentCheck.map((v) => v.toJson()).toList(),
    ).then((val) async {
      if (context.mounted) {
        saveToDb(context);
      }
    });
  }

  Future<void> _onRefresh() async {
    studentCheck = [];
    index = 0;
    _pickup = StudentApi.getPickups(params: {"nopol": nopol});
    await setIndexData(0);
    setState(() {});
  }

  onInit() async {
    try {
      _pickup = StudentApi.getPickups(params: {"nopol": nopol});
      String? strImage = await Session.get("image");
      image = base64Decode(strImage!);
      await setIndexData(0);

      _geolocatorPlatform.getServiceStatusStream();
      Position position = await Common.determinePosition();
      await StudentApi.startTracking(
        params: {"nopol": nopol, "endpoint": "start"},
        location: {
          "latitude": position.latitude,
          "longitude": position.longitude
        },
      );
      if (widget.isLogin != "true") {
        saveDriverInformation();
      }
      setTimeInterval();
    } catch (e) {
      print(e);
    }
  }

  saveDriverInformation() async {
    try {
      String filename = basename(widget.file!.path);
      String? base64Image = await Common.imageToBase64(widget.file!.path);
      Map<String, dynamic> param = {
        "endpoint": "driver",
        "mimeType": 'image/jpeg',
        "filename": filename
      };
      Map<String, dynamic> map = {
        "image": base64Image,
        "nopol": nopol,
        "driverName": (await _pickup)?.driverName ?? "",
        "action": (await _pickup)?.mode ?? "",
      };
      await HomeApi.clockin(params: param, map: map);
      await Session.set("isLogin", "true");
    } catch (e) {
      print(e);
    }
  }

  Future setIndexData(int index) async {
    final db = await databaseService.database;
    StudentDao studentDao = db.studentDao;
    switch (index) {
      case 0:
        studentsApi = (await _pickup)?.students ?? [];
        studentsDb = await studentDao.findAllStudent();
        studentsView = studentsApi
            .where((data1) =>
                !studentsDb.any((data2) => data1.childID == data2.childID))
            .toList();
        break;
      case 1:
        studentsApi = (await _pickup)?.students ?? [];
        studentsDb = await studentDao.findAllStudent();
        studentsView =
            studentsDb.where((val) => val.action == "Pickup").toList();
        break;
      case 2:
        studentsApi = (await _pickup)?.students ?? [];
        studentsDb = await studentDao.findAllStudent();
        studentsView =
            studentsDb.where((val) => val.action == "Arrived").toList();
        break;
      default:
    }
    studentCheck = [];
    checkAll = false;
    setState(() {});
  }

  setTimeInterval() async {
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) async {
      Position position = await Common.determinePosition();
      await StudentApi.startTracking(
        params: {"nopol": nopol, "endpoint": "start"},
        location: {
          "latitude": position.latitude,
          "longitude": position.longitude
        },
      );
      print("${position.latitude} - ${position.longitude}");
      setState(() {});
    });
  }

  onDeleteStudent(
    BuildContext context, {
    String? action,
    required Student student,
  }) async {
    final databaseService = DatabaseService();
    final db = await databaseService.database;
    StudentDao studentDao = db.studentDao;
    student.action = action;
    if (student.action == null) {
      studentDao.deleteStudent(student);
    } else {
      studentDao.updateStudent(student);
    }

    setIndexData(index);
    if (context.mounted) {
      Common.modalInfo(
        context,
        title: 'Sukses',
        mode: MODE.success,
        message: "Data berhasil dihapus",
        icon: const Icon(
          FontAwesomeIcons.circleCheck,
          color: Colors.green,
        ),
      );
      studentCheck = [];
      isLoading = false;
    }
    setState(() {});
  }
}

class ListStudentWidget extends StatelessWidget {
  final List<Student> students;
  final List<Student> data;
  final int index;
  final Function(bool?, Student) onChanged;
  final Function(Student)? onSlidePressed;
  const ListStudentWidget({
    super.key,
    required this.data,
    required this.onChanged,
    required this.students,
    required this.index,
    this.onSlidePressed,
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
                  switch (index) {
                    case 0:
                      return checkboxListTile(student, color);
                    case 1:
                      return SlideWidget(
                        slideKey: ValueKey(student.childID),
                        onSlidePressed: onSlidePressed == null
                            ? null
                            : (context) => onSlidePressed!(student),
                        child: checkboxListTile(student, color),
                      );
                    case 2:
                      return SlideWidget(
                        slideKey: ValueKey(student.childID),
                        onSlidePressed: onSlidePressed == null
                            ? null
                            : (context) => onSlidePressed!(student),
                        child: ListTile(
                          dense: false,
                          visualDensity: const VisualDensity(vertical: -1),
                          title: Text(
                            student.childName ?? "-",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(student.childDivision ?? "-"),
                          leading: Icon(
                            FontAwesomeIcons.userAstronaut,
                            size: 35,
                            color: color,
                          ),
                          trailing: const Badge(
                            backgroundColor: Colors.redAccent,
                            label: Text("Selesai"),
                          ),
                        ),
                      );
                    default:
                      return const Center(
                          child: Text("Widget is in maintenance"));
                  }
                }).toList())
            .toList(),
      ),
    );
  }

  Widget checkboxListTile(Student student, Color color) {
    return CheckboxListTile(
      onChanged: (value) => onChanged(value, student),
      value: students.any((val) => val.childID == student.childID),
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
  }
}
