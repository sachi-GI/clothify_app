import 'package:clothify_app/components/discount.dart';
import 'package:clothify_app/models/cart_model.dart';
import 'package:clothify_app/models/products_model.dart';
import 'package:clothify_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

String formatPrice(num price) {
  final formatter = NumberFormat('#,##0', 'en_US');
  return formatter.format(price);
}

class ViewProduct extends StatefulWidget {
  const ViewProduct({super.key});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as ProductsModel;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: Text(
          "${arguments.name}",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(18),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    arguments.image,
                    height: 360,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      height: 360,
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      arguments.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Text(
                    "Rs. ${formatPrice(arguments.new_price)}",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  if (arguments.old_price > arguments.new_price)
                    Text(
                      "Rs. ${formatPrice(arguments.old_price)}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  const Spacer(),
                  if (arguments.old_price > arguments.new_price)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "-${discountPercent(arguments.old_price, arguments.new_price)}%",
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  arguments.maxQuantity == 0
                      ? Chip(
                          label: Text(
                            'Out of stock',
                            style: TextStyle(color: Colors.red.shade600),
                          ),
                          backgroundColor: Colors.red.withOpacity(0.05),
                        )
                      : Chip(
                          label: Text(
                            'In stock: ${arguments.maxQuantity}',
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                          backgroundColor: Colors.green.withOpacity(0.05),
                        ),
                  const SizedBox(width: 8),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                'Product Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                arguments.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 20),
              const SizedBox(height: 90),
            ],
          ),
        ),
      ),

      bottomNavigationBar: arguments.maxQuantity != 0
          ? SafeArea(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).addToCart(
                            CartModel(productId: arguments.id, quantity: 1),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Added to cart successfully!'),
                            ),
                          );
                        },
                        icon: Icon(Icons.shopping_bag_outlined),
                        label: Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).addToCart(
                            CartModel(productId: arguments.id, quantity: 1),
                          );
                          Navigator.pushNamed(context, '/checkout');
                        },
                        icon: Icon(
                          Icons.flash_on,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        label: Text(
                          'Buy Now',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
