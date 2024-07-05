import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoora/model/transaction_model.dart' as model;

class TransactionRepository {
  FirebaseFirestore instance = FirebaseFirestore.instance;
  final FirebaseAuth authInstance = FirebaseAuth.instance;

  Future<List<model.Transaction>> getTransactions() async {
    QuerySnapshot snapshot = await instance
        .collection("transaction")
        .where(
          "userId",
          isEqualTo: authInstance.currentUser!.uid,
        )
        .get();
    List<model.Transaction> transactions = model.Transaction.fromSnapshots(snapshot.docs);

    transactions.sort((a, b) {
      return b.createdAt.compareTo(a.createdAt);
    });
    return transactions;
  }
}
