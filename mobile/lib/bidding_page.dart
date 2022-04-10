


import 'dart:convert';

import 'package:bidding_app/color_utils.dart';
import 'package:bidding_app/countdown.dart';
import 'package:bidding_app/history_bidding_model.dart';
import 'package:bidding_app/history_card.dart';
import 'package:bidding_app/product_model.dart';
import 'package:bidding_app/styles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;


class BiddingPage extends StatefulWidget {

  final Product product;

  BiddingPage({ required this.product });

  @override
  State<StatefulWidget> createState() {
   return _BiddingPageState();
  }
  
}

class _BiddingPageState extends State<BiddingPage> {


  List<HistoryBidding> _list = [];
  Dio _dio = new Dio();
  int _bidPrice = 0;

  int _bid = 100;

  IOWebSocketChannel? socket;

  String _name = '';

  SnackBar _snackBar = SnackBar(
    content: const Text('มีคนอื่นประมูลราคาสูงกว่าคุณแล้ว'),
    action: SnackBarAction(
      label: 'ตกลง',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );

  @override
  void initState(){
    Future.delayed(
        Duration(seconds: 1))
        .then((value) => _displayTextInputDialog())
        .then((bool? value) {
          if (value ?? false) {
            connectSocket().then((value) => getHistory());
          }
        });
    super.initState();
  }

  @override
  void dispose() {
    socket?.sink.close(status.goingAway);
    super.dispose();
  }

  Future getHistory() async {
    try {
      Response rs = await _dio.get('http://localhost:8999/history/${widget.product.id}');
      var mapList = List<HistoryBidding>.from(rs.data['data'].map((d) => HistoryBidding.fromMap(d)))..sort((a , b) => b.price!.compareTo(a.price!));
      setState(() {
        _list = mapList;
        _bidPrice = mapList[0].price!;
      });
    } catch(e) {
      print(e);
    }
  }

  Future connectSocket() async {
    final channel = IOWebSocketChannel.connect('ws://localhost:8999');

    channel.stream.listen((message) {
      Map<String, dynamic> map = json.decode(message);
      print(widget.product.id);
      if (map['id'] != null && map['id'] == widget.product.id) {
        HistoryBidding _b = HistoryBidding.fromMap(map);
        setState(() {
          _list.insert(0, _b);
          _bidPrice = _b.price!;
        });
        if (_b.bidder != _name) {
          ScaffoldMessenger.of(context).showSnackBar(_snackBar);
        }
      }
      // channel.sink.add('received!');
    });

    socket = channel;

  }

  Future addBidding() async {
     try {
       await _dio.post('http://localhost:8999/bidding', data: {'id': widget.product.id, 'bidder': _name, "price": _bidPrice + _bid });
     } catch(e) {

     }
  }

  @override
  Widget build(BuildContext context) {

    String endTimeDate = Jiffy(DateTime.fromMillisecondsSinceEpoch(widget.product.endTime)).format("dd MMM yyy hh:mm:ss");

    DateTime _d = DateTime.fromMillisecondsSinceEpoch(widget.product.endTime);
    DateTime _now = DateTime.now().toLocal();
    Duration _diff = _d.difference(_now);

    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String Function(Match) mathFunc = (Match match) => '${match[1]},';

    return Scaffold(
      appBar: AppBar(
        title: Text('ประมูลสินค้า', style: Styles.bold.copyWith(fontSize: 20),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16,),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(
                  image: AssetImage('assets/img_product_big.png'),
                  width: 250,
                  height: 250,
                ),
              ),
            ),
            SizedBox(height: 8,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product.name, style: Styles.medium.copyWith(fontSize: 20),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ประมูลขั้นต่ำ ครั้งละ ฿100', style: Styles.light.copyWith(fontSize: 12, color: Styles.colorTextSecondary),),
                      SizedBox(width: 8,),
                      Container(height: 16, width: 1, color: Styles.colorTextSecondary,),
                      SizedBox(width: 8,),
                      Text('ปิดประมูล ${endTimeDate}', style: Styles.light.copyWith(fontSize: 12, color: Styles.colorTextSecondary),)
                    ],
                  ),
                  SizedBox(height: 16,),
                  Center(
                    child: Text('จะหมดเวลาในอีก', style: Styles.regular.copyWith(color: Styles.colorTextSecondary),),
                  ),
                  SizedBox(height: 8,),
                  Center(
                    child: Countdown(
                      duration: _diff,
                      builder: (BuildContext context, Duration d) {
                        return Text('${d.inDays} วัน : ${d.inHours} : ${d.inMinutes} : ${d.inSeconds % 60}', style: Styles.bold.copyWith(fontSize: 28),);
                      },
                    ),
                  ),
                  SizedBox(height: 8,),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(-1, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('ราคาประมูลปัจจุบัน', style: Styles.regular.copyWith(color: Styles.colorTextSecondary),),
                            Text('฿ ${_bidPrice.toString().replaceAllMapped(reg, mathFunc)}', style: Styles.regular.copyWith(color: Styles.colorTextSecondary))
                          ],
                        ),
                        SizedBox(height: 8,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Styles.colorTextSecondary, width: 1)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('฿', style: Styles.bold.copyWith(color: Styles.colorTextSecondary),),
                              Expanded(
                                  child: Text('${(_bidPrice + _bid).toString().replaceAllMapped(reg, mathFunc)}', style: Styles.bold.copyWith(fontSize: 18, color: Styles.colorTextSecondary), textAlign: TextAlign.right,)
                              ),
                              SizedBox(width: 8,),
                              Container(
                                width: 1,
                                height: 30,
                                color: Styles.colorTextSecondary,
                              ),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    _bid = _bid + 100;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.only(left: 4),
                                  width: 70,
                                  child: Row(
                                    children: [
                                      Icon(Icons.add, color: Styles.colorTextSecondary,),
                                      Text('100', style: Styles.bold.copyWith(fontSize: 18, color: Styles.colorTextSecondary),)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 8,),
                        ButtonTheme(
                          minWidth: 200,
                          height: 40,

                          child: ElevatedButton(
                            onPressed: (){
                              addBidding();
                            },
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: Text('เสนอราคา', style: Styles.bold.copyWith(fontSize: 18, color: Colors.white),),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(primary: Styles.colorButtonPrimary),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 32,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: HexColor.fromHex('#F5F7FB'),
              child: Row(
                children: [
                  SizedBox(
                    width: 180,
                    child: Text('ราคา', style: Styles.medium,),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text('ผู้ประมูล', style: Styles.medium,),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_, int index) {
                  return HistoryCard(historyBidding: _list[index]);
                },
                separatorBuilder: (_, __) => Container(width: double.infinity, height: 1, color: HexColor.fromHex('#E5E9ED'), margin: EdgeInsets.symmetric(vertical: 4),),
                itemCount: _list.length
              ),
            )


          ],
        ),
      ),
    );
  }

  Future<bool?> _displayTextInputDialog() async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter Name For Bidding'),
            content: TextField(
              decoration: const InputDecoration(hintText: "Your Name"),
              onChanged: (s) {
                setState(() {
                  _name = s;
                });
              },
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context, false);
                  Navigator.pop(context, false);
                },
              ),
              ElevatedButton(
                child:  Text('OK'),
                onPressed: () {
                  if (_name != null && _name.isNotEmpty) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ],
          );
        });
  }
  
}