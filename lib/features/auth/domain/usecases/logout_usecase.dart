import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class LogoutUseCase {
  LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Resource<dynamic>> call() => _authRepository.logout();
}
