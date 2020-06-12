
import '../base.dart';

class YZCGuide extends YZCBase {
  bool isGuided = false;

  YZCGuide(): super('guide');

  @override
  void fromJson(Map<String, dynamic> d) {
    isGuided = d["guided"] ?? false;
  }

  @override
  Map<String, dynamic> toJson() => <String, dynamic> {
    'guided': isGuided,
  };
}
