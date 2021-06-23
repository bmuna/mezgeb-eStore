import 'package:flutter/widgets.dart';
import 'package:mezgebestore/models/check_out.dart';

class CartBloc extends ChangeNotifier {
  List<CheckOutData> productsInCart = [];
  Map<int, CheckOutData> productsInCartMap;

  int calculateTotalPrice() {
    int totalPrice = 0;
    productsInCart.forEach((element) {
      totalPrice = totalPrice + (element.newPrice * element.quantity);
    });
    return totalPrice;
  }

  void clearCart() {
    productsInCart.clear();
    productsInCartMap.clear();
    notifyListeners();
  }

  void addItemToCart(CheckOutData product) {
    //check if map is empty & Initalize with the product
    productsInCartMap == null
        // ignore: unnecessary_statements
        ? {
            productsInCartMap = {product.id: product},
            product.quantity++,
          }
        : productsInCartMap
                .containsKey(product.id) //check if product exists in cart
            ? productsInCartMap[product.id].quantity++

            // ignore: unnecessary_statements
            : {
                product.quantity = 1,
                productsInCartMap.addAll({product.id: product})
              };
    notifyListeners();

    productsInCart = List.from(productsInCartMap.values);
  }

  void removeItemFromCart(int id) {
    productsInCartMap.remove(id);
    productsInCart = List.from(productsInCartMap.values);
    notifyListeners();
  }

  void decrementItemFromCart(CheckOutData product) {
    product.quantity >= 2
        ? product.quantity--
        : productsInCartMap.remove(product.id);
    productsInCart = List.from(productsInCartMap.values);
    notifyListeners();
  }
}
