import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wastood/components/empty_placeholder.dart';
import 'package:wastood/components/foodcard.dart';
import 'package:wastood/domain/author.dart';
import 'package:wastood/domain/wastood.dart';

class ActiveWastoodsPage extends StatefulWidget {
  static const ROUTE_NAME = "/active_wastoods";

  @override
  _ActiveWastoodsPageState createState() => _ActiveWastoodsPageState();
}

class _ActiveWastoodsPageState extends State<ActiveWastoodsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Active Wastoods"),
      ),
      body: StreamBuilder<User>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            return FutureBuilder(
              future: firestore
                  .collection("giveAways")
                  .where("negotiatingWith", isNotEqualTo: null)
                  .where("negotiatingWith.uid", isEqualTo: snapshot.data.uid)
                  .where("completed", isEqualTo: false)
                  .get()
                  .then((QuerySnapshot requestDocs) => firestore
                      .collection("giveAways")
                      .where("author.uid", isEqualTo: snapshot.data.uid)
                      .where("completed", isEqualTo: false)
                      .where("negotiatingWith", isNotEqualTo: null)
                      .get()
                      .then(
                        (QuerySnapshot giveAwaysDocs) => {
                          [giveAwaysDocs.docs, requestDocs.docs]
                              .expand((list) => list)
                              .toList()
                        },
                      )),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                print(snapshot.data);
                List<QueryDocumentSnapshot> docs = snapshot.data.first
                    .where((QueryDocumentSnapshot doc) =>
                        doc["endsAt"].toDate().isAfter(DateTime.now()) as bool)
                    .toList();
                if (docs.isEmpty) {
                  return EmptyPlaceholder();
                }
                return GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemCount: docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot document = docs[index];
                      return FoodCard(
                        wastood: Wastood.fromMap(document.data(), document.id),
                        active: true,
                      );
                    });
              },
            );
          }),
    );
  }
}
