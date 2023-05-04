
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MenuItem {
  String menuItemId;
  String menuItemName;
  double menuItemPrice;
  String menuItemImageUrl;
  int orderQuantity = 1;
  int currentimageindex = 0;
  MenuItem(this.menuItemId, this.menuItemName, this.menuItemPrice, this.menuItemImageUrl);

  String? get itemName => null;
}

class Vendor {
  String vendorId;
  String vendorName;
  List<MenuItem> menuItems;
  Vendor(this.vendorId, this.vendorName, this.menuItems);
}

class Order {
  String menuItemId;
  String menuItemName;
  double menuItemPrice;
  String menuItemImageUrl = 'https://im2.ezgif.com/tmp/ezgif-2-2b7df59594.jpg';
  int quantity;
  //String status;
  Order(this.menuItemId, this.menuItemName, this.menuItemPrice, this.menuItemImageUrl,
      this.quantity, );

  copyWith({required String status}) {}
}

class Cart with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items => _items;

  void addItem(MenuItem menuItem) {
    int index = _items.indexWhere((item) => item.menuItemId == menuItem.menuItemId);
    if (index == -1) {
      _items.add(Order(
          menuItem.menuItemId,
          menuItem.menuItemName,
          menuItem.menuItemPrice,
          menuItem.menuItemImageUrl,
          1));
    } else {
      _items[index].quantity++;
    }
    notifyListeners();
  }

  void removeItem(MenuItem menuItem) {
    int index = _items.indexWhere((item) => item.menuItemId == menuItem.menuItemId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
    }
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((item) {
      total += item.menuItemPrice * item.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.fold(0, (total, item) => total += item.quantity);
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}

class AppProvider extends ChangeNotifier {
  List<Vendor> _vendors = [];

  List<Vendor> get vendors => _vendors;

  

  Future<void> fetchVendors() async {
    QuerySnapshot vendorSnapshot =
        await FirebaseFirestore.instance.collection('vendor').get();
    for (DocumentSnapshot vendorDoc in vendorSnapshot.docs) {
      List<MenuItem> menuItems = [];
      QuerySnapshot menuItemSnapshot =
          await FirebaseFirestore.instance.collection('vendor').doc(vendorDoc.id).collection('menu').get();
      for (DocumentSnapshot menuItemDoc in menuItemSnapshot.docs) {
        //  print('Menu Item Name: ${(menuItemDoc.data() as Map<String, dynamic>)['name'] ?? ''}');
       // print('Menu Item Price: ${(menuItemDoc.data() as Map<String, dynamic>)['price'] ?? ''}');
        //  print('Menu Item Image URL: ${(menuItemDoc.data() as Map<String, dynamic>)['imageurl'] ?? ''}');
        menuItems.add(MenuItem(
            menuItemDoc.id,
            (menuItemDoc.data() as Map<String, dynamic>)['name'] ?? '',
            (menuItemDoc.data() as Map<String, dynamic>)['price'] ?? '',
            (menuItemDoc.data() as Map<String, dynamic>)['imageurl'] ?? '', ));
      }
    //  print(menuItemSnapshot);
      _vendors.add(Vendor(vendorDoc.id, (vendorDoc.data() as Map<String, dynamic>)['name'] ?? '', menuItems));
    }
    notifyListeners();
  }
   
}