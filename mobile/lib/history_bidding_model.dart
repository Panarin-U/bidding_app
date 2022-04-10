// To parse this JSON data, do
//
//     final history = historyFromMap(jsonString);

import 'dart:convert';

class HistoryBidding {
  HistoryBidding({
    this.price,
    this.bidder,
    this.dateTime,
  });

  int? price;
  String? bidder;
  int? dateTime;

  factory HistoryBidding.fromJson(String str) => HistoryBidding.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HistoryBidding.fromMap(Map<String, dynamic> json) => HistoryBidding(
    price: json["price"] == null ? null : json["price"],
    bidder: json["bidder"] == null ? null : json["bidder"],
    dateTime: json["dateTime"] == null ? null : json["dateTime"],
  );

  Map<String, dynamic> toMap() => {
    "price": price == null ? null : price,
    "bidder": bidder == null ? null : bidder,
    "dateTime": dateTime == null ? null : dateTime,
  };
}
