// enum TypeTrasaction { outcome, income }

import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String name, description, date;
//  String typeTrasaction;
  double amount;

  TransactionModel(
      {this.name = '',
      this.description = '',
      //    this.typeTrasaction = 'outcome',
      this.amount = 0.0,
      required this.date});

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'amount': amount,
      'date': date,
      //  'type': typeTrasaction,
    };
  }

  // TransactionModel.fromMap(Map<String, dynamic> transactionModelMap)
  //     : name = transactionModelMap["name"],
  //       description = transactionModelMap["description"],
  //       amount = transactionModelMap["amount"],
  //       date = transactionModelMap["date"];
  //  typeTrasaction = transactionModelMap["type"];
  factory TransactionModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    {
      final data = snapshot.data();
      return TransactionModel(
          name: data?['name'],
          description: data?['description'],
          amount: data?['amount'],
          date: data?['date']);
    }
  }
}
