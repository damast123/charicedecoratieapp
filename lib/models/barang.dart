class Barang {
  String good_name;
  String good_id;

  int good_jumlah;
  double good_harga;
  int Cart_id;
  String paket_ID;
  String username_ID;
  String tanggal;

  Barang(this.good_name, this.good_id, this.good_jumlah, this.good_harga,
      this.Cart_id, this.paket_ID, this.username_ID, this.tanggal);

  Barang.map(dynamic obj) {
    this.good_name = obj["good_name"];
    this.good_id = obj["good_id"];
    this.good_jumlah = obj["good_jumlah"];
    this.good_harga = obj["good_harga"];
    this.Cart_id = obj["cart_id"];
    this.paket_ID = obj["paket_id"];
    this.username_ID = obj["username"];
    this.tanggal = obj["tanggal"];
  }

  String get goodName => good_name;

  String get goodId => good_id;

  int get goodJumlah => good_jumlah;

  double get goodHarga => good_harga;

  int get cartId => Cart_id;

  String get paketId => paket_ID;

  String get usernameId => username_ID;

  String get tanggalL => tanggal;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["good_name"] = good_name;
    map["good_id"] = good_id;
    map["good_jumlah"] = good_jumlah;
    map["good_harga"] = good_harga;
    map["cart_id"] = Cart_id;
    map['paket_id'] = paket_ID;
    map['username'] = username_ID;
    map['tanggal'] = tanggal;
    return map;
  }
}
