import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final List<ItemHomePage> items =[
    ItemHomePage("Lihat Daftar Produk", Icons.shop_2_outlined, Colors.lightBlue),
    ItemHomePage("Tambah Produk", Icons.add_shopping_cart_outlined, const Color.fromARGB(255, 249, 172, 4)),
    ItemHomePage("Logout", Icons.logout_outlined, Colors.red),
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formerce',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
                  
                  GridView.count(
                    primary: true,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,

                    shrinkWrap: true,

                    children: items.map((ItemHomePage item){
                      return ItemCard(item);
                    }).toList(),
                  ),
                ],
              ),
            )],)
      )
    );
  }

}

class ItemHomePage {
  final String name;
  final IconData icon;
  final Color backgroundColor;

  ItemHomePage(this.name, this.icon, this.backgroundColor);
}

class ItemCard extends StatelessWidget {
  final ItemHomePage item;
  
  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: item.backgroundColor,
      borderRadius: BorderRadius.circular(12),

      child: InkWell(
        onTap:() {
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("Kamu telah menekan tombol ${item.name}!"),
              backgroundColor: item.backgroundColor,
            )
          );
        },

        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color:Colors.white))
              ]
            ),
          )
        )
      )
    );
  }
}

