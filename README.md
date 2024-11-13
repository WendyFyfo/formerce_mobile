# Formerce Mobile
---

## Jawaban Tugas 8
A. Apa kegunaan `const` di Flutter? Jelaskan apa keuntungan ketika menggunakan `const`, dan kapan sebaiknya tidak digunakan?
  `const` pada Flutter digunakan  untuk membuat objek yang bersifat immutable, artinya objek tersebut tidak dapat diubah setelah dibuat. Ketika menandai sebuah widget atau nilai dengan const, Flutter dapat mengoptimalkan performa aplikasi karena objek tersebut hanya di-render sekali dan langsung disimpan dalam memori.

B. Jelaskan dan bandingkan penggunaan *Column* dan *Row* pada Flutter. Berikan contoh implementasi dari masing-masing layout widget ini!
  Column dan Row adalah widget layout di Flutter yang digunakan untuk mengatur posisi widget lainnya dalam bentuk vertikal dan horizontal.

  Column: Mengatur *children*-nya secara vertikal (dari atas ke bawah).
  ```dart
  Column(
    // Widget-widget dalam children akan diposisikan secara vertikal dalam 1 kolom (Column)
    children: [
      Text('Hello'),
      Text('World'),
      Icon(Icons.add),
    ],
  )
  ```

  Row: Mengatur *children*-nya secara horizontal (dari kiri ke kanan).
  ```dart
  Row(
    // Widget-widget dalam children akan diposisikan secara horizontal dalam 1 baris (row)
    children: [
      Text('Hello'),
      Text('World'),
      Icon(Icons.star),
    ],
  )
  ```  

C. Sebutkan apa saja elemen input yang kamu gunakan pada halaman *form* yang kamu buat pada tugas kali ini. apakah terdapat elemen input flutter lain yang tidak kamu gunakan pada tugas ini? Jelaskan!
  Elemen input yang saya gunakan tugas ini hanyalah TextField karena tiap input berupa text baik huruf maupun angka. Terdapat beberapa elemen input yang tidak saya gunakan seperti checkbox, slider, swith, dan radio button karena tidak sesuai dengan tipe input yang saya perlukan.

D. Bagaimana cara kamu mengatur tema(theme) dalam aplikasi flutter agar aplikasi yang dibuat konsisten? Apakah kamu mengimplementasikan tema pada aplikasi yang kamu buat?
  Untuk membuat aplikasi yang konsisten secara tampilan, Flutter menyediakan fitur ThemeData. Fitur ini memungkinkan kita mengatur warna, teks, dan *style* lainnya secara konsisten di seluruh aplikasi. Ya, saya mengimplementasikan tema untuk warna pada aplikasi saya.

E. Bagaimana cara kamu menangani navigasi dalam aplikasi dengan banyak halaman pada flutter?
  Navigasi dalam aplikasi dengan banyak halaman pada flutter dapat dilakukan dengan fitur drawer untuk pergi ke berbagai halaman dan juga class Navigator yang memungkinkan untuk pergi ke halaman sebelum dan setelah halaman yang sedang dikunjungi sekarang.

## Jawaban Tugas 7
A. Jelaskan apa yang dimaksud dengan stateless widget dan stateful widget, dan jelaskan perbedaan dari keduanya.
    Stateless widget adalah widget yang statis,artinya state dari widget tersebut tidak berubah-ubah, contohnya adalah Icon dan Text. Stateful widget pada flutter adalah widget yang statenya dapat berubah akibat interaksi dari user atau adanya data yang diperbarui, Contohnya seperti checkbox dan radio button.

B. Sebutkan widget apa saja yang kamu gunakan pada proyek ini dan jelaskan fungsinya!
1. Scaffold: Struktur dasar visual untuk aplikasi, seperti tempat  
2. AppBar, body, dan lainnya.
3. AppBar: Container di bagian atas layar yang menampilkan judul dan aksi.
4. Container: Menggabungkan gambar, posisi, dan ukuran, digunakan untuk mengatur tata letak.
5. Padding: Memberikan jarak di sekitar widget.
6. Column & Row: Menyusun widget secara vertikal (Column) atau horizontal (Row).
7. GridView: Menyusun widget dalam bentuk grid.
8. Text: Menampilkan teks.
9. TextStyle: Mengatur gaya dan format teks.
10. Icon: Menampilkan ikon sebagai alternatif teks.
11. Material: Memberikan tampilan dan elemen material pada widget.

