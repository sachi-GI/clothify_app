import 'package:clothify_app/components/banner.dart';
import 'package:clothify_app/components/offer_zone.dart';
import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/categories_model.dart';
import 'package:clothify_app/models/promo_banners.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePageViewMore extends StatefulWidget {
  const HomePageViewMore({super.key});

  @override
  State<HomePageViewMore> createState() => _HomePageViewMoreState();
}

class _HomePageViewMoreState extends State<HomePageViewMore> {
  int min = 0;
  minCalculator(int a, int b) {
    return min = a > b ? b : a;
  }

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
            return StreamBuilder(
              stream: DbService().readBanners(),
              builder: (context, bannerSnapshot) {
                if (bannerSnapshot.hasData) {
                  List<PromoBannersModel> banners =
                      PromoBannersModel.fromJsonList(snapshot.data!.docs);
                  if (banners.isEmpty) {
                    return SizedBox();
                  } else {
                    return Column(
                      children: [
                        for (
                          int i = 0;
                          i <
                              minCalculator(
                                snapshot.data!.docs.length,
                                bannerSnapshot.data!.docs.length,
                              );
                          i++
                        )
                          Column(
                            children: [
                              OfferZone(
                                category: snapshot.data!.docs[i]["name"],
                              ),
                              Banners(
                                image: bannerSnapshot.data!.docs[i]["image"],
                                category:
                                    bannerSnapshot.data!.docs[i]["category"],
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                } else {
                  return SizedBox();
                }
              },
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
