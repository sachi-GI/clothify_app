import 'package:clothify_app/controllers/db_service.dart';
import 'package:clothify_app/models/categories_model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
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
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map((cat) => CategoryButton(name: cat.name))
                    .toList(),
              ),
            );
          }
        } else {
          return Shimmer(
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.white],
            ),
            child: SizedBox(height: 90, width: double.infinity),
          );
        }
      },
    );
  }
}

class CategoryButton extends StatefulWidget {
  final String name;
  const CategoryButton({super.key, required this.name});

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        "/specific",
        arguments: {"name": widget.name},
      ),
      child: Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.all(4),
        height: 95,
        width: 95,
        decoration: BoxDecoration(
          color: Colors.teal.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: _colorFromString(widget.name).withOpacity(0.12),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: _colorFromString(widget.name),
                child: Text(
                  _initial(widget.name),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Flexible(
              child: Text(
                widget.name.isNotEmpty
                    ? widget.name[0].toUpperCase() + widget.name.substring(1)
                    : '',
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorFromString(String s) {
    if (s.isEmpty) return Colors.grey;
    final code = s.codeUnits.fold<int>(0, (p, c) => p + c);
    final colors = [
      Colors.teal,
      Colors.indigo,
      Colors.deepPurple,
      Colors.orange,
      Colors.pink,
      Colors.blue,
      Colors.green,
      Colors.brown,
    ];
    return colors[code % colors.length];
  }

  String _initial(String s) {
    if (s.isEmpty) return '?';
    return s[0].toUpperCase();
  }
}