C. Apa fungsi dari setState()? Jelaskan variabel apa saja yang dapat terdampak dengan fungsi tersebut.
    fungsi method setState adalah untuk memberi tahu framework bahwa state dari suatu widget berubah untuk memicu rebuild dari *view*-nya, sehingga perubahannya segera ditampilkan.

D. Jelaskan perbedaan antara const dengan final.
    Nilai variabel `final` hanya dapat diinisialisasi satu kali dan nilainya dapat ditentukan pada saat runtime.
    Nilai variabel `const` harus sudah diketahui pada saat kompilasi, tetapi nilainya juga tidak dapat berubah. 
    Perbedaan lainnya adalah kita dapat mengubah elemen dari collection yang dideklarasikan dengan `final`, tetapi jika didelakarasikan dengan `const` maka elemen dari collection tersebut juga tidak dapat berubah.

E. Jelaskan bagaimana cara kamu mengimplementasikan checklist-checklist di atas. 
    
1. Membuat proyek flutter baru dan masuk ke direktori proyek tersebut.
```
flutter create formerce_mobile
cd formerce_mobile
```

2. Pada `lib/` membuat file baru bernama `menu.dart` dan memindahkan class myHomePage dan _MyHomePageState,s serta mengimport menu.dart
```dart
// lib/menu.dart
import 'package:mental_health_tracker/menu.dart';

class MyHomePage ... {
    ...
}

class _MyHomePageState ... {
    ...
}
```

3. Mengubah isi MyHomePage dan menghapus class _MyHomePageState
```dart
// lib/menu.dart
...
class MyHomePage ... {
    MyHomePage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        );
    }
}
```

4. Mengubah beberapa kode pada `lib/main.dart`
```dart
// lib/main.dart
...
    theme:Theme.data(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, primary: const Color.fromARGB(255, 0, 100, 183), secondary: Colors.lightBlue),
        useMaterial3: true,
    ),
    home: MyHomePage(),
...
```

5. Membuat class yang berisi untuk button yang akan dibuat pada `menu.dart`
```dart
// lib/menu.dart
...
class ItemHomePage {
  final String name; //nama serta tulisan yang tampil di button
  final IconData icon; //icon button
  final Color backgroundColor; //background color untuk button

  ItemHomePage(this.name, this.icon, this.backgroundColor);
}
```

6. Membuat list dari ItemHomePage yang berisi tombol-tombol yang akan dibuat pada class MyHomePage
```dart
// lib/menu.dart
class MyHomePage extends StatelessWidget {
    ...

    final List<ItemHomePage> items =[
        ItemHomePage("Lihat Daftar Produk", Icons.shop_2_outlined, Colors.lightBlue),
        ItemHomePage("Tambah Produk", Icons.add_shopping_cart_outlined, const Color.fromARGB(255, 249, 172, 4)),
        ItemHomePage("Logout", Icons.logout_outlined, Colors.red),
    ];
    ...
```

7. Membuat class ItemCard untuk menampilkan tombol-tombol yang telah dibuat, serta fungsi untuk menampilkan pesan ketika tombol ditekan
```dart
// lib/menu.dart
...
class ItemCard extends StatelessWidget {
  final ItemHomePage item;
  
  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {

    return Material(
      color: item.backgroundColor, // warna background button
      borderRadius: BorderRadius.circular(12), //mengubah sudut kartu menjadi melengkung

      child: InkWell(
        //aksi ketika kartu ditekan
        onTap:() {
            //Menampilkan pesan SnackBar ketika kartu ditekan.
          ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("Kamu telah menekan tombol ${item.name}!"),
              backgroundColor: item.backgroundColor, //Warna background SnackBar
            )
          );
        },

        //Container untuk menyimpan Icon dan Text dan button
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
                //Menyusun letak Icon dan Text pada kartu
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
```

8. Mengubah `Widget build()` pada class MyHomePage, sehingga dapat menampilkan button dan pesan yang telah dibuat
```dart
// lib/menu.dart
class MyHomePage extends StatelessWidget {
    ...

  @override
  Widget build(BuildContext context){
    return Scaffold(
        // AppBar untuk menampilkan judul pada bagian atas layar
      appBar: AppBar(
        title: const Text('Formerce',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        //mengatur warna background AppBar berdasarkan skema warna tema
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
            )],
        )
      )
    );
  }
}
```
