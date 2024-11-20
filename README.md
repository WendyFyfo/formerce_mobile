# Formerce Mobile
---
---

## Jawaban Tugas 9
A. Jelaskan mengapa kita perlu membuat model untuk melakukan pengambilan ataupun pengiriman data JSON? Apakah akan terjadi error jika kita tidak membuat model terlebih dahulu?
  >Kita perlu membuat model terlebih dahulu sebelum melakukan pengambilan ataupun pengiriman data JSON agar data dikirimkan dalam format yang tepat. Jika tidak membuat model, maka data yang diterima ataupun dikirim akan dalam format yang tidak sesuai dengan apa yang kita butuhkan.

B.  Jelaskan fungsi dari library http yang sudah kamu implementasikan pada tugas ini!
 > library http digunakan untuk memudahkan membuat http request ke django web service. Library http memberikann


C.  Jelaskan fungsi dari CookieRequest dan jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.
  > Fungsi dari CookieRequest adalah agar aplikasi dapat memperhatikan perubahan pada cookies. instance CookieRequest perlu dibagikan ke semua komponen aplikasi Flutter agar seluruh komponen tersebut dapat responsif dengan perubahan dari cookie (seluruh komponen di-update ketika ada perubahan pada cookies).

D.  Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter!
  > 

 
E.  Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.
  > halaman autentikasi seperti login, register, logout akan mengirimkan request yang bersesuain kepada django web service dengan method dari CookieRequest.
  > Django web service mengirimkan response berupa status dan pesan. Jika success, aplikasi flutter akan memindahkan user ke halaman yang sesuai (login-> homepage, register->login, logout-> login)

