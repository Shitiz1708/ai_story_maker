import 'package:cloud_firestore/cloud_firestore.dart';

class Branddata {
  final String? name;
  final String? brandId;
  final String? uid;
  final String? category;
  final String? email;
  final Timestamp? createdAt;
  final String? slogan;
  final String? instagram;
  final String? facebook;
  final String? website;
  final String? linkedin;
  final String? logo;

  Branddata({
    this.name,
    this.brandId,
    this.uid,
    this.category,
    this.email,
    this.createdAt,
    this.slogan,
    this.instagram,
    this.facebook,
    this.website,
    this.linkedin,
    this.logo,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brandId': brandId,
      'email': email,
      'category': category,
      'uid': uid,
      'slogan': slogan,
      'instagram': instagram,
      'facebook': facebook,
      'website': website,
      'linkedin': linkedin,
      'logo': logo,
      'createdAt': createdAt,
    };
  }

  Branddata.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!['name'] as String?,
        brandId = doc.data()!['brandId'] as String?,
        email = doc.data()!['email'] as String?,
        uid = doc.data()!['uid'] as String?,
        category = doc.data()!['category'] as String?,
        slogan = doc.data()!['slogan'] as String?,
        instagram = doc.data()!['instagram'] as String?,
        facebook = doc.data()!['facebook'] as String?,
        website = doc.data()!['website'] as String?,
        linkedin = doc.data()!['linkedin'] as String?,
        logo = doc.data()!['logo'] as String?,
        createdAt = doc.data()!['createdAt'] as Timestamp?;

  factory Branddata.fromJson(Map<String, dynamic> json) {
    return Branddata(
      name: json['name'] as String?,
      brandId: json['brandId'] as String?,
      email: json['email'] as String?,
      uid: json['uid'] as String?,
      category: json['category'] as String?,
      slogan: json['slogan'] as String?,
      instagram: json['instagram'] as String?,
      facebook: json['facebook'] as String?,
      website: json['website'] as String?,
      linkedin: json['linkedin'] as String?,
      logo: json['logo'] as String?,
      createdAt: json['createdAt'] as Timestamp?,
    );
  }
}
