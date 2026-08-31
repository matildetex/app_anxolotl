import 'package:anxolotl_app/globals/app_routes.dart';
import 'package:anxolotl_app/globals/assets_path.dart';
import 'package:anxolotl_app/src/data/services/authentication/iauthentication_provider.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/view/auth_page/log_in_button_custom.dart';
import 'package:anxolotl_app/src/ui/viewmodels/authentication_vm.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/constants.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    TextStyle? h2Style = Theme.of(context).textTheme.displayMedium;
    TextStyle? body2Style = Theme.of(context).textTheme.bodyMedium;
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);

    AuthenticationViewModel authenticationVM =
        Provider.of<AuthenticationViewModel>(context);

    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Spacer(
            flex: 5,
          ),
          SizedBox(
              width: phoneScreenWidth / 1.9,
              child: const Image(
                alignment: Alignment.center,
                width: 200,
                image: AssetImage(
                    "${AssetsPath.BRANDING_ASSETS}anxolotl_logo_rgb.png"),
                fit: BoxFit.fitWidth,
              )),
          SizedBox(
            height: 20,
            width: phoneScreenWidth,
          ),
          SizedBox(
            width: phoneScreenWidth / 1.5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationsUtil.l10n(context).openingGreeting,
                  style: h2Style,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(LocalizationsUtil.l10n(context).loginWarning,
                    style: body2Style),
              ],
            ),
          ),
          const Spacer(
            flex: 2,
          ),
          SignInButtonCustom(
              buttonType: ButtonType.mail,
              buttonText:
                  LocalizationsUtil.l10n(context).logInMessage("E-mail"),
              buttonAction: () async => await logInResponse(
                  authenticationVM, AuthenticationProviderName.AUTH0)),
          const SizedBox(
            height: 10,
          ),
          SignInButtonCustom(
              buttonType: ButtonType.google,
              buttonText:
                  LocalizationsUtil.l10n(context).logInMessage("Google"),
              buttonAction: () async => await logInResponse(
                  authenticationVM, AuthenticationProviderName.GOOGLE)),
          const Spacer(
            flex: 2,
          ),
          Text(LocalizationsUtil.l10n(context).termsOfServiceMessage,
              style: bodySmallStyle),
          const Spacer(
            flex: 4,
          ),
        ],
      )),
    );
  }

  Future logInResponse(AuthenticationViewModel authenticationVM,
      AuthenticationProviderName authenticationProviderName) async {
    authenticationVM.changeAuthenticationProvider(authenticationProviderName);
    if (!(await authenticationVM.logIn())) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocalizationsUtil.l10n(context).failedLogIn)));
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.LANDING_PAGE, (Route<dynamic> route) => false);
    }
  }
}
