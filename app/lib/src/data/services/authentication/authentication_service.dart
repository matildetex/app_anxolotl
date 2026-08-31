import 'package:anxolotl_app/src/data/data_acces/repositories/secure_storage_repository.dart';
import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/authentication/iauthentication_provider.dart';

class AuthenticationService {
  late IAuthenticationProvider _authenticationProvider;
  final SecureStorageRepository _secureStorageRepository;
  AuthProfile? _authProfile;

  AuthenticationService(this._secureStorageRepository);

  void setAuthenticationProvider(
      AuthenticationProviderName authenticationProviderName) {
    _authenticationProvider = authenticationProviderName.authenticationProvider;
  }

  void init() {
    //TODO ir buscar ao storage a info do authProvider actual
    _authenticationProvider.init();
  }

  Future<bool> login() async {
    bool userEntered = await _authenticationProvider.login();
    if (userEntered) {
      _authProfile = _authenticationProvider.getUserAuthInfo();
      await _secureStorageRepository
          .storeSerializable<AuthProfile>(_authProfile!);
    }

    return userEntered;
  }

  Future<bool> logout() async {
    bool userLeft = await _authenticationProvider.logout();
    if (userLeft) {
      _authProfile = null;
      await _secureStorageRepository.removeSerialized<AuthProfile>();
    }
    return userLeft;
  }

  bool isUserLoggedIn() =>
      _authProfile != null && _authenticationProvider.isUserLoggedIn();

  Future<bool> loadProfile() async {
    AuthProfile? savedAuthProfile =
        await _secureStorageRepository.readSerialized<AuthProfile>();
    bool userWasLoaded = savedAuthProfile != null;
    if (userWasLoaded) {
      _authProfile = savedAuthProfile;
      print("User ${_authProfile!.fullName}");
    }
    return userWasLoaded;
  }

  AuthProfile? getUserProfile() => _authProfile;
}
