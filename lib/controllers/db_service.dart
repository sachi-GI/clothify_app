import 'package:clothify_app/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DbService {
  User? user = FirebaseAuth.instance.currentUser;

  Future saveUserData({required String name, required String email}) async {
    try {
      Map<String, dynamic> data = {"name": name, "email": email};
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .set(data);
    } catch (e) {
      print("Error saving user data: $e");
    }
  }

  Future updateUserData({required Map<String, dynamic> extraData}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .update(extraData);
  }

  Stream<DocumentSnapshot> readUserData() {
    return FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .snapshots();
  }

  Stream<QuerySnapshot> readPromos() {
    return FirebaseFirestore.instance.collection("shop_promos").snapshots();
  }

  Stream<QuerySnapshot> readBanners() {
    return FirebaseFirestore.instance.collection("shop_banners").snapshots();
  }

  Stream<QuerySnapshot> readCategories() {
    return FirebaseFirestore.instance
        .collection("shop_categories")
        .orderBy("priority", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> readProducts(String category) {
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where("category", isEqualTo: category.toLowerCase())
        .snapshots();
  }

  Stream<QuerySnapshot> searchProducts(List<String> docIds) {
    return FirebaseFirestore.instance
        .collection("shop_products")
        .where(FieldPath.documentId, whereIn: docIds)
        .snapshots();
  }

  Future reduceQuantity({
    required String productId,
    required int quantity,
  }) async {
    await FirebaseFirestore.instance
        .collection("shop_products")
        .doc(productId)
        .update({"quantity": FieldValue.increment(-quantity)});
  }

  Stream<QuerySnapshot> readUserCart() {
    return FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .snapshots();
  }

  Future addToCart({required CartModel cartData}) async {
    try {
      await FirebaseFirestore.instance
          .collection("shop_users")
          .doc(user!.uid)
          .collection("cart")
          .doc(cartData.productId)
          .update({
            "product_id": cartData.productId,
            "quantity": FieldValue.increment(1),
          });
    } on FirebaseException catch (e) {
      print("firebase exception : ${e.code}");
      if (e.code == "not-found") {
        await FirebaseFirestore.instance
            .collection("shop_users")
            .doc(user!.uid)
            .collection("cart")
            .doc(cartData.productId)
            .set({"product_id": cartData.productId, "quantity": 1});
      }
    }
  }

  Future deleteItemFromCart({required String productId}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .delete();
  }

  Future emptyCart() async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .get()
        .then((value) {
          for (DocumentSnapshot ds in value.docs) {
            ds.reference.delete();
          }
        });
  }

  Future decreaseCount({required String productId}) async {
    await FirebaseFirestore.instance
        .collection("shop_users")
        .doc(user!.uid)
        .collection("cart")
        .doc(productId)
        .update({"quantity": FieldValue.increment(-1)});
  }

  Future createOrder({required Map<String, dynamic> data}) async {
    await FirebaseFirestore.instance.collection("shop_orders").add(data);
  }

  Future updateOrderStatus({
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    await FirebaseFirestore.instance
        .collection("shop_orders")
        .doc(docId)
        .update(data);
  }

  Stream<QuerySnapshot> readOrders() {
    return FirebaseFirestore.instance
        .collection("shop_orders")
        .where("user_id", isEqualTo: user!.uid)
        .orderBy("created_at", descending: true)
        .snapshots();
  }
}
