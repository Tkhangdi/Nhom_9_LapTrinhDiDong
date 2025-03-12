// ignore: depend_on_referenced_packages
import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';

// Tạo một lớp quản lý cơ sở dữ liệu
class DuLieu {
  static Database? _database;

  // Hàm mở cơ sở dữ liệu SQLite
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB();
      return _database!;
    }
  }

  // Hàm khởi tạo cơ sở dữ liệu
  _initDB() async {
    String path = join(await getDatabasesPath(), 'khachhang.db');
    return await openDatabase(
      path,
      version: 2, // Tăng version lên khi thay đổi cấu trúc cơ sở dữ liệu
      onCreate: (db, version) async {
        // Tạo bảng khi cơ sở dữ liệu chưa tồn tại
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            name TEXT,
            email TEXT UNIQUE ,
            password TEXT,
            gender TEXT,
            birthdate TEXT,
            phone TEXT,   -- Thêm trường số điện thoại
            address TEXT  -- Thêm trường địa chỉ
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Thêm các cột mới khi nâng cấp phiên bản cơ sở dữ liệu
          await db.execute('''
            ALTER TABLE users ADD COLUMN phone TEXT;
          ''');
          await db.execute('''
            ALTER TABLE users ADD COLUMN address TEXT;
          ''');
        }
      },
    );
  }

  // Hàm thêm người dùng
  Future<void> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    await db.insert(
      'users',
      user,
      conflictAlgorithm:
          ConflictAlgorithm.replace, // Nếu có dữ liệu trùng lặp thì thay thế
    );
  }

  // Hàm lấy tất cả người dùng
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('users');
  }

  // Hàm tìm người dùng theo email
  // Method to get user by email
  Future<List<Map<String, dynamic>>> getUsersByEmail(String email) async {
    final db = await _database;
    return await db!.query('users', where: 'email = ?', whereArgs: [email]);
  }
}
