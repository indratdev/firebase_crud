// enum TypeTrasaction { outcome, income }

class TransactionModel {
  String name, description;
  String typeTrasaction;
  double amount;

  TransactionModel(
      {this.name = '',
      this.description = '',
      this.typeTrasaction = 'outcome',
      this.amount = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'amount': amount,
      'type': typeTrasaction,
    };
  }

  TransactionModel.fromMap(Map<String, dynamic> transactionModelMap)
      : name = transactionModelMap["name"],
        description = transactionModelMap["description"],
        amount = transactionModelMap["amount"],
        typeTrasaction = transactionModelMap["type"];
}
