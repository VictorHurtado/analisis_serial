class BarcodeLocation {
  double type;
  String barcode;
  Map<String, dynamic> location;

  BarcodeLocation(this.barcode, this.location, this.type);

  Map<String, dynamic> toJson() {
    return {"barcode": barcode, "location": location, "type": type};
  }
}