F.  Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial)!
  1. Menginstall library `django-cors-header` pada proyek *django* dan menambahkan konfigurasinya pada `settings.py`.
  2. Membuat `django-app` bernama `authentication` dan menambahkan konfigurasinya pada `settings.py` dan url routing pada `formerce/urls.py`
  3. Membuat method-method untuk integrasi authentikasi pada flutter di `authentication/views.py`
  ```python
  from django.contrib.auth import authenticate, login as auth_login, logout as auth_logout
  from django.contrib.auth.models import User
  from django.http import JsonResponse
  from django.views.decorators.csrf import csrf_exempt
  import json

  @csrf_exempt
  def login(request):
      username = request.POST['username']
      password = request.POST['password']
      user = authenticate(username=username, password=password)
      if user is not None:
          if user.is_active:
              auth_login(request, user)
              # Status login sukses.
              return JsonResponse({
                  "username": user.username,
                  "status": True,
                  "message": "Login sukses!"
                  # Tambahkan data lainnya jika ingin mengirim data ke Flutter.
              }, status=200) 
          else:
              return JsonResponse({
                  "status": False,
                  "message": "Login gagal, akun dinonaktifkan."
              }, status=401)

      else:
          return JsonResponse({
              "status": False,
              "message": "Login gagal, periksa kembali email atau kata sandi."
          }, status=401)
      
  @csrf_exempt
  def register(request):
      if request.method == 'POST':
          data = json.loads(request.body)
          username = data['username']
          password1 = data['password1']
          password2 = data['password2']

          # Check if the passwords match
          if password1 != password2:
              return JsonResponse({
                  "status": False,
                  "message": "Passwords do not match."
              }, status=400)
          
          # Check if the username is already taken
          if User.objects.filter(username=username).exists():
              return JsonResponse({
                  "status": False,
                  "message": "Username already exists."
              }, status=400)
          
          # Create the new user
          user = User.objects.create_user(username=username, password=password1)
          user.save()
          
          return JsonResponse({
              "username": user.username,
              "status": 'success',
              "message": "User created successfully!"
          }, status=200)
      
      else:
          return JsonResponse({
              "status": False,
              "message": "Invalid request method."
          }, status=400)
      
  @csrf_exempt
  def logout(request):
      username = request.user.username

      try:
          auth_logout(request)
          return JsonResponse({
              "username": username,
              "status": True,
              "message": "Logout berhasil!"
          }, status=200)
      except:
          return JsonResponse({
          "status": False,
          "message": "Logout gagal."
          }, status=401)
  ```
  4. membuat file `authenticatioon/urls.py` dan menambahkan url routing untuk ketiga fungsi tadi.
  ```python
  from django.urls import path
  from authentication.views import *

  app_name = 'authentication'

  urlpatterns = [
      path('register/', register, name='register'),
      path('login/', login, name='login'),
      path('logout/', logout, name='logout'),
  ]
  ```
  5. install beberapa package untuk integrasi dengan django web service
  ```dart
  flutter pub add provider
  flutter pub add pbp_django_auth
  flutter pub add http
  ```
  6. Memodifikasi root widget sehingga dapat menyediakan `CookieRequest` library ke semua child widgets dengan provider
  ```dart
  ...
    // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_){
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
  ...
  ```
  7. membuat file `screens/login.dart`
  ```dart
  import 'package:formerce_mobile/screens/menu.dart';
  import 'package:flutter/material.dart';
  import 'package:pbp_django_auth/pbp_django_auth.dart';
  import 'package:provider/provider.dart';
  // TODO: Import halaman RegisterPage jika sudah dibuat

  void main() {
    runApp(const LoginApp());
  }

  class LoginApp extends StatelessWidget {
    const LoginApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Login',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.deepPurple,
          ).copyWith(secondary: Colors.deepPurple[400]),
        ),
        home: const LoginPage(),
      );
    }
  }

  class LoginPage extends StatefulWidget {
    const LoginPage({super.key});

    @override
    State<LoginPage> createState() => _LoginPageState();
  }

  class _LoginPageState extends State<LoginPage> {
    final TextEditingController _usernameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();

      return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () async {
                        String username = _usernameController.text;
                        String password = _passwordController.text;

                        // Cek kredensial
                        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                        // Untuk menyambungkan Android emulator dengan Django pada localhost,
                        // gunakan URL http://10.0.2.2/
                        final response = await request
                            .login("http://127.0.0.1:8000/auth/login/", {
                          'username': username,
                          'password': password,
                        });

                        if (request.loggedIn) {
                          String message = response['message'];
                          String uname = response['username'];
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                SnackBar(
                                    content:
                                        Text("$message Selamat datang, $uname.")),
                              );
                          }
                        } else {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Login Gagal'),
                                content: Text(response['message']),
                                actions: [
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 36.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      child: Text(
                        'Don\'t have an account? Register',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
  ```
  8. Membuat file `screens/register.dart
  ```dart
  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:formerce_mobile/screens/login.dart';
  import 'package:pbp_django_auth/pbp_django_auth.dart';
  import 'package:provider/provider.dart';

  class RegisterPage extends StatefulWidget {
    const RegisterPage({super.key});

    @override
    State<RegisterPage> createState() => _RegisterPageState();
  }

  class _RegisterPageState extends State<RegisterPage> {
    final _usernameController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      final request = context.watch<CookieRequest>();
      return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        hintText: 'Enter your username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24.0),
                    ElevatedButton(
                      onPressed: () async {
                        String username = _usernameController.text;
                        String password1 = _passwordController.text;
                        String password2 = _confirmPasswordController.text;

                        // Cek kredensial
                        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                        // Untuk menyambungkan Android emulator dengan Django pada localhost,
                        // gunakan URL http://10.0.2.2/
                        final response = await request.postJson(
                            "http://127.0.0.1:8000/auth/register/",
                            jsonEncode({
                              "username": username,
                              "password1": password1,
                              "password2": password2,
                            }));
                        if (context.mounted) {
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Successfully registered!'),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to register!'),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
  ```
  9. Mengubah `widgets/product_card.dart` agar bisa logout
  ```dart
  ...
  else if (item.name == "Logout") {
    final response = await request.logout(
        // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
        "http://127.0.0.1:8000/auth/logout/");
    String message = response["message"];
    if (context.mounted) {
        if (response['status']) {
            String uname = response["username"];
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa, $uname."),
            ));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
            );
        } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(message),
                ),
            );
        }
    }
  };
  ...
  ```
  10.  Membuat model kustom on menerima dan mengirim data json dengan membuat file `models/product_entry.dart`
  ```dart
  import 'dart:convert';

  List<ProductEntry> moodEntryFromJson(String str) => List<ProductEntry>.from(json.decode(str).map((x) => ProductEntry.fromJson(x)));

  String moodEntryToJson(List<ProductEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  class ProductEntry {
    String model;
    String pk;
    Fields fields;

    ProductEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory ProductEntry.fromJson(Map<String, dynamic> json) => ProductEntry(
      model: json["model"],
      pk: json["pk"],
      fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
      "model": model,
      "pk": pk,
      "fields": fields.toJson(),
    };

  }

  class Fields {
      int user;
      String name;
      int price;
      String description;
      String image;

      Fields({
          required this.user,
          required this.name,
          required this.price,
          required this.description,
          required this.image,
      });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
      user: json["user"],
      name: json["name"],
      description: json["description"],
      price: json["price"],
      image: json["image"]
    );

    Map<String, dynamic> toJson() => {
      "user": user,
      "name": description,
      "description": description,
      "price":  price,
      "image": image,
    };

  }

  ...
  ```
  11. menambahkan 1 baris kode pada `android/app/src/main/AndroidManifest.xml`
```xml
...
    <application>
    ...
    </application>
    <!-- Required to fetch data from the Internet. -->
    <uses-permission android:name="android.permission.INTERNET" />
