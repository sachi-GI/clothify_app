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
          List<CategoriesModel> categories =
              CategoriesModel.fromJsonList(snapshot.data!.docs)
                  as List<CategoriesModel>;
          if (categories.isEmpty) {
            return SizedBox();
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map(
                      (cat) =>
                          CategoryButton(imagepath: cat.image, name: cat.name),
                    )
                    .toList(),
              ),
            );
          }
        } else {
          return Shimmer(
            child: Container(height: 90, width: double.infinity),
            gradient: LinearGradient(
              colors: [Colors.grey.shade200, Colors.white],
            ),
          );
          ;
        }
      },
    );
  }
}

class CategoryButton extends StatefulWidget {
  final String imagepath, name;
  const CategoryButton({
    super.key,
    required this.imagepath,
    required this.name,
  });

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
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.imagepath, height: 50),
            SizedBox(height: 8),
            Text(
              "${widget.name.substring(0, 1).toUpperCase()}${widget.name.substring(1)}",
            ),
          ],
        ),
      ),
    );
  }
}
