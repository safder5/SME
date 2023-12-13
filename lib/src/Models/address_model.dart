class AddressModel {
  final String? street;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? phone;

  AddressModel(
      {this.street,
      this.phone, // phone number of shipping address
      this.city,
      this.country,
      this.state,
      this.zipCode});
}
