import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_application/cart.dart';
import 'package:shopping_application/login_or_signup.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
    );
  }
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Silver Shop-Product List'),
        backgroundColor: Colors.greenAccent,
         automaticallyImplyLeading: false,
         actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
              return Items(cartItems: cartItems);
            }));
          }, icon: Icon(Icons.shopping_cart)),
          IconButton(onPressed: (){
            Signout(context);
          }, icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(snapshot.data![index].image),
                  title: Text(snapshot.data![index].title),
                  subtitle: Text('\$${snapshot.data![index].price.toStringAsFixed(2)}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(product: snapshot.data![index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
     Signout(BuildContext ctx) async
  {
     final _sharedPreference = await SharedPreferences.getInstance();
     await _sharedPreference.clear();
  
    Navigator.of(ctx).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx1){
      return Login();
    }), (route) => false);
  }
}

class ProductDetailsPage extends StatefulWidget {
  final Product product;

  ProductDetailsPage({required this.product});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  int quantity =1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),   
        backgroundColor:Colors.greenAccent,     
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:CrossAxisAlignment.center,
            children: [
               Image.network(widget.product.image),
              SizedBox(height: 15),
              Text(widget.product.title),
              Text('\$${widget.product.price.toStringAsFixed(2)}'),
              Text(widget.product.description),
              SizedBox(height:20.0),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (quantity > 1) {
                          quantity--;
                        }
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  Text('$quantity'),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
               ),
              ElevatedButton(
                onPressed: () {
                  final cartItem = CartItem(
                    product: widget.product,
                    quantity: quantity,
                    price: widget.product.price, 
                  );
                  cartItems.add(cartItem);

                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                    return Items(cartItems: cartItems);
                  }));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Product added to cart')),
                  );
                },
                child: Text('Add to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

