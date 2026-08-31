import 'package:anxolotl_app/globals/app_routes.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/animations/page_slide_left_transition.dart';
import 'package:anxolotl_app/src/ui/view/connection/bluetooth_search_page.dart';
import 'package:anxolotl_app/src/ui/view/landing/widgets/profile_text_field.dart';
import 'package:anxolotl_app/src/ui/viewmodels/anxiety_data_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/authentication_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/bluetooth_vm.dart';
import 'package:anxolotl_app/src/ui/viewmodels/health_profile_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:provider/provider.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({super.key});

  @override
  State<ProfileFragment> createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  @override
  void deactivate() {
    super.deactivate();
    HealthProfileViewModel healthProfileVM =
        Provider.of<HealthProfileViewModel>(context, listen: false);

    healthProfileVM.deactivatePageOperations();
  }

  @override
  void activate() {
    super.activate();
    HealthProfileViewModel healthProfileVM =
        Provider.of<HealthProfileViewModel>(context, listen: false);

    healthProfileVM.updateValues();

    BluetoothViewModel bluetoothVM =
        Provider.of<BluetoothViewModel>(context, listen: false);
    bluetoothVM.updateDeviceBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);

    TextStyle? h3Style = Theme.of(context).textTheme.displaySmall;
    TextStyle? titleMediumStyle = Theme.of(context).textTheme.titleMedium;
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    Color? secondaryColor = Theme.of(context).colorScheme.secondary;
    double formWidth = phoneScreenWidth / 2.5;

    HealthProfileViewModel healthProfileVM =
        Provider.of<HealthProfileViewModel>(context);

    AuthenticationViewModel authenticationVM =
        Provider.of<AuthenticationViewModel>(context);

    BluetoothViewModel bluetoothVM = Provider.of<BluetoothViewModel>(context);

    AnxietyDataViewModel anxietyDataVM =
        Provider.of<AnxietyDataViewModel>(context);

    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(DesignTheme.singlePadding),
                child: ListView(shrinkWrap: true, children: [
                  Text(
                    LocalizationsUtil.l10n(context).aboutYou,
                    style: h3Style,
                  ),
                  const Padding(
                      padding: EdgeInsets.all(DesignTheme.singlePadding)),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProfileTextField(
                            textFieldWidth: formWidth,
                            textFieldLabel:
                                LocalizationsUtil.l10n(context).birthdayWord,
                            textData:
                                healthProfileVM.getUserBirthday().toString(),
                            raisesEmptyError: true,
                            onTap: () => showMaterialDatePicker(
                              context: context,
                              headerColor: secondaryColor,
                              buttonTextColor: secondaryColor,
                              selectedDate:
                                  healthProfileVM.getUserBirthday().currValue ??
                                      DateTime.now(),
                              onChanged: (DateTime value) =>
                                  healthProfileVM.setUserBirthday(value),
                              firstDate: healthProfileVM
                                  .getUserBirthday()
                                  .getMinDate(),
                              lastDate: healthProfileVM
                                  .getUserBirthday()
                                  .getMaxDate(),
                            ),
                          ),
                          ProfileTextField(
                              textFieldWidth: formWidth,
                              textFieldLabel:
                                  LocalizationsUtil.l10n(context).genderWord,
                              textData: healthProfileVM
                                  .getUserGender()
                                  .getTranslatedString(context),
                              raisesEmptyError: true,
                              onTap: () => showMaterialScrollPicker<String>(
                                  headerColor: secondaryColor,
                                  buttonTextColor: secondaryColor,
                                  context: context,
                                  showDivider: false,
                                  title: LocalizationsUtil.l10n(context)
                                      .selectYourExp(
                                          LocalizationsUtil.l10n(context)
                                              .genderWord),
                                  items: healthProfileVM
                                      .getUserGender()
                                      .getValuesViewStrings(context),
                                  selectedItem: healthProfileVM
                                      .getUserGender()
                                      .getTranslatedString(context),
                                  onChanged: (String value) => healthProfileVM
                                      .setUserGender(value, context)))
                        ],
                      ),
                      const SizedBox(
                        height: DesignTheme.doublePadding,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ProfileTextField(
                            textFieldWidth: formWidth,
                            textFieldLabel:
                                LocalizationsUtil.l10n(context).weightWord,
                            textData:
                                healthProfileVM.getUserWeight().toString(),
                            onTap: () => showMaterialScrollPicker<int?>(
                                headerColor: secondaryColor,
                                buttonTextColor: secondaryColor,
                                context: context,
                                showDivider: false,
                                title:
                                    '${LocalizationsUtil.l10n(context).selectYourExp(LocalizationsUtil.l10n(context).weightWord)} (${healthProfileVM.getUserWeight().unit})',
                                items:
                                    healthProfileVM.getUserWeight().getValues(),
                                selectedItem:
                                    healthProfileVM.getUserWeight().currValue,
                                onChanged: (int? value) =>
                                    healthProfileVM.setUserWeight(value!)),
                          ),
                          ProfileTextField(
                            textFieldWidth: formWidth,
                            textFieldLabel:
                                LocalizationsUtil.l10n(context).heightWord,
                            textData:
                                healthProfileVM.getUserHeight().toString(),
                            onTap: () => showMaterialScrollPicker<int?>(
                                headerColor: secondaryColor,
                                buttonTextColor: secondaryColor,
                                context: context,
                                showDivider: false,
                                title:
                                    '${LocalizationsUtil.l10n(context).selectYourExp(LocalizationsUtil.l10n(context).heightWord)} (${healthProfileVM.getUserHeight().unit})',
                                items:
                                    healthProfileVM.getUserHeight().getValues(),
                                selectedItem:
                                    healthProfileVM.getUserHeight().currValue,
                                onChanged: (int? value) =>
                                    healthProfileVM.setUserHeight(value!)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: DesignTheme.triplePadding,
                  ),
                  Text(
                    LocalizationsUtil.l10n(context).deviceWord,
                    style: h3Style,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: DesignTheme.singlePadding,
                        right: DesignTheme.singlePadding,
                        top: DesignTheme.singlePadding),
                    child: InkWell(
                      onTap: () async {
                        if ((await bluetoothVM.isBluetoothOn()) == false) {
                          bluetoothOffWarning(context);
                        } else if (bluetoothVM.isConnected() == false) {
                          Navigator.of(context).push(
                              SlideRightRoute(page: const BluetoothSearch()));
                        }
                      },
                      onLongPress: () {
                        if (bluetoothVM.isConnected()) {
                          disconnectDeviceWarning(context, bluetoothVM);
                        }
                      },
                      child: SizedBox(
                          height: 30,
                          child: bluetoothVM.isConnected()
                              ? Row(
                                  children: [
                                    Text(bluetoothVM.getCurrDeviceIdentifier(),
                                        style: titleMediumStyle),
                                    const Spacer(),
                                    const Icon(Icons.battery_0_bar_outlined),
                                    Text(
                                      "${bluetoothVM.getBatteryLevel()}%",
                                      style: bodySmallStyle,
                                    ),
                                  ],
                                )
                              : Text(
                                  LocalizationsUtil.l10n(context)
                                      .connectNewDevice,
                                  style: titleMediumStyle)),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: DesignTheme.triplePadding,
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(secondaryColor)),
                          onPressed: () async => await logOutWarning(context)
                              .then((value) => logOutResponse(authenticationVM,
                                  bluetoothVM, anxietyDataVM)),
                          child: Text(
                              LocalizationsUtil.l10n(context).logOutMessage)))
                ]))));
  }

  Future logOutResponse(
      AuthenticationViewModel authenticationVM,
      BluetoothViewModel bluetoothVM,
      AnxietyDataViewModel anxietyDataViewModel) async {
    if (!(await authenticationVM.logOut())) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(LocalizationsUtil.l10n(context).failedLogOut)));
    } else {
      anxietyDataViewModel.disconnectListeners();
      bluetoothVM.disconnectDevice();
      await Future.delayed(const Duration(milliseconds: 1500)).then((value) =>
          Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.LOGIN_PAGE, (Route<dynamic> route) => false));
    }
  }

  Future<void> logOutWarning(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LocalizationsUtil.l10n(context).warningExp,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  LocalizationsUtil.l10n(context).logOutWarning,
                  maxLines: 6,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(LocalizationsUtil.l10n(context).continueExp),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> disconnectDeviceWarning(
      BuildContext context, BluetoothViewModel bluetoothVM) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LocalizationsUtil.l10n(context).warningExp,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  LocalizationsUtil.l10n(context).disconnectBluetoothDevice,
                  maxLines: 6,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(LocalizationsUtil.l10n(context).cancelExp),
                onPressed: () => Navigator.pop(context)),
            TextButton(
                child: Text(LocalizationsUtil.l10n(context).continueExp),
                onPressed: () async {
                  await bluetoothVM.disconnectDevice();
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }

  Future<void> bluetoothOffWarning(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LocalizationsUtil.l10n(context).warningExp,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  LocalizationsUtil.l10n(context).bluetoothOffMessage,
                  maxLines: 6,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: Text(LocalizationsUtil.l10n(context).continueExp),
                onPressed: () async {
                  Navigator.pop(context);
                }),
          ],
        );
      },
    );
  }
}
