import 'package:injectable/injectable.dart';
import 'package:flutter_base_project/core/foundation/resource.dart';
import 'package:flutter_base_project/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_base_project/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
class GetMeUseCase {
  GetMeUseCase(this._authRepository);

  final AuthRepository _authRepository;

  Future<Resource<UserEntity>> call() => _authRepository.fetchUserData();
}
