import 'package:clothify_app/components/offer_zone.dart';
import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageViewMore extends StatefulWidget {
  const HomePageViewMore({super.key});

  @override
  State<HomePageViewMore> createState() => _HomePageViewMoreState();
}

class _HomePageViewMoreState extends State<HomePageViewMore> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CategoriesModel> categories = CategoriesModel.fromJsonList(
            snapshot.data!.docs,
          );
          if (categories.isEmpty) {
            return SizedBox();
          } else {
            return Column(
              children: [
                for (int i = 0; i < snapshot.data!.docs.length; i++)
                  OfferZone(category: snapshot.data!.docs[i]["name"]),
              ],
            );
          }
        } else {
          return Shimmer(
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.white],
            ),
            child: SizedBox(height: 400, width: double.infinity),
          );
        }
      },
    );
  }
}
