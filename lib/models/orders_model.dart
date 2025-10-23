import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersModel {
  String id, email, name, phone, status, user_id, address;
  int total, created_at;
  List<OrderProductModel> products;

  OrdersModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    required this.status,
    required this.user_id,
    required this.address,
    required this.total,
    required this.created_at,
    required this.products,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json, String id) {
    return OrdersModel(
      id: id,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      user_id: json['user_id'] ?? '',
      address: json['address'] ?? '',
      total: json['total'] ?? 0,
      created_at: json['created_at'] ?? 0,
      products: List<OrderProductModel>.from(
        json['products'].map((e) => OrderProductModel.fromJson(e)),
      ),
    );
  }

  static List<OrdersModel> fromJsonList(List<QueryDocumentSnapshot> list) {
    return list
        .map(
          (e) => OrdersModel.fromJson(e.data() as Map<String, dynamic>, e.id),
        )
        .toList();
  }
}

class OrderProductModel {
  String id, name, image;
  int quantity, single_price, total_price;

  OrderProductModel({
    required this.id,
    required this.name,
    required this.image,
    required this.quantity,
    required this.single_price,
    required this.total_price,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 0,
      single_price: json['single_price'] ?? 0,
      total_price: json['total_price'] ?? 0,
    );
  }
}
