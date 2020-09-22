class koneksi {
  static String connect(String path) {
    return 'http://192.168.1.5/TA/' + path;
  }

  static String getImagePaket(String path) {
    return 'http://192.168.1.5/TA/gambar_paket/' + path;
  }

  static String getImageJenis(String path) {
    return 'http://192.168.1.5/TA/gambar_jenis/' + path;
  }

  static String getImageBukti(String path) {
    return 'http://192.168.1.5/TA/gambar_bukti/' + path;
  }
}
