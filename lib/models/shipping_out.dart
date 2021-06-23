class ShippingOut {
  String phoneNumber, place, address;
  List location;
  int id = 0;

  ShippingOut({this.phoneNumber, this.place, this.address, this.location});

  factory ShippingOut.fromJson(Map<String, dynamic> json) {
    return ShippingOut(
      phoneNumber: json['phoneNumber'],
      place: json['place'],
      location: json['location'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'place': place,
      'location': location,
      'address': address,
    };
  }
}
