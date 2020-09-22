import 'package:flutter/material.dart';
import 'package:flutter_launch/flutter_launch.dart';

void main(List<String> args) {
  runApp(MyFAQ());
}

class MyFAQ extends StatelessWidget {
  const MyFAQ({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FAQ(),
    );
  }
}

class FAQ extends StatefulWidget {
  FAQ({Key key}) : super(key: key);

  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  List<DescFAQ> descFAQ = [];
  @override
  void initState() {
    super.initState();
    descFAQ.addAll([
      DescFAQ(
          "Durasi dekorasi",
          "Q:Kira-kira dekorasi bisa dipakai berapa lama?",
          "A:Maksimal 3 jam. Kalau malam maksimal jam 10 malam"),
      DescFAQ("Harga tiap paket", "Q:Bagaimana perbedaan harga tiap paket?",
          "A:Berbeda dari jenis properti yang dipakai, dari sederhana hingga mewah."),
      DescFAQ("Request warna", "Q:Apakah kita bisa request warna atau tidak?",
          "A:Bisa request warna"),
      DescFAQ("Jumlah orang", "Q:Minimal berapa orang untuk dekor grup?",
          "A:Minimal 3 orang."),
      DescFAQ(
          "Rekomendasi tempat acara",
          "Q:Apakah bisa melakukan rekomendasi tempat acara?",
          "A:\n1. Socialite\n 2.Petrichor\n 3.De Mandailing\n 4.My Story\n 5.Botanika\n 6.Noach\n 7.Boncafe"),
      DescFAQ(
          "Cara melakukan booking",
          "Q:Bagaimana cara melakukan booking di aplikasi ini?",
          "A:\n1. Pada halaman awal, silahkan pilih paket dan klik tombol pesan. Disini kalian akan mengisi data dan setelah selesai, maka akan dimasukkan ke dalam keranjang\n2. Pada bagian pemesanan tab 1, kalian dapat melihat keranjang kalian dengan tanggal yang sudah kalian pilih. Bila ada kesalahan, maka keranjang dapat dihapus.\n3.Pada bagian pemesanan pada tab 2, silahkan tekan tombol booking sekarang dan memilih keranjang yang akan langsung di booking.\n4.Kalian dapat melihat data keranjang. Setelah yakin maka dapat lanjut ke step selanjutnya yaitu isi data. Setelah isi data, akan muncul konfirmasi data dari yang sudah diisi serta checkbox format order agar memberi info untuk print format order.\n5. Setelah booking, bagian pemesanan tab 2 akan muncul no booking serta data nya yang sudah terbooking. Silahkan tekan kotak info tersebut untuk melanjutkan ke pembayaran.\n6. Disini akan memunculkan data booking dan no rekening atau no telepon (OVO atau GOPAY). Disini kalian akan mengupload bukti transfer ke admin.\n7. Setelah kalian kirim bukti transfer, admin akan mengecek bukti tersebut apakah benar atau tidak. Bila tidak benar maka admin akan mengkontak anda. Bila bukti benar maka booking mu sudah diterima dan selesai."),
      DescFAQ(
          "Ganti jadwal acara",
          "Q:Bila saya salah tanggal acara, apakah saya bisa mengganti jadwal acara?",
          "A:Masih bisa. Silahkan masuk ke dalam bagian pemesanan pada tab 3 daftar pesanan. Lalu pilih booking yang akan di ganti tanggal nya dan silahkan tekan tombol re-schedule. Lalu ganti tanggal serta jam yang di inginkan. Tanggal tidak bisa diganti di saat itu juga atau hari besok nya."),
      DescFAQ(
          "Pesan lebih dari satu paket",
          "Q:Apakah bisa melakukan pemesanan lebih dari satu paket?",
          "A:Bisa, namun tergantung dari stok barang. Serta setiap paket ada yang bisa digabungkan, ada yang tidak bisa. Seperti table decor bisa digabung dengan backdrop decor, namun tidak bisa digabung dengan room decor. Saat ini room decor masih tidak bisa digabung dengan jenis dekorasi yang lain.")
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("FAQ"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Drawer(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: descFAQ.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Column(children: <Widget>[
                              ExpansionTile(
                                  title: Text(
                                    descFAQ[index].title,
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: TextFormField(
                                        initialValue: descFAQ[index].pertanyaan,
                                        readOnly: true,
                                        maxLines: null,
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.red[500]),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: TextFormField(
                                        initialValue: descFAQ[index].jawaban,
                                        readOnly: true,
                                        maxLines: null,
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            color: Colors.green[200]),
                                      ),
                                    ),
                                  ]),
                            ]),
                          );
                        }),
                  )),
              RaisedButton(
                elevation: 0.0,
                color: Colors.blue,
                child: Text(
                  'Hubungi kami',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  whatsAppOpen();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void whatsAppOpen() async {
    await FlutterLaunch.launchWathsApp(phone: "+6281357999781", message: "");
  }
}

class DescFAQ {
  final String title;
  final String pertanyaan;
  final String jawaban;

  DescFAQ(this.title, this.pertanyaan, this.jawaban);
}
