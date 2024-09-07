import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ArticleGlobal {
  String id;
  String nom;
  String categories;
  String image;
  String informationNutritive;

  ArticleGlobal(
    this.id,
    this.nom,
    this.categories,
    this.image,
    this.informationNutritive,
  );

  ArticleGlobal.fromMap(Map<String, dynamic> data)
      : id = data["id"],
        nom = data["nom"],
        categories = data["categories"],
        image = data["image"],
        informationNutritive = data["informationNutritive"];

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nom": nom,
      "categories": categories,
      "image": image,
      "informationNutritive": informationNutritive,
    };
  }

  void setNom(String nom) {
    this.nom = nom;
  }

  void setCategories(String categories) {
    this.categories = categories;
  }

  void setImage(String image) {
    this.image = image;
  }

  void setInformationNutritive(String informationNutritive) {
    this.informationNutritive = informationNutritive;
  }
}

class ArticleShared {
  String addBy;
  String categorie;
  String image;
  String nom;
  Timestamp date;

  ArticleShared(
    this.addBy,
    this.categorie,
    this.image,
    this.nom,
    this.date,
  );

  ArticleShared.fromMap(Map<String, dynamic> data)
      : addBy = data["addBy"],
        categorie = data["categorie"],
        image = data["image"],
        nom = data["nom"],
        date = data["date"];

  Map<String, dynamic> toMap() {
    return {
      "addBy": addBy,
      "category": categorie,
      "image": image,
      "name": nom,
      "timestamp": date,
    };
  }

  void setAddBy(String addBy) {
    this.addBy = addBy;
  }

  void setCategorie(String categorie) {
    this.categorie = categorie;
  }

  void setImage(String image) {
    this.image = image;
  }

  void setNom(String nom) {
    this.nom = nom;
  }

  void setDate(Timestamp date) {
    this.date = date;
  }
}

class Nutiments {
  String fat;
  String salt;
  String saturatedFat;
  String sugars;

  Nutiments(
    this.fat,
    this.salt,
    this.saturatedFat,
    this.sugars,
  );

  Nutiments.fromMap(Map<String, dynamic> data)
      : fat = data["fat"],
        salt = data["salt"],
        saturatedFat = data["saturated-fat"],
        sugars = data["sugars"];

  @override
  String toString() {
    return "Nutiments: [fat: fat, salt: $salt, saturated-fat: $saturatedFat, sugars: $sugars]";
  }

  Map<String, dynamic> toMap() {
    return {
      "fat": fat,
      "salt": salt,
      "saturated-fat": saturatedFat,
      "sugars": sugars,
    };
  }
}

class Article {
  String id;
  String nom;
  String categorie;
  String image;
  Nutiments informationNutritive;
  String? groceryId;

  Article({
    required this.id,
    required this.nom,
    required this.categorie,
    required this.image,
    required this.informationNutritive,
  });

  Article.fromJ(Map<String, dynamic> data)
      : id = data["products"][0]["_id"],
        nom = data["products"][0]["product_name_fr"],
        categorie = data["products"][0]["categories_tags"][0].split(":")[1],
        image = data["products"][0]["image_url"],
        informationNutritive =
            Nutiments.fromMap(data["products"][0]["nutrient_levels"]);

  Map<String, dynamic> toMap() {
    return {
      "id": id,
    };
  }

  Map<String, dynamic> toMapBd() {
    return {
      "id": id,
      "nom": nom,
      "categorie": categorie,
      "image": image,
      "informationNutritive": informationNutritive.toMap(),
    };
  }

  @override
  String toString() {
    return "Article: $id $nom, $categorie, $image, $informationNutritive";
  }
}

Future<Article> load(String id) async {
  late final article;
  final url =
      Uri.parse("https://world.openfoodfacts.org/api/v2/search?code=$id");
  try {
    var rep = await http.get(url);
    if (rep.statusCode == 200) {
      var data = jsonDecode(rep.body);
      if (data["produits"] == []) {
        return Article(
            id: "NotFound",
            nom: '',
            categorie: '',
            image: '',
            informationNutritive: Nutiments('', '', '', ''));
      }
      article = Article.fromJ(data);
    } else {
      print("Request failed with status: ${rep.statusCode}.");
    }
  } on Exception catch (e) {
    print("Got error $e");
  }
  return article;
}
