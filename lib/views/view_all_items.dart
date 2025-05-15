import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app_trail/Utils/constants.dart';
import 'package:recipe_app_trail/Widget/food_items_display.dart';
import 'package:recipe_app_trail/Widget/my_icon_widget.dart';

class ViewAllItems extends StatefulWidget {
  const ViewAllItems({super.key});

  @override
  State<ViewAllItems> createState() => _ViewAllItemsState();
}

class _ViewAllItemsState extends State<ViewAllItems> {
  final CollectionReference allRecipes = FirebaseFirestore.instance.collection(
    "App-Recipes",
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          SizedBox(width: 15),
          MyIconButton(
            icon: Icons.arrow_back_ios_new,
            pressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          Text(
            "Quick & Easy",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          MyIconButton(icon: Iconsax.notification, pressed: () {}),
          SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 15, right: 5),
        child: Column(
          children: [
            SizedBox(height: 10),
            StreamBuilder(
              stream: allRecipes.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                if (streamSnapshot.hasData) {
                  return GridView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                    ),
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Column(
                        children: [
                          FoodItemsDisplay(documentSnapshot: documentSnapshot),
                          Row(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Icon(Iconsax.star1, color: Colors.amberAccent),
                              SizedBox(width: 5),
                              Text(
                                documentSnapshot['rating'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(" /5"),
                              SizedBox(width: 5),
                              Text(
                                "${documentSnapshot['review'.toString()]} Reviews",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                }
                // it means if snapshot has date then show the date otherwise show the progress indicator;
                return Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
