import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key, required this.iddocs}) : super(key: key);
  String iddocs;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final CollectionReference _transaction =
      FirebaseFirestore.instance.collection('transaction');

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkDefaultValue();
  }

  _checkDefaultValue() {
    if (widget.iddocs != '') {
      final doc = _transaction.doc(widget.iddocs);
      doc.get().then(
            (value) => {
              nameController.text = value['name'].toString(),
              descController.text = value['description'].toString(),
              dateController.text = value['date'].toString(),
              amountController.text = value['amount'].toString(),
            },
          );
    }
  }

  _addNewTransaction_withModel() async {
    final trx = TransactionModel(
        date: dateController.text,
        name: nameController.text.toUpperCase(),
        description: descController.text.toUpperCase(),
        amount: double.parse(amountController.text));

    final docRef = _transaction.withConverter(
      fromFirestore: TransactionModel.fromFirestore,
      toFirestore: (TransactionModel trx, options) => trx.toFirestore(),
    );
    await docRef.add(trx);

    _showSnacBarStatus('Success Add New Data', false);
  }

  _addNewTransaction() {
    _transaction.add(TransactionModel(
      date: dateController.text,
      name: nameController.text.toUpperCase(),
      description: descController.text.toUpperCase(),
      amount: double.parse(amountController.text),
    ));
    _showSnacBarStatus('Success Add New Data', false);
  }

  _updateTransaction(String iddocs) {
    _transaction.doc(iddocs).update({
      'name': nameController.text,
      'description': descController.text,
      'date': dateController.text,
      'amount': double.parse(amountController.text),
    });
    _showSnacBarStatus('Success Updated Data', false);
  }

  _deleteTransaction(String iddocs) {
    if (widget.iddocs != '') {
      _transaction.doc(iddocs).delete();
      _showSnacBarStatus('Success deleted', false);
    }
  }

  _showSnacBarStatus(String status, bool isHold, [Color color = Colors.green]) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: color,
        content: Text(status),
      ),
    );

    (isHold)
        ? null
        : Future.delayed(const Duration(milliseconds: 2500), () {
            Navigator.pop(context);
            _resetTextField();
          });
  }

  _resetTextField() {
    setState(() {
      nameController.text = '';
      descController.text = '';
      dateController.text = '';
      amountController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (widget.iddocs == '')
            ? const Text('Add New Transaction')
            : const Text('Update Transaction'),
        actions: (widget.iddocs != '')
            ? <Widget>[
                IconButton(
                    onPressed: () {
                      _deleteTransaction(widget.iddocs);
                    },
                    icon: const Icon(Icons.delete))
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              TextField(
                controller: descController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextField(
                controller: dateController,
                decoration:
                    const InputDecoration(labelText: 'Date Transaction'),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(9999),
                  ).then((value) {
                    if (value != null) {
                      dateController.text = value.toString();
                    }
                  });
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    if (nameController.text != null &&
                        nameController.text != '' &&
                        descController.text != null &&
                        descController.text != '' &&
                        dateController.text != null &&
                        dateController.text != '' &&
                        amountController.text != null &&
                        amountController.text != '') {
                      if (widget.iddocs == '') {
                        _addNewTransaction_withModel();
                      } else {
                        _updateTransaction(widget.iddocs);
                      }
                    } else {
                      _showSnacBarStatus('Make sure all the fields are filled',
                          true, Colors.red);
                    }
                  },
                  child: (widget.iddocs == '')
                      ? const Text('Save')
                      : const Text('Update'))
            ],
          ),
        ),
      ),
    );
  }
}
