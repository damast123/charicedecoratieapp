class Jenis {
  String nama;
  String id;
  String gambar;

  Jenis({this.nama, this.id, this.gambar});

  @override
  String toString() {
    return 'Sample{name: $nama, id: $id gambar: $gambar}';
  }

  factory Jenis.fromJson(Map<String, dynamic> json) {
    return Jenis(
        nama: json["name"], id: json["age"], gambar: json['gambar_jenis']);
  }
}
