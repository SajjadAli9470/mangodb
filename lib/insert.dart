import 'dart:developer';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:mangodb/MangoDBModel.dart';
import 'package:mangodb/constant.dart';
import 'package:mangodb/display.dart';
import 'package:mangodb/mangodb.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class MangoDbInsert extends StatefulWidget {
  const MangoDbInsert({super.key});

  @override
  State<MangoDbInsert> createState() => _MangoDbInsertState();
}

class _MangoDbInsertState extends State<MangoDbInsert> {
  var fnamecontroller = TextEditingController();
  var lnamecontroller = TextEditingController();
  var addresscontroller = TextEditingController();
  var linkController = TextEditingController();
  bool isConnecting = false;
  @override
  void initState() {
    mongoDbConnection();
    linkController.text = MANGO_URL;
    // TODO: implement initState
    super.initState();
  }

  mongoDbConnection() async {
    try {
      setState(() {
        isConnecting = true;
      });
      await MangoDataBase.connect(context, MANGO_URL);
      setState(() {
        isConnecting = false;
      });
    } catch (e) {
      setState(() {
        isConnecting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: const Color.fromARGB(57, 158, 158, 158)),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                            label: Text("url"), border: OutlineInputBorder()),
                        controller: linkController,
                      ),
                      isConnecting
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                try {
                                  setState(() {
                                    isConnecting = true;
                                  });
                                  await MangoDataBase.connect(
                                      context, linkController.text);
                                  setState(() {
                                    isConnecting = false;
                                  });
                                } catch (e) {
                                  setState(() {
                                    isConnecting = false;
                                  });
                                }
                              },
                              child: const Text("Start Connection")),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Test Queries',
                  style: TextStyle(fontFamily: 'Noto', fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: fnamecontroller,
                  decoration: const InputDecoration(labelText: "First Name"),
                ),
                TextField(
                  controller: lnamecontroller,
                  decoration: const InputDecoration(labelText: "Last Name"),
                ),
                TextField(
                  controller: addresscontroller,
                  minLines: 3,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "Address"),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OutlinedButton(
                          onPressed: () {
                            fakeData();
                          },
                          child: const Text('Generate data')),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _insertData(fnamecontroller.text,
                              lnamecontroller.text, addresscontroller.text);
                          print(fnamecontroller.text);
                          print(lnamecontroller.text);
                          print(addresscontroller.text);
                        },
                        child: const Text('Insert data'),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MangoDbDisplay(),
                              ));
                        },
                        child: const Text('View Data')),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _insertData(String fName, String lName, String address) async {
    var id = M.ObjectId();
    log(id.toString());
    final data = MangoDbModel(
        id: id, firstname: fName, lastName: lName, address: address);
    // ignore: unused_local_variable
    try {
      var result = await MangoDataBase.insert(data);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Inserted ID${id.$oid}'),
      ));
      _clearAll();
    } catch (e) {
      log(e.toString());
    }
  }

  void _clearAll() {
    fnamecontroller.text = "";
    lnamecontroller.text = "";
    addresscontroller.text = "";
  }

  void fakeData() {
    setState(() {
      fnamecontroller.text = faker.person.firstName();
      lnamecontroller.text = faker.person.lastName();
      addresscontroller.text =
          "${faker.address.streetName()}/n${faker.address.streetAddress()}";
    });
  }
}
