import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/models/transaction_model.dart';
import 'package:firebase_crud/models/transactionfirebase.dart';
import 'package:firebase_crud/screens/widgets/widgethelper.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({Key? key, required this.iddocs}) : super(key: key);
  String iddocs;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  // final CollectionReference _transaction =
  //     FirebaseFirestore.instance.collection('transaction');

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
      final doc = TransactionFirebase().trxCollection.doc(widget.iddocs);
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
                      WidgetHelpers().showDialogOption2(context, widget.iddocs,
                          () {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        TransactionFirebase()
                            .deleteTransaction(widget.iddocs, context);
                      });
                    },
                    icon: const Icon(Icons.delete, color: Colors.red))
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
                // inputFormatters: [ThousandsSeparatorInputFormatter()],
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
                        // _addNewTransaction_withModel();
                        TransactionFirebase().addNewTransaction_withModel(
                            context,
                            TransactionModel(
                                date: dateController.text,
                                name: nameController.text,
                                amount: double.parse(amountController.text),
                                description: descController.text));

                        _resetTextField();
                      } else {
                        // _updateTransaction(widget.iddocs);
                        TransactionFirebase().updateTransaction(
                            widget.iddocs,
                            TransactionModel(
                                date: dateController.text,
                                name: nameController.text,
                                amount: double.parse(amountController.text),
                                description: descController.text),
                            context);
                        _resetTextField();
                      }
                    } else {
                      WidgetHelpers().showSnacBarStatus(
                          context,
                          'Make sure all the fields are filled',
                          true,
                          Colors.red);
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
