import 'package:flutter/material.dart';

class OpenFoodItemPopUp extends StatelessWidget {
  const OpenFoodItemPopUp({
    super.key,
    required this.item,
    required this.onclick,
  });
  final dynamic item;
  final dynamic onclick;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Builder(
        builder: (context) {
          var width = MediaQuery.of(context).size.width;

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: const Color.fromARGB(0, 179, 179, 179),
              shadowColor: const Color.fromARGB(0, 179, 179, 179),
              child: Stack(
                children: [
                  const Image(
                      image: AssetImage(
                          'assets/images/output-onlinepngtools (3).png')),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05),
                        child: ListTile(
                          leading: Image.network(item.image),
                          title: Text(
                            "Name of the product: ${item.nom}",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          subtitle: Text(
                            'Category: ${item.categorie}',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(height: 8),
                          Text(
                            'Fat: ${item.informationNutritive.fat}',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Saturated fat: ${item.informationNutritive.saturatedFat}',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sugars: ${item.informationNutritive.sugars}',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Salt: ${item.informationNutritive.salt}',
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                      Container(
                        margin: width < 400
                            ? EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.01)
                            : EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                                style: ButtonStyle(
                                  minimumSize: width < 400
                                      ? MaterialStateProperty.all<Size>(
                                          const Size(50, 50))
                                      : MaterialStateProperty.all<Size>(
                                          const Size(100, 50)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 255, 205, 41)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 102, 78, 0)),
                                )),
                            TextButton(
                                onPressed: () {
                                  onclick(item.id);
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Add'),
                                style: ButtonStyle(
                                  minimumSize: width < 400
                                      ? MaterialStateProperty.all<Size>(
                                          const Size(50, 50))
                                      : MaterialStateProperty.all<Size>(
                                          const Size(100, 50)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 255, 205, 41)),
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromARGB(255, 102, 78, 0)),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
