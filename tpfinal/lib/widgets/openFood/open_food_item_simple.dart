import 'package:flutter/material.dart';
import 'package:tpfinal/model/item.dart';

class OpenFoodItemSimple extends StatelessWidget {
  const OpenFoodItemSimple({
    super.key,
    required this.context,
    required this.snapshot,
  });

  final BuildContext context;
  final AsyncSnapshot<Article> snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.085,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 179, 179, 179),
      ),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                snapshot.data!.categorie,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.only(left: 20),
              width: MediaQuery.of(context).size.width * 0.55,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.data!.nom,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.07,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Caveat',
                      ),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Code: ${snapshot.data!.id}",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
