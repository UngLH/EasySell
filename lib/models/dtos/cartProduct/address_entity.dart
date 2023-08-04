class Address {
  String? street;
  String? city;
  String? state;

  Address({this.street, this.city, this.state});

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'state': state,
    };
  }
}
