class CheckOutData {
  String brand, description, selectedSize, selectedColor, category;
  List imgUrl, color, size;
  int quantity = 0;
  int id;
  num newPrice, oldPrice;

  CheckOutData(
      {this.category,
      this.brand,
      this.newPrice,
      this.color,
      this.size,
      this.imgUrl,
//      this.quantity,
      this.id,
      this.description,
      this.oldPrice});

  factory CheckOutData.fromJson(Map<String, dynamic> json) {
    return CheckOutData(
      brand: json['brand'],
      category: json['category'],
      newPrice: json['newPrice'],
      color: json['color'],
      size: json['size'],
      imgUrl: json['imgUrl'],
//      quantity: json['quantity'],
      id: json['id'],
      description: json['description'],
      oldPrice: json['oldPrice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'category': category,
      'newPrice': newPrice,
      'color': color,
      'size': size,
      'imgUrl': imgUrl,
//      'quantity': quantity,
      'description': description,
      'oldPrice': oldPrice,
    };
  }
}

//class CheckOutData {
//  String brand, type, description, selectedSize, selectedColor, category;
//  List imgUrl, color, size;
//  int quantity = 0;
//  int id;
//  num newPrice, oldPrice;
//
//  CheckOutData(
//      {this.category,
//      this.brand,
//      this.type,
//      this.newPrice,
//      this.color,
//      this.size,
//      this.imgUrl,
////      this.quantity,
//      this.id,
//      this.description,
//      this.oldPrice});
//
//  factory CheckOutData.fromJson(Map<String, dynamic> json) {
//    return CheckOutData(
//      brand: json['brand'],
//      type: json['type'],
//      category: json['category'],
//      newPrice: json['newPrice'],
//      color: json['color'],
//      size: json['size'],
//      imgUrl: json['imgUrl'],
////      quantity: json['quantity'],
//      id: json['id'],
//      description: json['description'],
//      oldPrice: json['oldPrice'],
//    );
//  }
//
//  Map<String, dynamic> toMap() {
//    return {
//      'id': id,
//      'brand': brand,
//      'type': type,
//      'category': category,
//      'newPrice': newPrice,
//      'color': color,
//      'size': size,
//      'imgUrl': imgUrl,
////      'quantity': quantity,
//      'description': description,
//      'oldPrice': oldPrice,
//    };
//  }
//}
