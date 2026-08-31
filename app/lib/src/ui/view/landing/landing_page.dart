import 'package:anxolotl_app/globals/assets_path.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/view/landing/events_fragment.dart';
import 'package:anxolotl_app/src/ui/view/landing/home_fragment.dart';
import 'package:anxolotl_app/src/ui/view/landing/profile_fragment.dart';
import 'package:anxolotl_app/src/ui/view/landing/well_being_fragment.dart';
import 'package:anxolotl_app/src/ui/viewmodels/health_profile_vm.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:provider/provider.dart';

class MenuObject {
  String bottomBarTitle;
  Icon menuBottomBarIcon;
  Widget bodyWidget;
  Widget titleWidget;

  MenuObject(
    this.bottomBarTitle,
    this.menuBottomBarIcon,
    this.bodyWidget,
    this.titleWidget,
  );
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentMenuIndex = 0;

  void _handleTap(int newIndex) {
    setState(() => _currentMenuIndex = newIndex);
  }

  @override
  void initState() {
    HealthProfileViewModel healthProfileVM;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      healthProfileVM =
          Provider.of<HealthProfileViewModel>(context, listen: false);
      healthProfileVM
          .init()
          .then((value) => healthProfileVM.updateValues())
          .whenComplete(() {
        if (!healthProfileVM.isUserDataInitialized()) {
          setState(() {
            _currentMenuIndex = 3;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);
    TextStyle? h2Style = Theme.of(context).textTheme.displayMedium;

    HealthProfileViewModel healthProfileVM =
        Provider.of<HealthProfileViewModel>(context);

    List<MenuObject> menuWidgetOptions = [
      MenuObject(
        LocalizationsUtil.l10n(context).homeTitle,
        const Icon(Icons.home_outlined),
        const HomeFragment(),
        SizedBox(
            width: phoneScreenWidth / 2.5,
            child: const Image(
              image: AssetImage(
                  "${AssetsPath.BRANDING_ASSETS}anxolotl_logo_appbar.png"),
              fit: BoxFit.fitWidth,
            )),
      ),
      MenuObject(
          LocalizationsUtil.l10n(context).wellBeingTitle,
          const Icon(Icons.self_improvement_outlined),
          const WellBeingFragment(),
          Text(
            LocalizationsUtil.l10n(context).wellBeingTitle,
            style: h2Style,
          )),
      MenuObject(
          LocalizationsUtil.l10n(context).eventsTitle,
          const Icon(Icons.assignment_outlined),
          EventsFragment(
              changeToWellbeingPage: () =>
                  setState(() => _currentMenuIndex = 1)),
          Text(
            LocalizationsUtil.l10n(context).eventsTitle,
            style: h2Style,
          )),
      MenuObject(
          LocalizationsUtil.l10n(context).profileTitle,
          const Icon(Icons.person_outlined),
          const ProfileFragment(),
          Text(
            LocalizationsUtil.l10n(context).profileTitle,
            style: h2Style,
          )),
      //new MenuObject(SettingsPage(), l10n(context).settings),
    ];

    return Scaffold(
      // extendBody for floating bar get better perfomance
      extendBody: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: menuWidgetOptions.elementAt(_currentMenuIndex).titleWidget,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: CustomNavigationBar(
          iconSize: 28.0,
          selectedColor: Theme.of(context).colorScheme.primary,
          strokeColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Theme.of(context).colorScheme.outline,
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 16,
          items: [
            ...menuWidgetOptions
                .map((MenuObject menuObject) => CustomNavigationBarItem(
                      icon: menuObject.menuBottomBarIcon,
                      title: Text(menuObject.bottomBarTitle),
                    ))
                
          ],
          currentIndex: _currentMenuIndex,
          onTap: (int indexVal) => healthProfileVM.isUserDataInitialized()
              ? _handleTap(indexVal)
              : null),
      body: Container(
        child: menuWidgetOptions.elementAt(_currentMenuIndex).bodyWidget,
      ),
    );
  }
}
