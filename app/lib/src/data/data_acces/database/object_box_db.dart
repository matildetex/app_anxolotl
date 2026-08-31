import 'package:anxolotl_app/src/data/data_acces/database/generated/objectbox.g.dart';

class ObjectBoxDb {
  /// The Store of this app.
  /// Update
  /// flutter pub run build_runner build
  static Store? _database;

  Future<Store> init({String path = ""}) async {
    // This is required so ObjectBox can get the application directory
    // to store the database in.
    //WidgetsFlutterBinding.ensureInitialized();
    if (path.isEmpty) _database ??= await openStore();
    _database ??= await openStore(directory: path);
    return _database!;
  }

  Store getDatabase() {
    _database ??= throw ObjectBoxException("Please call init() first");
    return _database!;
  }
}
