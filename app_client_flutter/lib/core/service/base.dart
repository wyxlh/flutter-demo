
import '../io/file/file.dart';

class YZCBase {
  final String _filePath ;

  YZCBase(this._filePath);

  void fromJson(Map<String, dynamic> d) {}
  Map<String, dynamic> toJson() {}

  void load() => fromJson( YZCFile.loadJSON(_filePath));
  void save() => YZCFile.saveJSON(_filePath, toJson());
  void clear() => YZCFile.deleteFile(_filePath);
}
