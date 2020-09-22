import 'dart:async';
import 'dart:io';

import 'package:charicedecoratieapp/models/barang.dart';
import 'package:charicedecoratieapp/models/cart.dart';
import 'package:charicedecoratieapp/models/scart.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'DBHRSFIXCharicedes.db';

    // Open/create the database at a given path
    var todosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE Barang(good_name TEXT, good_id TEXT, good_jumlah INTEGER,good_harga DOUBLE, cart_id INTEGER, paket_id TEXT, username TEXT, tanggal TEXT)");
    await db.execute(
        "CREATE TABLE Cart(id INTEGER PRIMARY KEY, paket_id TEXT,paket_name TEXT, type_paket TEXT,paket_type TEXT, paket_color TEXT,paket_theme TEXT, id_gambar TEXT,paket_gambar TEXT, grandtotal DOUBLE, for_many_people INTEGER, tanggal_acara TEXT, jam_acara TEXT, nama_users TEXT)");
  }

  Future<int> saveCustomer(Cart cart) async {
    Database db = await this.database;
    int res = await db.insert("Cart", cart.toMap());
    return res;
  }

  Future<List<Customer>> getCustomer(String username) async {
    Database db = await this.database;
    List<Map> list = await db
        .rawQuery('SELECT * FROM Cart WHERE nama_users = ?', [username]);
    List<Customer> customer = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Customer(
          list[i]["id"],
          list[i]["paket_id"],
          list[i]["paket_name"],
          list[i]["type_paket"],
          list[i]["paket_type"],
          list[i]["paket_color"],
          list[i]["paket_theme"],
          list[i]["id_gambar"],
          list[i]["paket_gambar"],
          list[i]["for_many_people"],
          list[i]["grandtotal"],
          list[i]["tanggal_acara"],
          list[i]["jam_acara"],
          list[i]["nama_users"]);
      cart.setCartId(list[i]["id"]);
      customer.add(cart);
    }
    return customer;
  }

  Future<List<Customer>> getCartLength(String username) async {
    Database db = await this.database;
    List<Map> list = await db.rawQuery(
        'SELECT * FROM Cart WHERE nama_users = ? ORDER BY id DESC LIMIT 1',
        [username]);
    List<Customer> customer = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Customer(
          list[i]["id"],
          list[i]["paket_id"],
          list[i]["paket_name"],
          list[i]["type_paket"],
          list[i]["paket_type"],
          list[i]["paket_color"],
          list[i]["paket_theme"],
          list[i]["id_gambar"],
          list[i]["paket_gambar"],
          list[i]["for_many_people"],
          list[i]["grandtotal"],
          list[i]["tanggal_acara"],
          list[i]["jam_acara"],
          list[i]["nama_users"]);
      cart.setCartId(list[i]["id"]);
      customer.add(cart);
    }
    return customer;
  }

  Future<List<Customer>> getCartByDate(String tanggal) async {
    Database db = await this.database;
    List<Map> list = await db
        .rawQuery('SELECT * FROM Cart WHERE tanggal_acara = ?', [tanggal]);
    List<Customer> customer = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Customer(
          list[i]["id"],
          list[i]["paket_id"],
          list[i]["paket_name"],
          list[i]["type_paket"],
          list[i]["paket_type"],
          list[i]["paket_color"],
          list[i]["paket_theme"],
          list[i]["id_gambar"],
          list[i]["paket_gambar"],
          list[i]["for_many_people"],
          list[i]["grandtotal"],
          list[i]["tanggal_acara"],
          list[i]["jam_acara"],
          list[i]["nama_users"]);
      cart.setCartId(list[i]["id"]);
      customer.add(cart);
    }
    print(customer.length);
    return customer;
  }

  Future<List<Customer>> getCustomerInBackdrop(String username) async {
    Database db = await this.database;
    List<Map> list = await db.rawQuery(
        'SELECT * FROM Cart WHERE paket_id IN(10,11,12,13,14,15,16) AND nama_users = ?',
        [username]);
    List<Customer> customer = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Customer(
          list[i]["id"],
          list[i]["paket_id"],
          list[i]["paket_name"],
          list[i]["type_paket"],
          list[i]["paket_type"],
          list[i]["paket_color"],
          list[i]["paket_theme"],
          list[i]["id_gambar"],
          list[i]["paket_gambar"],
          list[i]["for_many_people"],
          list[i]["grandtotal"],
          list[i]["tanggal_acara"],
          list[i]["jam_acara"],
          list[i]["nama_users"]);
      cart.setCartId(list[i]["id"]);
      customer.add(cart);
    }
    print(customer.length);
    return customer;
  }

  Future<int> getCustomerLength(String username) async {
    Database db = await this.database;
    List<Map> list = await db.rawQuery('SELECT * FROM Cart WHERE');
    List<Customer> customer = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Customer(
          list[i]["id"],
          list[i]["paket_id"],
          list[i]["paket_name"],
          list[i]["type_paket"],
          list[i]["paket_type"],
          list[i]["paket_color"],
          list[i]["paket_theme"],
          list[i]["id_gambar"],
          list[i]["paket_gambar"],
          list[i]["for_many_people"],
          list[i]["grandtotal"],
          list[i]["tanggal_acara"],
          list[i]["jam_acara"],
          list[i]["nama_users"]);
      cart.setCartId(list[i]["id"]);
      customer.add(cart);
    }
    print(customer.length);
    return customer.length;
  }

  Future<List<Customer>> getCustomerCart(String id, String username) async {
    Database db = await this.database;
    List<Map> list = await db.rawQuery(
        'SELECT * FROM Cart WHERE paket_id= ? AND nama_users = ?',
        [id, username]);
    List<Customer> customer = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Customer(
          list[i]["id"],
          list[i]["paket_id"],
          list[i]["paket_name"],
          list[i]["type_paket"],
          list[i]["paket_type"],
          list[i]["paket_color"],
          list[i]["paket_theme"],
          list[i]["id_gambar"],
          list[i]["paket_gambar"],
          list[i]["for_many_people"],
          list[i]["grandtotal"],
          list[i]["tanggal_acara"],
          list[i]["jam_acara"],
          list[i]["nama_users"]);
      cart.setCartId(list[i]["id"]);
      customer.add(cart);
    }
    print(customer.length);
    return customer;
  }

  Future<List<Customer>> getCustomerCarts() async {
    Database db = await this.database;
    List<Map> list = await db.rawQuery('SELECT * FROM Cart');
    List<Customer> customer = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Customer(
          list[i]["id"],
          list[i]["paket_id"],
          list[i]["paket_name"],
          list[i]["type_paket"],
          list[i]["paket_type"],
          list[i]["paket_color"],
          list[i]["paket_theme"],
          list[i]["id_gambar"],
          list[i]["paket_gambar"],
          list[i]["for_many_people"],
          list[i]["grandtotal"],
          list[i]["tanggal_acara"],
          list[i]["jam_acara"],
          list[i]["nama_users"]);
      cart.setCartId(list[i]["id"]);
      customer.add(cart);
    }
    print(customer.length);
    return customer;
  }

  Future<List<Barang>> getBarangById(String id, String username) async {
    Database db = await this.database;
    List<Map> list =
        await db.rawQuery('SELECT * FROM Barang WHERE paket_id=' + id);
    List<Barang> barang = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Barang(
          list[i]["good_name"],
          list[i]["good_id"],
          list[i]["good_jumlah"],
          list[i]["good_harga"],
          list[i]["Cart_id"],
          list[i]['paket_id'],
          list[i]["username"],
          list[i]["tanggal"]);
      barang.add(cart);
    }
    print(barang.length);
    return barang;
  }

  Future<List<Barang>> getBarangs() async {
    Database db = await this.database;
    List<Map> list = await db.rawQuery('SELECT * FROM Barang');
    List<Barang> barang = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Barang(
          list[i]["good_name"],
          list[i]["good_id"],
          list[i]["good_jumlah"],
          list[i]["good_harga"],
          list[i]["Cart_id"],
          list[i]['paket_id'],
          list[i]["username"],
          list[i]["tanggal"]);
      barang.add(cart);
    }
    print(barang.length);
    return barang;
  }

  Future<int> deleteCarts(String customer) async {
    Database db = await this.database;

    int res = await db.rawDelete('DELETE FROM Cart WHERE id = ?', [customer]);
    return res;
  }

  Future<int> deleteCart() async {
    Database db = await this.database;

    int res = await db.rawDelete('DELETE FROM Cart');
    return res;
  }

  Future<bool> update(Customer customer) async {
    Database db = await this.database;
    int res = await db.update("Cart", customer.toMap(),
        where: "id = ?", whereArgs: <int>[customer.id]);
    return res > 0 ? true : false;
  }

  Future<int> saveBarang(Barang barang) async {
    Database db = await this.database;
    int res = await db.insert("Barang", barang.toMap());
    return res;
  }

  Future<int> updateBarang(Barang barang, int id) async {
    Database db = await this.database;
    List<Map> listbarang = await db
        .rawQuery('SELECT * FROM Barang b WHERE cart_id=' + id.toString());
    int res = await db.rawUpdate(
        'UPDATE Barang SET good_jumlah = ${barang.good_jumlah} WHERE good_id = ${barang.good_id}');
    return res;
  }

  Future<List<Barang>> getBarang(String username) async {
    Database db = await this.database;
    List<Map> list = await db
        .rawQuery('SELECT * FROM Barang WHERE username = ?', [username]);
    List<Barang> barang = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Barang(
          list[i]["good_name"],
          list[i]["good_id"],
          list[i]["good_jumlah"],
          list[i]["good_harga"],
          list[i]["cart_id"],
          list[i]['paket_id'],
          list[i]["username"],
          list[i]["tanggal"]);
      barang.add(cart);
    }
    print(barang.length);
    return barang;
  }

  Future<List<Barang>> getBarangByTanggal(
      String tanggal, String username) async {
    Database db = await this.database;
    List<Map> list = await db.rawQuery(
        'SELECT * FROM Barang WHERE tanggal = ? AND username = ?',
        [tanggal, username]);
    List<Barang> barang = new List();
    for (int i = 0; i < list.length; i++) {
      var cart = new Barang(
          list[i]["good_name"],
          list[i]["good_id"],
          list[i]["good_jumlah"],
          list[i]["good_harga"],
          list[i]["cart_id"],
          list[i]['paket_id'],
          list[i]["username"],
          list[i]["tanggal"]);
      barang.add(cart);
    }
    print(barang.length);
    return barang;
  }

  Future<int> deletebarangs(Barang barang) async {
    Database db = await this.database;

    int res = await db
        .rawDelete('DELETE FROM Barang WHERE good_id = ?', [barang.good_id]);
    return res;
  }

  Future<int> deletecartbarangs(String id) async {
    Database db = await this.database;
    List<Map> listbarang =
        await db.rawQuery('SELECT * FROM Barang b WHERE cart_id=' + id);
    print("ini isi list barang: " + listbarang.toString());
    for (var x = 0; x < listbarang.length; x++) {
      int res = await db.rawDelete(
          'DELETE FROM Barang WHERE cart_id = ?', [listbarang[x]["cart_id"]]);
      return res;
    }
  }

  Future<int> deleteBarang() async {
    Database db = await this.database;

    int res = await db.rawDelete('DELETE FROM Barang');
    return res;
  }

  Future<int> deleteBarangByIdPaket(String id) async {
    Database db = await this.database;

    int res = await db.rawDelete('DELETE FROM Barang WHERE paket_id=' + id);
    return res;
  }
}
