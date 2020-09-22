class Customer {
  int id;
  String paket_id;
  String paket_name;
  String type_paket;
  String paket_type;
  String paket_color;
  String paket_theme;
  String id_gambar;
  String paket_gambar;
  int for_many_people;
  double grandtotal;
  String tanggal_acara;
  String jam_acara;
  String nama_users;

  Customer(
      this.id,
      this.paket_id,
      this.paket_name,
      this.type_paket,
      this.paket_type,
      this.paket_color,
      this.paket_theme,
      this.id_gambar,
      this.paket_gambar,
      this.for_many_people,
      this.grandtotal,
      this.tanggal_acara,
      this.jam_acara,
      this.nama_users);

  Customer.map(dynamic obj) {
    this.id = obj["id"];
    this.paket_id = obj["paket_id"];
    this.paket_name = obj["paket_name"];
    this.type_paket = obj["type_paket"];
    this.paket_type = obj["paket_type"];
    this.paket_color = obj["paket_color"];
    this.paket_theme = obj["paket_theme"];
    this.id_gambar = obj["id_gambar"];
    this.paket_gambar = obj["paket_gambar"];
    this.for_many_people = obj["for_many_people"];
    this.grandtotal = obj["grandtotal"];
    this.tanggal_acara = obj["tanggal_acara"];
    this.jam_acara = obj["jam_acara"];
    this.nama_users = obj["nama_users"];
  }

  String get paketId => paket_id;

  String get paketName => paket_name;

  String get typePaket => type_paket;

  String get paketType => paket_type;

  String get paketColor => paket_color;

  String get paketTheme => paket_theme;

  String get idGambar => id_gambar;

  String get paketGambar => paket_gambar;

  int get formanyPeople => for_many_people;

  double get paketGrandtotal => grandtotal;

  String get tanggalAcara => tanggal_acara;

  String get jamAcara => jam_acara;

  String get namaUsers => nama_users;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["paket_id"] = paket_id;
    map["paket_name"] = paket_name;
    map["type_paket"] = type_paket;
    map["paket_type"] = paket_type;
    map["paket_color"] = paket_color;
    map["paket_theme"] = paket_theme;
    map["id_gambar"] = id_gambar;
    map["paket_gambar"] = paket_gambar;
    map["for_many_people"] = for_many_people;
    map["grandtotal"] = grandtotal;
    map["tanggal_acara"] = tanggal_acara;
    map["jam_acara"] = jam_acara;
    map["nama_users"] = nama_users;
    return map;
  }

  void setCartId(int id) {
    this.id = id;
  }
}
