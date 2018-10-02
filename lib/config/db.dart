import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DB {
  static final DB _instance = new DB.internal();
  factory DB() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DB.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }
  
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("""
      CREATE TABLE Task(
        id INTEGER PRIMARY KEY,
        name TEXT,
        due Date,
        interval int,
        done boolean
      )
    """);
    print("Created tables");
    // seedTables();
  }
  
  // void seedTables() async {
  //   User admin = new User(
  //     name: 'Rodrigo Temiski Muniz',
  //     email: 'admin@gameware.com',
  //     username: 'admin',
  //     password: '123',
  //   );
  //   Product product = new Product(
  //     name: 'Playstation',
  //     quantity: 5,
  //     code: 'PS1',
  //     category: ProductCategory.console,
  //     user: admin,
  //   );

  //   await saveUser(admin);
  //   await new Future.delayed(new Duration(seconds: 5));
  //   await saveProduct(product);
  // }

  // Future<int> saveUser(User user) async {
  //   var dbClient = await db;
  //   int res = await dbClient.insert("User", user.toMap());
  //   return res;
  // }

  // Future<int> saveProduct(Product product) async {
  //   var dbClient = await db;
  //   int res = await dbClient.insert("Product", product.toMap());
  //   return res;
  // }

  // Future<int> deleteUsers() async {
  //   var dbClient = await db;
  //   int res = await dbClient.delete("User");
  //   return res;
  // }

  // Future<List<Product>> getProducts() async {
  //   var dbClient = await db;
  //   List<Product> products = new List<Product>();
  //   List<Map> productRaw = await dbClient.query("Product");
    
  //   if (productRaw.length > 0) {
  //     productRaw.forEach((product) {
  //       products.add(new Product.map(product));
  //     });
  //   }

  //   return products;
  // }

  // Future<List<Product>> getProductsByUser(int userId) async {
  //   var dbClient = await db;
  //   List<Product> products = new List<Product>();
  //   List<Map> productRaw = await dbClient.query("Product", where: "userId = $userId");
    
  //   if (productRaw.length > 0) {
  //     productRaw.forEach((product) {
  //       products.add(new Product.map(product));
  //     });
  //   }

  //   return products;
  // }

  // Future<User> isLoggedIn(String username, String password) async {
  //   var dbClient = await db;
  //   List<Map> userRaw = await dbClient.rawQuery(
  //     "SELECT * FROM User WHERE username = '$username' AND password = '$password'"
  //   );
    
  //   if (userRaw.length > 0) {
  //     return new User.map(userRaw[0]);
  //   }

  //   return null;
  // }

}