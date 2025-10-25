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
    final title =
        "${args["name"].substring(0, 1).toUpperCase()}${args["name"].substring(1)}";

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: DbService().readProducts(args["name"]),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error loading products'));
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<ProductsModel> products = ProductsModel.fromJsonList(
              snapshot.data!.docs,
            );

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  floating: false,
                  expandedHeight: 140,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 16, bottom: 12),
                    title: Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.08),
                            Colors.transparent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  sliver: products.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: Text('No Products Found.')),
                        )
                      : SliverGrid(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = products[index];
                            return _ProductCard(
                              product: product,
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/view_product',
                                arguments: product,
                              ),
                            );
                          }, childCount: products.length),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.62,
                              ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductsModel product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(14),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.grey.shade100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(product.image, fit: BoxFit.cover),
                    ),
                  ),

                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '-${discountPercent(product.old_price, product.new_price)}% ',
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

            SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),

            SizedBox(height: 6),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
                vertical: 6.0,
              ),
              child: Row(
                children: [
                  Text(
                    'Rs.${formatPrice(product.new_price)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Rs.${formatPrice(product.old_price)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
