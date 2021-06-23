import 'package:flutter/widgets.dart';
import 'package:mezgebestore/models/shipping_out.dart';

class ShippingBloc extends ChangeNotifier {
  List<ShippingOut> addressInShipping = [];
  Map<int, ShippingOut> addressInShippingMap;

  void addLocation(ShippingOut shipping) {
    //check if map is empty & Initalize with the product
//    addressInShippingMap == null
//        // ignore: unnecessary_statements
//        ? {
//      addressInShippingMap = {shipping.id: shipping},
//            shipping.quantity++,
//          }
//        : productsInCartMap
//                .containsKey(shipping.id) //check if product exists in cart
//            ? productsInCartMap[shipping.id].quantity++
//
//            // ignore: unnecessary_statements
//            : {
//    shipping.id = 0;
    addressInShippingMap.addAll({shipping.hashCode: shipping});
//              };
    notifyListeners();

    addressInShipping = List.from(addressInShippingMap.values);
  }
}
