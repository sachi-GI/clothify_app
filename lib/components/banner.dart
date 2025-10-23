import 'package:flutter/material.dart';

class Banners extends StatefulWidget {
  final String image, category;
  const Banners({super.key, required this.image, required this.category});

  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      height: 200,
      child: Image.network(widget.image, fit: BoxFit.cover),
    );
  }
}
