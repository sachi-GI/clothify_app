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
            Image.asset('images/logo.jpg', height: 40, fit: BoxFit.contain),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.07),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: Colors.black87, fontSize: 16),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: 'Search here...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 0,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.blueAccent.shade400,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        toolbarHeight: 64,
        backgroundColor: Colors.blue.shade50,
        elevation: 0.5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Best Deals",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
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
