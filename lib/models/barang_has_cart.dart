class Barang_has_Cart {
  int id;
  String paket_name;
  String paket_type;
  String paket_color;
  String paket_theme;
  String paket_gambar;
  double grandtotal;
  String paket_id;
  int for_many_people;

  String good_name;
  String good_id;
  int good_jumlah;
  double good_harga;
  int Cart_id;
  String paket_ID;

  Barang_has_Cart(
    this.good_name,
    this.good_id,
    this.good_jumlah,
    this.good_harga,
    this.Cart_id,
    this.paket_ID,
    this.paket_id,
    this.paket_name,
    this.paket_type,
    this.paket_color,
    this.paket_theme,
    this.paket_gambar,
    this.for_many_people,
    this.grandtotal,
  );

  Barang_has_Cart.map(dynamic obj) {
    this.good_name = obj["good_name"];
    this.good_id = obj["good_id"];
    this.good_jumlah = obj["good_jumlah"];
    this.good_harga = obj["good_harga"];
    this.Cart_id = obj["Cart_id"];
    this.paket_ID = obj["paket_id"];
    this.paket_id = obj["paket_id"];
    this.paket_name = obj["paket_name"];
    this.paket_type = obj["paket_type"];
    this.paket_color = obj["paket_color"];
    this.paket_theme = obj["paket_theme"];
    this.paket_gambar = obj["paket_gambar"];
    this.for_many_people = obj["for_many_people"];
    this.grandtotal = obj["grandtotal"];
  }

  String get goodName => good_name;

  String get goodId => good_id;

  int get goodJumlah => good_jumlah;

  double get goodHarga => good_harga;

  int get cartId => Cart_id;

  String get paketIds => paket_ID;

  String get paketId => paket_id;

  String get paketName => paket_name;

  String get paketType => paket_type;

  String get paketColor => paket_color;

  String get paketTheme => paket_theme;

  String get paketGambar => paket_gambar;

  int get formanyPeople => for_many_people;

  double get paketGrandtotal => grandtotal;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["good_name"] = good_name;
    map["good_id"] = good_id;
    map["good_jumlah"] = good_jumlah;
    map["good_harga"] = good_harga;
    map["Cart_id"] = Cart_id;
    map['paket_id'] = paket_ID;
    map["paket_id"] = paket_id;
    map["paket_name"] = paket_name;
    map["paket_type"] = paket_type;
    map["paket_color"] = paket_color;
    map["paket_theme"] = paket_theme;
    map["paket_gambar"] = paket_gambar;
    map["for_many_people"] = for_many_people;
    map["grandtotal"] = grandtotal;
    return map;
  }

  void setCartId(int id) {
    this.id = id;
  }
}
