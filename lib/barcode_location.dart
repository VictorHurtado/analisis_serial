class BarcodeLocation {
  String type;
  String barcode;
  Map<String, dynamic> location;

  BarcodeLocation(this.barcode, this.location, this.type);

  Map<String, dynamic> toMap() {
    return {"barcode": barcode, "location": location, "type": type};
  }
}
