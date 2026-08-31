import 'package:anxolotl_app/src/data/model/user/user_profile.dart';
import 'package:anxolotl_app/src/data/services/authentication/iauthentication_provider.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthentication extends IAuthenticationProvider {
  late final GoogleSignIn _googleSignIn;
  @override
  late AuthProfile authProfile;

  @override
  AuthenticationProviderName authenticationProviderName =
      AuthenticationProviderName.GOOGLE;

  @override
  void init() {
    _googleSignIn = GoogleSignIn();
  }

  @override
  Future<bool> login() async {
    GoogleSignInAccount? user = await _googleSignIn.signIn();
    if (user == null) return false;
    setStatus(AuthenticationStatus.LOGGED_IN);
    authProfile = AuthProfile(
      authenticationProviderName: AuthenticationProviderName.GOOGLE,
      email: user.email,
      id: user.id,
      fullName: user.displayName ?? "",
    );
    return true;
  }

  @override
  Future<bool> logout() async {
    await _googleSignIn.signOut();
    setStatus(AuthenticationStatus.NO_USER);
    return true;
  }
}

class Auth0Authentication extends IAuthenticationProvider {
  late final Auth0 auth0;

  late final WebAuthentication webAuthentication;
  @override
  late AuthProfile authProfile;

  @override
  AuthenticationProviderName authenticationProviderName =
      AuthenticationProviderName.GOOGLE;

  @override
  void init() {
    auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
    webAuthentication =
        auth0.webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME']);
  }

  @override
  Future<bool> login() async {
    late Credentials userCredentials;
    //await logout();
    if (await auth0.credentialsManager.hasValidCredentials()) {
      userCredentials =
          await auth0.credentialsManager.credentials().asStream().first;
    } else {
      userCredentials = await webAuthentication.login();
      if (userCredentials.user.email == null) return false;
    }
    authProfile = AuthProfile(
      authenticationProviderName: AuthenticationProviderName.AUTH0,
      email: userCredentials.user.email!,
      id: userCredentials.user.sub,
      fullName: userCredentials.user.name ?? "",
    );
    setStatus(AuthenticationStatus.LOGGED_IN);
    return true;
  }

  @override
  Future<bool> logout() async {
    await auth0.credentialsManager.clearCredentials();
    webAuthentication.logout(returnTo: dotenv.env['AUTH0_RETURN_URL']);
    setStatus(AuthenticationStatus.NO_USER);
    return true;
  }
}
