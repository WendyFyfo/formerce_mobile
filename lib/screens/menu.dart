import 'package:flutter/material.dart';
import 'package:formerce_mobile/widgets/left_drawer.dart';
import 'package:formerce_mobile/widgets/product_card.dart';

class MyHomePage extends StatelessWidget {
  final List<ItemHomepage> items =[
    ItemHomepage("Lihat Daftar Produk", Icons.shop_2_outlined, Colors.lightBlue),
    ItemHomepage("Tambah Produk", Icons.add_shopping_cart_outlined, const Color.fromARGB(255, 249, 172, 4)),
    ItemHomepage("Logout", Icons.logout_outlined, Colors.red),
  ];
  
  MyHomePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Formerce',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: const LeftDrawer(),
      // Body halaman dengan padding di sekelilingnya.
      body: Padding(
        padding: const EdgeInsets.all(16),
        //menyusun widget secara vertikal dalam sebuah kolom
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text(
                      'Welcome to Formerce',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      )
                    ) 
                  ),
                  
                  //grid untuk menampilkan ItemCard dalam bentuk grid 3 kolom
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    shrinkWrap: true,

                    children: items.map((ItemHomepage item){
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            )
          ],
        )
      )
    );
  }
}