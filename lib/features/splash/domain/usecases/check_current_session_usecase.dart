import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/splash/domain/repositories/splash_repository.dart';

@lazySingleton
class CheckCurrentSessionUseCase {
  CheckCurrentSessionUseCase(this._splashRepository);

  final SplashRepository _splashRepository;

  Future<Resource<bool>> call() => _splashRepository.checkCurrentSession();
}
