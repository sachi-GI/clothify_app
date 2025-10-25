import 'package:clothify_app/components/category.dart';
import 'package:clothify_app/components/home_page_view_more.dart';
import 'package:clothify_app/components/promo.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 50, fit: BoxFit.contain),
          ],
        ),
        toolbarHeight: 64,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Promo(),
              SizedBox(height: 16),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Category(),
                  HomePageViewMore(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
