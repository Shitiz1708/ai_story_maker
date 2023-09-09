import 'package:cloud_firestore/cloud_firestore.dart';

class CampaignData {
  final String? image;
  final String? data;
  final String? uid;
  final String? brandName;

  CampaignData({
    this.image,
    this.data,
    this.uid,
    this.brandName,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'data': data,
      'uid': uid,
      'brandName': uid,
    };
  }

  CampaignData.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : image = doc.data()!['image'] as String?,
        data = doc.data()!['data'] as String?,
        brandName = doc.data()!['brandName'] as String?,
        uid = doc.data()!['uid'] as String?;

  factory CampaignData.fromJson(Map<String, dynamic> json) {
    return CampaignData(
      image: json['image'] as String?,
      data: json['data'] as String?,
      brandName: json['brandName'] as String?,
      uid: json['uid'] as String?,
    );
  }
}