...
```
  12. Membuat file `screens/list_productentry.dart untuk menampilkan entri-entri produk
```dart
import 'package:flutter/material.dart';
import 'package:formerce_mobile/models/product_entry.dart';
import 'package:formerce_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductEntryPage extends StatefulWidget {
  const ProductEntryPage({super.key});

  @override
  State<ProductEntryPage> createState() => _ProductEntryPageState();
}

class _ProductEntryPageState extends State<ProductEntryPage> {
  Future<List<ProductEntry>> fetchProduct(CookieRequest request) async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final response = await request.get('http://127.0.0.1:8000/json/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;
    
    // Melakukan konversi data json menjadi object ProductEntry
    List<ProductEntry> listProduct = [];
    for (var d in data) {
      if (d != null) {
        listProduct.add(ProductEntry.fromJson(d));
      }
    }
    return listProduct;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Entry List'),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (!snapshot.hasData) {
              return const Column(
                children: [
                  Text(
                    'Belum ada data product pada mental health tracker.',
                    style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                  ),
                  SizedBox(height: 8),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) => Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${snapshot.data![index].fields.product}",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.feelings}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.productIntensity}"),
                      const SizedBox(height: 10),
                      Text("${snapshot.data![index].fields.time}")
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
```
  13. Menambahkan file tadi ke `widgets/left_drawer.dart` agar bisa mengakses daftar product melalui drawer.
```dart
...
          ListTile(
            leading: const Icon(Icons.add_shopping_cart_outlined),
            title: const Text('Daftar Product'),
            onTap: () {
              //route ke halaman daftar product
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductEntryPage(),
                )
              );
            },
          ),
...
```
  14. membuat fungsi baru pada `main/views.py` untuk menambahkan product baru lewat flutter dan route url-nya pada `main
`views.py`
```python
...
@csrf_exempt
def create_product_flutter(request):
    if request.method == 'POST':

        data = json.loads(request.body)
        new_product = ProductEntry.objects.create(
            user=request.user,
            name=data["name"],
            price=int(data["price"]),
            description=data["description"]
        )

        new_product.save()

        return JsonResponse({"status": "success"}, status=200)
    else:
        return JsonResponse({"status": "error"}, status=401)
