


import 'package:bidding_app/history_bidding_model.dart';
import 'package:bidding_app/styles.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class HistoryCard extends StatelessWidget {

  final HistoryBidding historyBidding;

  HistoryCard({ required this.historyBidding });

  @override
  Widget build(BuildContext context) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]},';
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180,
            child: Text('฿ ${historyBidding.price.toString().replaceAllMapped(reg, mathFunc)}', style: Styles.bold.copyWith(fontSize: 18),),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${historyBidding.bidder![0]}***${historyBidding.bidder![historyBidding.bidder!.length - 1]}', style: Styles.bold.copyWith(fontSize: 14),),
              Text(Jiffy(DateTime.fromMillisecondsSinceEpoch(historyBidding.dateTime ?? 0)).format('dd MMM yyy hh:mm:ss [น.]'), style: Styles.bold.copyWith(fontSize: 14),),
            ],
          )
        ],
      ),
    );
  }


}