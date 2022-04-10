

import 'package:bidding_app/color_utils.dart';
import 'package:bidding_app/product_model.dart';
import 'package:bidding_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class ProductCard extends StatelessWidget {

  final Product product;

  ProductCard({ required this.product });

  String getDiffDate() {
    DateTime _d = DateTime.fromMillisecondsSinceEpoch(product.endTime);
    DateTime _now = DateTime.now().toLocal();
    Duration _diff = _d.difference(_now);

    return '${_diff.inDays} วัน : ${_diff.inHours} : ${_diff.inMinutes} : ${_diff.inSeconds % 60}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image(
              image: AssetImage('assets/img_product.png'),
              width: 88,
              height: 88,
            ),
          ),
          SizedBox(width: 16,),
          Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: HexColor.fromHex('#393F49'), fontSize: 16),
                  ),
                  SizedBox(height: 4,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.timer, size: 22, color: Styles.colorTextPrimary,),
                      SizedBox(width: 8,),
                      Text(getDiffDate(), style: Styles.bold,)
                    ],
                  ),
                  SizedBox(height: 4,),
                  Text('฿ ${product.biddingPrice}', style: Styles.bold.copyWith(fontSize: 20),)
                ],
              )
          )
        ],
      ),
    );
  }

}