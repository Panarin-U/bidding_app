import 'package:bidding_app/bidding_page.dart';
import 'package:bidding_app/color_utils.dart';
import 'package:bidding_app/product_card.dart';
import 'package:bidding_app/product_model.dart';
import 'package:bidding_app/styles.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Bidding App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<Product> _product = [];

  Future getProduct() async {
    Dio dio = new Dio();
    Response rs = await dio.get('http://localhost:8999/');
    setState(() {
      _product = List<Product>.from(rs.data['data'].map((d) => Product.fromMap(d)));
    });
  }

  @override
  void initState() {
    getProduct();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: Styles.regular.copyWith(fontSize: 24)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32,),
            Center(
              child: Text('สินค้าประมูล ราคาตามใจคุณ', style: Styles.bold.copyWith(fontSize: 24),),
            ),
            SizedBox(height: 16,),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _product.length,
                itemBuilder: (_, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (_) => BiddingPage(product: _product[index])));
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ProductCard(
                        product: _product[index],
                      ),
                    ),
                  );
                }
            )

          ],
        ),
      ),
    );
  }
}