```
`urls.py`
```python
...
  path('create-flutter/'), create_product_flutter, name='create_product_flutter'),
```
  15. Mengubah `screens/productentry_form.dart` agar dapat mengirimkan data ke django web service
```dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:formerce_mobile/screens/menu.dart';
import 'package:formerce_mobile/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class ProductEntryFormPage extends StatefulWidget {
  const ProductEntryFormPage({super.key});

  @override
  State<ProductEntryFormPage> createState() => _ProductEntryFormPageState();
}

class _ProductEntryFormPageState extends State<ProductEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _product = "";
  String _description = "";
  int _price = 0;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Tambah Product Kamu Hari ini',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Product",
                      labelText: "Product",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _product = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Product tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Description",
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _description = value!;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Description tidak boleh kosong!";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Price",
                      labelText: "Price",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      setState(() {
                        _price = int.tryParse(value!) ?? 0;
                      });
                    },
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Amount tidak boleh kosong!";
                      }
                      else if (int.tryParse(value) == null) {
                        return "Amount harus berupa angka!";
                      }
                      else if (int.tryParse(value)! <= 0){
                        return "Amount minimal 1 (satu)!";
                      }
                      return null;
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Kirim ke Django dan tunggu respons
                          // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                          final response = await request.postJson(
                              "http://127.0.0.1:8000/create-flutter/",
                              jsonEncode(<String, String>{
                                  'name': _product,
                                  'price': _price.toString(),
                                  'description': _description,
                              // TODO: Sesuaikan field data sesuai dengan aplikasimu
                              }),
                          );
                          if (context.mounted) {
                              if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                  content: Text("Mood baru berhasil disimpan!"),
                                  ));
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => MyHomePage()),
                                  );
                              } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                      content:
                                          Text("Terdapat kesalahan, silakan coba lagi."),
                                  ));
                              }
                          }
                      }
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}
```
## Jawaban Tugas 8
A. Apa kegunaan `const` di Flutter? Jelaskan apa keuntungan ketika menggunakan `const`, dan kapan sebaiknya tidak digunakan?
>`const` pada Flutter digunakan  untuk membuat objek yang bersifat immutable, artinya objek tersebut tidak dapat diubah setelah dibuat. Ketika menandai sebuah widget atau nilai dengan const, Flutter dapat mengoptimalkan performa aplikasi karena objek tersebut hanya di-render sekali dan langsung disimpan dalam memori.

B. Jelaskan dan bandingkan penggunaan *Column* dan *Row* pada Flutter. Berikan contoh implementasi dari masing-masing layout widget ini!
>Column dan Row adalah widget layout di Flutter yang digunakan untuk mengatur posisi widget lainnya dalam bentuk vertikal dan horizontal.

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
>Elemen input yang saya gunakan tugas ini hanyalah TextField karena tiap input berupa text baik huruf maupun angka. Terdapat beberapa elemen input yang tidak saya gunakan seperti checkbox, slider, swith, dan radio button karena tidak sesuai dengan tipe input yang saya perlukan.

D. Bagaimana cara kamu mengatur tema(theme) dalam aplikasi flutter agar aplikasi yang dibuat konsisten? Apakah kamu mengimplementasikan tema pada aplikasi yang kamu buat?
>Untuk membuat aplikasi yang konsisten secara tampilan, Flutter menyediakan fitur ThemeData. Fitur ini memungkinkan kita mengatur warna, teks, dan *style* lainnya secara konsisten di seluruh aplikasi. Ya, saya mengimplementasikan tema untuk warna pada aplikasi saya.

E. Bagaimana cara kamu menangani navigasi dalam aplikasi dengan banyak halaman pada flutter?
>Navigasi dalam aplikasi dengan banyak halaman pada flutter dapat dilakukan dengan fitur drawer untuk pergi ke berbagai halaman dan juga class Navigator yang memungkinkan untuk pergi ke halaman sebelum dan setelah halaman yang sedang dikunjungi sekarang.

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
