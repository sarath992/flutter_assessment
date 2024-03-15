import 'package:flutter/material.dart';
import 'package:shopping_application/product_list.dart';

class CartItem {
  final Product product;
  final int quantity;
  final double price;

  CartItem({required this.product, required this.quantity,required this.price});
}
    final List<CartItem> cartItems = [];

class Items extends StatelessWidget {
    final List<CartItem> cartItems ;

  Items({required this.cartItems});
  @override
  Widget build(BuildContext context) {
    int totalQuantity = 0;
    double totalAmount = 0.0;

    for (var cartItem in cartItems) {
      totalQuantity += cartItem.quantity;
      totalAmount += cartItem.product.price * cartItem.quantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),    
        backgroundColor:Colors.greenAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
              return ProductListPage();
            }));
          }, icon: Icon(Icons.home))
        ],
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(cartItems[index].product.title),
            subtitle: Text('\$${(cartItems[index].product.price * cartItems[index].quantity).toStringAsFixed(2)}'),
            trailing: Text('Quantity: ${cartItems[index].quantity}'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Items: $totalQuantity'),
              Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
  }
}

