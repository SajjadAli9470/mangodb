import 'package:flutter/material.dart';
import 'package:mangodb/MangoDBModel.dart';
import 'package:mangodb/mangodb.dart';

class MangoDbDisplay extends StatefulWidget {
  const MangoDbDisplay({super.key});

  @override
  State<MangoDbDisplay> createState() => _MangoDbDisplayState();
}

class _MangoDbDisplayState extends State<MangoDbDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder(
          future: MangoDataBase.getData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                var totaldata = snapshot.data.length;
                print('Total Data$totaldata');
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return DisplayCard(
                        MangoDbModel.fromJson(snapshot.data[index]));
                  },
                );
              } else {
                return const Center(
                  child: Text('data not found'),
                );
              }
            }
          },
        ),
      )),
    );
  }

  Widget DisplayCard(MangoDbModel data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Text(data.firstname),
            const SizedBox(
              height: 5,
            ),
            Text(data.lastName),
            const SizedBox(
              height: 5,
            ),
            Text(data.address),
          ],
        ),
      ),
    );
  }
}
