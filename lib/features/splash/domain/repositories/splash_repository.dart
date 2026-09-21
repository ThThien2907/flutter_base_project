import 'package:flutter_base_project/core/foundation/resource.dart';

abstract class SplashRepository {
  Future<Resource<bool>> checkCurrentSession();
}
