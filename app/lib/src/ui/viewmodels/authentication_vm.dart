import 'package:anxolotl_app/src/data/services/authentication/authentication_service.dart';
import 'package:anxolotl_app/src/data/services/authentication/iauthentication_provider.dart';
import 'package:flutter/material.dart';

class AuthenticationViewModel extends ChangeNotifier {
  final AuthenticationService _authenticationService;

  AuthenticationViewModel(this._authenticationService);

  Future<AuthenticationViewModel> init() async {
    return await loadAuthProfile().then((value) => this);
  }

  Future<bool> loadAuthProfile() async {
    bool userWasLoaded = await _authenticationService.loadProfile();
    if (!userWasLoaded) return false;
    changeAuthenticationProvider(
        _authenticationService.getUserProfile()!.authenticationProviderName);
    print("UserID ${_authenticationService.getUserProfile()!.id}");
    return await logIn();
  }

  bool isUserLoggedIn() => _authenticationService.isUserLoggedIn();

  Future<bool> logIn() async {
    return await _authenticationService.login();
  }

  Future<bool> logOut() async {
    return await _authenticationService.logout();
  }

  void changeAuthenticationProvider(
      AuthenticationProviderName authenticationProviderName) {
    _authenticationService
        .setAuthenticationProvider(authenticationProviderName);
    _authenticationService.init();
  }
}
