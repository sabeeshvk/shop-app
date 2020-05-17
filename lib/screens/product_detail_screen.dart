import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // ProductDetailScreen(this.title);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    //by listening false this will not rebuild when we have new object
    // if (loadedProduct != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
        ),
        // backgroundColor:Colors.black38,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: 300,
                width: double.infinity,
                child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Rs.${loadedProduct.price}",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  )),
            ],
          ),
        ),
      );
    }
    // return Scaffold(
    //   appBar: AppBar(title:Text('No item')),
    //   body: Center(
    //     child: Text("Add Products"),
    //   ),
    // );
  // }
}