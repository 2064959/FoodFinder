import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Grocery {
  late final String id;
  String name;
  String createBy;
  String? icon;
  List<ObjectItem>? items;

  

  Grocery(
    this.id,
    this.name,
    this.createBy,
    this.icon,
    this.items,
  );

  Grocery.fromMap(Map<String, dynamic> data, String docId)
      : id = docId,
        name = data["name"],
        createBy = data["createBy"],
        icon = data["icon"],
        items = List.generate(
            data["items"].length,
            (index) => ObjectItem.fromMap(
                data["items"][index] as Map<String, dynamic>));

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "createBy": createBy,
      "icon": icon,
      "items": items,
    };
  }

  Map<String, dynamic> toMapBd() {
    return {
      "id": id,
      "name": name,
      "createBy": createBy,
      "icon": icon,
    };
  }

  void setId(String id) {
    this.id = id;
  }

  void setName(String name) {
    this.name = name;
  }

  void setCreateBy(String createBy) {
    this.createBy = createBy;
  }

  void setIcon(String icon) {
    this.icon = icon;
  }

  void addItem(ObjectItem item) {
    items!.add(item);
  }

  void removeItemById(String id) {
    items!.removeWhere((element) => element.id == id);
  }
}

class ObjectItem with ChangeNotifier {
  final String id;
  int quantity;
  String status;

  ObjectItem(
    this.id,
    this.quantity,
    this.status,
  );

  get stat => status;
  void done(String stat) {
    status = stat;
    notifyListeners();
  }

  ObjectItem.fromMap(Map<String, dynamic> data)
      : id = data["id"],
        quantity = data["quantity"],
        status = data["status"];

  Map<String, Object> toMap() {
    return {
      "id": id,
      "quantity": quantity,
      "status": status,
    };
  }
}

Future<Grocery> getGroceryByGroup(String group) async {
  final grocerySnapshot = await FirebaseFirestore.instance
      .collection("epiceries")
      .doc(group)
      .get()
      .then((value) =>
          Grocery.fromMap(value.data() as Map<String, dynamic>, value.id));

  return grocerySnapshot;
}

List<Map> convertItemsToMap(List items) {
  List<Map> itemMap = [];
  for (var item in items) {
    Map step = item.toMap();
    itemMap.add(step);
  }
  return itemMap;
}
