import 'package:flutter/material.dart';
import 'Model/category_details_model.dart';

class AgeCategoryItem extends StatelessWidget {
  final AgeCategoryDataClass data;
  final onDeleteItem;

  const AgeCategoryItem({
    Key? key,
    required this.data,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text("  "),
              const Image(image: AssetImage("assets/Menu.png")),
              Text(
                "   ${data.AgeCategory} ",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                " ${data.Category}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              onDeleteItem(data.Category, data.AgeCategory);
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.delete,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
