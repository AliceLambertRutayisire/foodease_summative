import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../animation.dart';
import '../../models/meals.dart';
import '../Dashboard/restaurants.dart';
import '../Order History/orderhistory.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    int index = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
         backgroundColor: Color.fromRGBO(50, 41, 57, 1),
      ),
       backgroundColor: Color.fromRGBO(50, 41, 57, 1),
      body: cart.items.isEmpty
          ? Center(child: Text('Your cart is empty', style: TextStyle(color: Color.fromRGBO(201, 199, 126, 1), ),))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = cart.items[index];
                      return ListTile(
                        tileColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            //<-- SEE HERE
                            side: BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        leading: Image.network(imageurls[index]),
                        title: Text(item.menuItemName,  style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromRGBO(201, 199, 126, 1),
                            fontWeight: FontWeight.bold,
                          ),),
                        subtitle: Text('\RWF ${item.menuItemPrice.toStringAsFixed(2)} x ${item.quantity}',  style: TextStyle(
                           color: Colors.white,  fontSize: 14.0 ),),
                        trailing: IconButton(
                          icon: Icon(Icons.remove),
                          color: Colors.white,
                          onPressed: () {
                            cart.removeItem(MenuItem(
                                item.menuItemId,
                                item.menuItemName,
                                item.menuItemPrice,
                                item.menuItemImageUrl));
                          },
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \RWF ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFBB902D)),
                        onPressed: () {
                          Navigator.push(
                          context,
                          CustomPageRoute(
                               child: OrderConfirmationPage(cartItems: cart.items)),);
                        },
                        child: Text('Cofirm Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
