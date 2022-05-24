// enum TypeTrasaction { outcome, income }

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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'amount': amount,
      'date': date,
      //  'type': typeTrasaction,
    };
  }

  TransactionModel.fromMap(Map<String, dynamic> transactionModelMap)
      : name = transactionModelMap["name"],
        description = transactionModelMap["description"],
        amount = transactionModelMap["amount"],
        date = transactionModelMap["date"];
  //  typeTrasaction = transactionModelMap["type"];
}
