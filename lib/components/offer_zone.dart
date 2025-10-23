import 'dart:math';
import 'package:clothify_app/components/discount.dart';
import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/products_model.dart';
import 'package:clothify_app/views/view_product.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OfferZone extends StatefulWidget {
  final String category;
  const OfferZone({super.key, required this.category});

  @override
  State<OfferZone> createState() => _OfferZoneState();
}

class _OfferZoneState extends State<OfferZone> {
  // Restore specialQuote for use in the card
  Widget specialQuote({required int price, required int dis}) {
    int random = Random().nextInt(2);
    List<String> quotes = [
      "Starting at Rs.${formatPrice(price)}",
      "Get up to $dis% off",
    ];
    return Text(
      quotes[random],
      style: TextStyle(
        color: Colors.green,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readProducts(widget.category),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<ProductsModel> products = ProductsModel.fromJsonList(
            snapshot.data!.docs,
          );
          if (products.isEmpty) {
            return Center(child: Text("No products Found."));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 25),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Colors.blue.shade50,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            widget.category.substring(0, 1).toUpperCase() +
                                widget.category.substring(1),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/specific",
                                arguments: {"name": widget.category},
                              );
                            },
                            icon: Icon(Icons.chevron_right),
                          ),
                        ],
                      ),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: products.length > 4 ? 4 : products.length,
                        itemBuilder: (context, i) {
                          final product = products[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/view_product",
                                arguments: product,
                              );
                            },
                            child: Card(
                              color: Colors.grey.shade50,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 140,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.network(
                                          product.image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    specialQuote(
                                      price: product.new_price,
                                      dis: int.parse(
                                        discountPercent(
                                          product.old_price,
                                          product.new_price,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        } else {
          return Shimmer(
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.white],
            ),
            child: Container(
              height: 400,
              width: double.infinity,
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
