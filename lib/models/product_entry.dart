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