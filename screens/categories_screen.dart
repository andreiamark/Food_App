import 'package:flutter/material.dart';
import 'package:food_app/dummy_data.dart';
import '../dummy_data.dart';
import'../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('DeliMeal'),
      ),
      body: GridView(
          padding: const EdgeInsets.all(25),
          children: DUMMY_CATEGORIES
           .map(
              (catData) => CategoryItem(
                catData.title as String,
                catData.color as Color,
                catData.id as String,
          ),
      )
        .toList(),
    gridDelegate:SliverGridDelegateWithMaxCrossAxisExtent(
      maxCrossAxisExtent: 200,
      childAspectRatio: 3 / 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
    ),
      ),
    );
  }
}

