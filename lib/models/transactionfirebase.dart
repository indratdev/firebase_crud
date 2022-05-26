import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/models/transaction_model.dart';
import 'package:firebase_crud/screens/widgets/widgethelper.dart';
import 'package:flutter/material.dart';

class TransactionFirebase {
  final widgets = WidgetHelpers();
  final CollectionReference trxCollection =
      FirebaseFirestore.instance.collection('transaction');

  // add new transaction
  addNewTransaction_withModel(
      BuildContext context, TransactionModel transaction) async {
    final trx = TransactionModel(
        date: transaction.date,
        name: transaction.name.toUpperCase(),
        description: transaction.description.toUpperCase(),
        amount: double.parse(transaction.amount.toString()));

    final docRef = trxCollection.withConverter(
      fromFirestore: TransactionModel.fromFirestore,
      toFirestore: (TransactionModel trx, options) => trx.toFirestore(),
    );
    await docRef.add(trx);

    widgets.showSnacBarStatus(context, 'Success Add New Data', false);
  }

  // _addNewTransaction() {
  //   _transaction.add(TransactionModel(
  //     date: dateController.text,
  //     name: nameController.text.toUpperCase(),
  //     description: descController.text.toUpperCase(),
  //     amount: double.parse(amountController.text),
  //   ));
  //   _showSnacBarStatus('Success Add New Data', false);
  // }

  // delete transaction
  deleteTransaction(String iddocs, BuildContext context) {
    if (iddocs != '') {
      trxCollection.doc(iddocs).delete();
      widgets.showSnacBarStatus(context, 'Success deleted', false);
    }
  }

  //update transaction
  updateTransaction(String iddocs, TransactionModel trx, BuildContext context) {
    trxCollection.doc(iddocs).update({
      'name': trx.name,
      'description': trx.description,
      'date': trx.date,
      'amount': double.parse(trx.amount.toString()),
    });
    // _showSnacBarStatus('Success Updated Data', false);
    widgets.showSnacBarStatus(context, 'Success Updated Data', false);
  }
}
