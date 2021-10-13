import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wastood/components/empty_placeholder.dart';
import 'package:wastood/components/foodcard.dart';
import 'package:wastood/domain/wastood.dart';

class HistoryPage extends StatefulWidget {
  static const ROUTE_NAME = "/history";

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
      ),
      body: StreamBuilder<User>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            //

            return FutureBuilder(
                future: firestore
                    .collection("giveAways")
                    .where("negotiatingWith", isNotEqualTo: null)
                    .where("negotiatingWith.uid", isEqualTo: snapshot.data.uid)
                    .where("completed", isEqualTo: true)
                    .get()
                    .then((QuerySnapshot requestDocs) =>
                    firestore
                        .collection("giveAways")
                        .where("author.uid", isEqualTo: snapshot.data.uid)
                        .where("completed", isEqualTo: true)
                        .where("negotiatingWith", isNotEqualTo: null)
                        .get()
                        .then((QuerySnapshot requestDocs2) =>
                        firestore
                            .collection("giveAways")
                            .where("negotiatingWith", isNotEqualTo: null)
                            .where("negotiatingWith.uid",
                            isEqualTo: snapshot.data.uid)
                            .where("completed", isEqualTo: true)
                            .get()
                            .then((QuerySnapshot requestDocs3) =>
                            firestore
                                .collection("giveAways")
                                .where("endsAt", isLessThan: Timestamp.now())
                                .where("author.uid", isEqualTo: snapshot.data
                                .uid)
                                .where("completed", isEqualTo: false)
                                .get()
                                .then(
                                  (QuerySnapshot requestDocs4) =>
                              {
                                [
                                  requestDocs.docs,
                                  requestDocs2.docs,
                                  requestDocs4.docs,
                                  requestDocs4.docs
                                ].expand((list) => list).toList()
                              },
                            )))),
                builder: (context, snapshot)
            {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              List<QueryDocumentSnapshot> docs = snapshot.data.first;

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
                      active: false,
                    );
                  });
            },);
          }),
    );
  }
}
