import 'package:clothify_app/components/discount.dart';
import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/products_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class OfferZone extends StatefulWidget {
  final String category;
  const OfferZone({super.key, required this.category});

  @override
  State<OfferZone> createState() => _OfferZoneState();
}

class _OfferZoneState extends State<OfferZone> {
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
            return SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      "${widget.category[0].toUpperCase()}${widget.category.substring(1)}s' Collection",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Spacer(),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          "/specific",
                          arguments: {"name": widget.category},
                        );
                      },
                      icon: Icon(Icons.chevron_right),
                      label: Text('See all'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              SizedBox(
                height: 280,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length > 8 ? 8 : products.length,
                  separatorBuilder: (_, __) => SizedBox(width: 12),
                  itemBuilder: (context, i) {
                    final product = products[i];
                    final discount = discountPercent(
                      product.old_price,
                      product.new_price,
                    );

                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/view_product",
                          arguments: product,
                        );
                      },
                      child: Container(
                        width: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      color: Colors.grey[100],
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 8,
                                    top: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        "-${discount}%",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Product info
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                12,
                                10,
                                12,
                                12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        'Rs.${product.new_price}',
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Rs.${product.old_price}',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 18),
            ],
          );
        } else {
          return Shimmer(
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.white],
            ),
            child: Container(
              height: 320,
              width: double.infinity,
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
