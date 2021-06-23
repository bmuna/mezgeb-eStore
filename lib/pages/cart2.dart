import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mezgebestore/models/check_out.dart';
import 'package:mezgebestore/stores/cart_logic.dart';
import 'package:provider/provider.dart';

class Cart2 extends StatefulWidget {
  final CheckOutData product;
  Cart2({this.product});
  @override
  _Cart2State createState() => _Cart2State();
}

class _Cart2State extends State<Cart2> {
  int _current = 0;
  double height;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.product.imgUrl
        .map((item) => Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: Stack(
                  children: <Widget>[
                    CachedNetworkImage(
                      placeholder: (context, url) => Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Container(
                          child: Icon(Icons.error),
                        ),
                      ),
                      imageUrl: item,
                      fit: BoxFit.cover,
                      height: height,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                ),
              ),
            ))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Carousel with indicator demo')),
      body: Container(
        child: Stack(children: [
          Builder(builder: (context) {
            height = MediaQuery.of(context).size.height;
            final double width = MediaQuery.of(context).size.width;
            return CarouselSlider(
              options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: imageSliders,
            );
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.product.imgUrl.map((item) {
                  int index = widget.product.imgUrl.indexOf(item);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? Colors.white
                            : Color(0xffEF3651)),
                  );
                }).toList(),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
