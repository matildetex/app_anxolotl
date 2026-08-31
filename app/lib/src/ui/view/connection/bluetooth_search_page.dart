import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:anxolotl_app/src/lang/anxolotl_localizations.dart';
import 'package:anxolotl_app/src/ui/view/common_widgets/custom_app_bar.dart';
import 'package:anxolotl_app/src/ui/view/connection/bluetooth_device_entry.dart';
import 'package:anxolotl_app/src/ui/viewmodels/bluetooth_vm.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BluetoothSearch extends StatefulWidget {
  const BluetoothSearch({super.key});

  @override
  _BluetoothSearchState createState() => _BluetoothSearchState();
}

class _BluetoothSearchState extends State<BluetoothSearch> {
  late List<BluetoothDev> foundDevices = [];
  SnackBar snackBar = const SnackBar(content: Text(""));

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      BluetoothViewModel bluetoothVM =
          Provider.of<BluetoothViewModel>(context, listen: false);
      bluetoothVM.scanDevices(containerList: foundDevices);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    BluetoothViewModel bluetoothVM = Provider.of<BluetoothViewModel>(context);
    //bluetoothVM.loadNotificationStrings(context);
    TextStyle? menuStyle = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
        appBar: CustomAppBar(
            title: LocalizationsUtil.l10n(context).connectDeviceTitle),
        body: SafeArea(
            child: Column(children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: DesignTheme.singlePadding,
                    right: DesignTheme.singlePadding,
                    top: DesignTheme.singlePadding),
                child: Text(
                  LocalizationsUtil.l10n(context).availableDevices,
                  style: menuStyle,
                ),
              ),
              const Spacer(
                flex: 4,
              ),
              bluetoothVM.isScanning()
                  ? SizedBox(
                      height: 15.0,
                      width: 15.0,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    )
                  : const Spacer(),
              const Spacer(
                flex: 1,
              )
            ],
          ),
          const Divider(
            thickness: 2,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: DesignTheme.singlePadding, horizontal: 15),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return BluetoothDeviceEntry(
                      foundDevices[index],
                      (BuildContext newCtx) => _onConnectListener(
                          foundDevices[index], bluetoothVM, newCtx));
                },
                itemCount: foundDevices.length,
              ))
        ])));
  }

  @override
  void deactivate() {
    if (mounted) {
      BluetoothViewModel bluetoothVM =
          Provider.of<BluetoothViewModel>(context, listen: false);
      bluetoothVM.stopScanning(closingWidget: true);
    }

    super.deactivate();
  }

  void _onConnectListener(BluetoothDev scanResult,
      BluetoothViewModel deviceViewModel, BuildContext context) async {
    try {
      snackBar = SnackBar(
          content: Text(LocalizationsUtil.l10n(context).tryingConnection));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await deviceViewModel.connectDevice(scanResult, newConnection: true);
      Navigator.pop(context);
    } on Exception catch (e) {
      snackBar = SnackBar(
          content: Text(LocalizationsUtil.l10n(context).connectionError));
      print('Reason : $e');
    } catch (error) {
      snackBar = SnackBar(
          content: Text(LocalizationsUtil.l10n(context).connectionError));
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
