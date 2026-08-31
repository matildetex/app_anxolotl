import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/authentication/authentication_providers.dart';

enum AuthenticationStatus {
  NO_USER,
  LOGGED_IN
} //TODO Guardar isto com os dados no outro lado

enum AuthenticationProviderName {
  GOOGLE,
  AUTH0
} //TODO Guardar isto com os dados no outro lado

extension Instance on AuthenticationProviderName {
  IAuthenticationProvider get authenticationProvider {
    switch (this) {
      case AuthenticationProviderName.GOOGLE:
        return GoogleAuthentication();
      case AuthenticationProviderName.AUTH0:
        return Auth0Authentication();
      default:
        throw UnimplementedError();
    }
  }
}

abstract class IAuthenticationProvider {
  abstract AuthenticationProviderName authenticationProviderName;
  AuthenticationStatus _status = AuthenticationStatus.NO_USER;
  abstract AuthProfile authProfile;

  void init();

  Future<bool> login();
  Future<bool> logout();

  bool isUserLoggedIn() => _status == AuthenticationStatus.LOGGED_IN;

  AuthProfile getUserAuthInfo() => authProfile;

  void setStatus(AuthenticationStatus status) => _status = status;
}
