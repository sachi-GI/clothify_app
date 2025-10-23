import 'package:clothify_app/contants/payment.dart';
import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/providers/cart_provider.dart';
import 'package:clothify_app/providers/user_provider.dart';
import 'package:clothify_app/views/view_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Future<void> initPaymentSheet(int cost) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false);
      final data = await createPaymentIntent(
        name: user.name,
        address: user.address,
        amount: (cost * 100).toString(),
      );

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: false,
          merchantDisplayName: 'Flutter Stripe Store Demo',
          paymentIntentClientSecret: data['client_secret'],
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'LK'),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'LK',
            testEnv: true,
          ),
          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Consumer<UserProvider>(
          builder: (context, userData, child) => Consumer<CartProvider>(
            builder: (context, cartData, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Delivery Address",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .65,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(userData.email),
                                Text(userData.address),
                                Text(userData.phone),
                              ],
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/update_profile");
                            },
                            icon: Icon(Icons.edit_outlined),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 10),
                    Text(
                      "Total Quantity of Products: ${cartData.totalQuantity}",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      "Total Price: Rs. ${formatPrice(cartData.totalCost)}",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    SizedBox(height: 20),
                    Text(
                      "Total Payable: Rs. ${formatPrice(cartData.totalCost)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            final user = Provider.of<UserProvider>(context, listen: false);
            if (user.address == "" ||
                user.phone == "" ||
                user.name == "" ||
                user.email == "") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please fill all the details")),
              );
              return;
            }
            await initPaymentSheet(
              Provider.of<CartProvider>(context, listen: false).totalCost,
            );
            try {
              await Stripe.instance.presentPaymentSheet();

              final cart = Provider.of<CartProvider>(context, listen: false);
              User? currentUser = FirebaseAuth.instance.currentUser;
              List products = [];

              for (int i = 0; i < cart.products.length; i++) {
                products.add({
                  "id": cart.products[i].id,
                  "name": cart.products[i].name,
                  "image": cart.products[i].image,
                  "quantity": cart.carts[i].quantity,
                  "single_price": cart.products[i].new_price,
                  "total_price":
                      cart.products[i].new_price * cart.carts[i].quantity,
                });
              }

              Map<String, dynamic> orderData = {
                "user_id": currentUser!.uid,
                "name": user.name,
                "email": user.email,
                "phone": user.phone,
                "address": user.address,
                "total": cart.totalCost,
                "products": products,
                "status": "PAID",
                "created_at": DateTime.now().millisecondsSinceEpoch,
              };

              await DbService().createOrder(data: orderData);

              for (int i = 0; i < cart.products.length; i++) {
                DbService().reduceQuantity(
                  productId: cart.products[i].id,
                  quantity: cart.carts[i].quantity,
                );
              }
              await DbService().emptyCart();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Payment successful!",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              print("Error presenting payment sheet: $e");
              print("Payment cancelled or failed");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Payment failed",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent.shade400,
            foregroundColor: Colors.white,
          ),
          child: Text("Proceed to Payment"),
        ),
      ),
    );
  }
}
