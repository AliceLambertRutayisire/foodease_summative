import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:project/models/meals.dart';
import 'package:project/students/Dashboard/restaurants.dart';
import 'package:project/students/profile2.dart';
import 'package:provider/provider.dart';
import '../../animation.dart';
import '../Order/cart.dart';




 
class MyHomePage3 extends StatelessWidget {
  const MyHomePage3({super.key});

  @override
  Widget build(BuildContext context) {
    return
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => AppProvider()..fetchVendors())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    );
}
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  final StreamController<int> _selectedIndexStreamController = StreamController<int>();

  Stream<int> get selectedIndexStream => _selectedIndexStreamController.stream;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateSelectedIndex(int index) {
    _selectedIndex = index;
    _selectedIndexStreamController.add(index);
   // notifyListeners();
  }

  @override
  void dispose() {
    _selectedIndexStreamController.close();
    super.dispose();
  }

    @override
  void initState() {
    super.initState();
    _selectedIndexStreamController.add(0);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final cart = Provider.of<Cart>(context);
    final vendors = appProvider.vendors;
     //print('Number of vendors: ${vendors.length}');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Ready? Set, Order!',
        style: TextStyle(
            fontFamily: 'Barlow Semi Condensed',
             color: Color.fromRGBO(201, 199, 126, 1),
            fontWeight: FontWeight.w500,
            fontSize: 18),),

        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Color(0xFFBB902D),
            onPressed: () {
              Navigator.of(context).push(
                CustomPageRoute(
                  
                    child:CartPage()
                  
                ),
              );
            },
          )
        ],
        backgroundColor: Color.fromRGBO(50, 41, 57, 1),
      ),
      backgroundColor: Color.fromRGBO(50, 41, 57, 1),
      body: vendors.isEmpty
          ? Center(child: CircularProgressIndicator())
          : vendors[_selectedIndex].menuItems.isEmpty
              ? Center(child: Text('No menu items found'))
              : MenuList(vendors[_selectedIndex].menuItems, imageurls),
            drawer:
              MyDrawer(),
            
            bottomNavigationBar: StreamBuilder<int>(
            stream: _selectedIndexStreamController.stream,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              int? currentIndex = snapshot.data;
                        
            if (vendors.length >= 2) {
            return
            BottomNavigationBar(
            items: vendors
              .asMap()
              .map((index, vendor) => MapEntry(
                index,
                BottomNavigationBarItem(
                  icon: Icon(Icons.fastfood),
                  backgroundColor: Color.fromRGBO(50, 41, 57, 1),
                  label: index == currentIndex
                    ? vendor.vendorName ?? ''
                    :  vendor.vendorName ?? '', 
                ),
              ))
              .values
              .toList(),
            currentIndex: currentIndex ?? 0,
            showUnselectedLabels: true, // <-- add this line
            onTap: _onItemTapped,
          );

              } 
              else {
                return Container(
                  height: 0,
                  width: 0,
                );
              }
                }
              ),

              );
            }
          }

class MenuList extends StatelessWidget {
  final List<MenuItem> menuItems;
  final List<String> imageurls;
  MenuList(this.menuItems, this.imageurls);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              height: 400,
              viewportFraction: 0.8,
             // autoPlay: true,
            ),
            items: menuItems.asMap().entries.map((entry) {
              int index = entry.key;
              MenuItem menuItem = entry.value;
              return Builder(
                builder: (BuildContext context) {
                  return MealCard(menuItem, imageurls[index]);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class MealCard extends StatelessWidget {
  final MenuItem menuItem;
  final String menuItemImageUrl;
  MealCard(this.menuItem, this.menuItemImageUrl);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(blurRadius: 10.0)],
        color: Color.fromRGBO(50, 41, 57, 1),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(menuItemImageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    print(Text('No image found'));
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  menuItem.menuItemName,
                  style: TextStyle(
                    fontSize: 16.0,
                     color: Color.fromRGBO(201, 199, 126, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  '\RWF ${menuItem.menuItemPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                 color: Color.fromRGBO(201, 199, 126, 1),
                onPressed: () {
                  cart.removeItem(menuItem);
                },
              ),
              Text(menuItem.orderQuantity.toString()),
              IconButton(
                icon: Icon(Icons.add),
                color: Color.fromRGBO(201, 199, 126, 1),
                onPressed: () {
                  cart.addItem(menuItem);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

