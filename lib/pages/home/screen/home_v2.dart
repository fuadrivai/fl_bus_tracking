import 'package:bus_tracking/library/library.dart';
import 'package:bus_tracking/pages/screen.dart';
import 'package:bus_tracking/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class HomeV2Screen extends StatefulWidget {
  const HomeV2Screen({super.key});

  @override
  State<HomeV2Screen> createState() => _HomeV2ScreenState();
}

class _HomeV2ScreenState extends State<HomeV2Screen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController platController = TextEditingController();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  void initState() {
    _geolocatorPlatform.getServiceStatusStream();
    Common.determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Masukan plat nomor : "),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Plat nomor tidak boleh kosong";
                          }
                          return null;
                        },
                        controller: platController,
                        decoration: TextFormDecoration.box(),
                        onChanged: (val) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: CustomButton(
                          label: 'Submit',
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CameraScreen(
                                        nopol: platController.text),
                                  ));
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
