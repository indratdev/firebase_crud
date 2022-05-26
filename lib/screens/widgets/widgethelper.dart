import 'package:firebase_crud/models/transactionfirebase.dart';
import 'package:flutter/material.dart';

class WidgetHelpers {
  showSnacBarStatus(BuildContext context, String status, bool isHold,
      [Color color = Colors.green]) {
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
            // _resetTextField();
          });
  }

  //show dialog 2
  showDialogOption2(
      BuildContext context, String iddocs, VoidCallback okCallback) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const Text('Are you sure you want to delete this data'),
            actions: <Widget>[
              TextButton(
                onPressed: okCallback,
                // () {
                //   Navigator.of(context).popUntil((route) => route.isFirst);
                //   TransactionFirebase()
                //       .deleteTransaction(iddocs, context);
                // },
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }
}
