import 'package:clothify_app/components/discount.dart';
import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/products_model.dart';
import 'package:clothify_app/views/view_product.dart';
import 'package:flutter/material.dart';

class SpecificProducts extends StatefulWidget {
  const SpecificProducts({super.key});

  @override
  State<SpecificProducts> createState() => _SpecificProductsState();
}

class _SpecificProductsState extends State<SpecificProducts> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          "${args["name"].substring(0, 1).toUpperCase()}${args["name"].substring(1)}",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: DbService().readProducts(args["name"]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductsModel> products = ProductsModel.fromJsonList(
                snapshot.data!.docs,
              );
              if (products.isEmpty) {
                return Center(child: Text("No Products Found."));
              } else {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 0.68, // Make cards taller
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
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
                              SizedBox(height: 12),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rs.${formatPrice(product.new_price)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Rs.${formatPrice(product.old_price)}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "-${discountPercent(product.old_price, product.new_price)}%",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
