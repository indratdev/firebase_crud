import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionFirebase {
  final CollectionReference trxCollection =
      FirebaseFirestore.instance.collection('transaction');
}
