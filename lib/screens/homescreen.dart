import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_crud/screens/transactionscreen.dart';
import 'package:firebase_crud/models/transactionfirebase.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final decimalFormatter = intl.NumberFormat.decimalPattern();
  final _transaction = TransactionFirebase().trxCollection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase CRUD'),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionScreen(
                  iddocs: '',
                ),
              ),
            );
          },
          child: const Text('+')),
      body: StreamBuilder(
        stream: _transaction.orderBy('date').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          return ListView.builder(
            itemCount: streamSnapshot.data?.docs.length ?? 0,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TransactionScreen(iddocs: documentSnapshot.id)));
                },
                child: Card(
                  color:
                      (index % 2 == 0) ? Colors.blue[100] : Colors.amber[400],
                  child: ListTile(
                    title: Text(documentSnapshot['name']),
                    subtitle: Text(documentSnapshot['description']),
                    trailing: Text(
                      'Rp. ${decimalFormatter.format(
                        documentSnapshot['amount'],
                      )}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // decimalFormatter.format(documentSnapshot['amount'])),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
