import 'package:carousel_slider/carousel_slider.dart';
import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/promo_banners.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Promo extends StatefulWidget {
  const Promo({super.key});

  @override
  State<Promo> createState() => _PromoState();
}

class _PromoState extends State<Promo> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DbService().readPromos(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PromoBannersModel> promos =
              PromoBannersModel.fromJsonList(snapshot.data!.docs)
                  as List<PromoBannersModel>;
          if (promos.isEmpty) {
            return SizedBox();
          } else {
            return CarouselSlider(
              items: promos
                  .map((promo) => Image.network(promo.image, fit: BoxFit.cover))
                  .toList(),
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                aspectRatio: 16 / 9,
                viewportFraction: 1,
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              ),
            );
          }
        } else {
          return Shimmer(
            child: Container(height: 300, width: double.infinity),
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.white],
            ),
          );
        }
      },
    );
  }
}
