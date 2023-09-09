import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedLoan {
  final String? companyId;
  final String? leadBankName;
  final String? amount;
  final String? uid;
  final Timestamp? createdAt;
  final String? status;

  RequestedLoan({
    this.companyId,
    this.leadBankName,
    this.amount,
    this.uid,
    this.createdAt,
    this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'leadBankName': leadBankName,
      'companyId': companyId,
      'uid': uid,
      'createdAt': createdAt,
      'status': status,
    };
  }

  RequestedLoan.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : companyId = doc.data()!['companyId'] as String?,
        leadBankName = doc.data()!['leadBankName'] as String?,
        amount = doc.data()!['amount'] as String?,
        uid = doc.data()!['uid'] as String?,
        status = doc.data()!['status'] as String?,
        createdAt = doc.data()!['createdAt'] as Timestamp?;

  factory RequestedLoan.fromJson(Map<String, dynamic> json) {
    return RequestedLoan(
      companyId: json['companyId'] as String?,
      leadBankName: json['leadBankName'] as String?,
      amount: json['amount'] as String?,
      uid: json['uid'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as Timestamp?,
    );
  }
}
