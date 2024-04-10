// import 'package:path/path.dart';
// import 'package:sqlite3/sqlite3.dart';

// class DataBaseHelper{
//   static Future<Database> _openDatabase()async{
//     final databasePath = await getDatabasePath();
//     final path =  join(databasePath, 'user_profile.db');
//     return openDatabase(path, version:1, onCreate: _createDatabase);
//   }
// }

// static Future<void> _createDatabase(Database db, int version) async {
//   await db.execute(
//     '''
//     CREATE TABLE IF NOT EXIST users_profile(

//     )
//   '''
//   );
// }