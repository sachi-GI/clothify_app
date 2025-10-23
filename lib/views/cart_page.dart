import 'package:clothify_app/components/cart_container.dart';
import 'package:clothify_app/providers/cart_provider.dart';
import 'package:clothify_app/views/view_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Cart",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (value.carts.isEmpty) {
              return Center(child: Text("No items in cart"));
            } else {
              if (value.products.isNotEmpty) {
                return ListView.builder(
                  itemCount: value.carts.length,
                  itemBuilder: (context, index) {
                    print("selected ${value.carts[index].quantity}");
                    return CartContainer(
                      image: value.products[index].image,
                      name: value.products[index].name,
                      new_price: value.products[index].new_price,
                      old_price: value.products[index].old_price,
                      maxQuantity: value.products[index].maxQuantity,
                      selectedQuantity: value.carts[index].quantity,
                      productId: value.products[index].id,
                    );
                  },
                );
              } else {
                return Text("No items in cart");
              }
            }
          }
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, value, child) {
          if (value.carts.isEmpty) {
            return SizedBox();
          } else {
            return Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total : Rs. ${formatPrice(value.totalCost)} ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/checkout");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent.shade400,
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Procced to Checkout"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
