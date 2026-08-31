import 'package:anxolotl_app/src/data/services/bluetooth/bluetooth_dev.dart';
import 'package:anxolotl_app/src/util/aesthetics/design_theme.dart';
import 'package:anxolotl_app/src/util/phone_info.dart';
import 'package:flutter/material.dart';

class BluetoothDeviceEntry extends StatelessWidget {
  final BluetoothDev blDevice;
  final Function onConnectFunction;

  const BluetoothDeviceEntry(this.blDevice, this.onConnectFunction, {super.key});

  @override
  Widget build(BuildContext context) {
    TextStyle? h3Style = Theme.of(context).textTheme.displaySmall;
    TextStyle? bodySmallStyle = Theme.of(context).textTheme.bodySmall;
    double phoneScreenWidth = PhoneInfo.getScreenWidth(context);

    return InkWell(
        onTap: () => onConnectFunction(context),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(DesignTheme.singlePadding),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.bluetooth,
                          color: (blDevice.blType ==
                                  BluetoothCommunicationType.BLE)
                              ? Theme.of(context).colorScheme.tertiary
                              : Theme.of(context).colorScheme.secondary),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                                width: phoneScreenWidth / 2.2,
                                child: Text(
                                  blDevice.name,
                                  overflow: TextOverflow.ellipsis,
                                  style: h3Style,
                                )),
                            Text(
                              "mac : ${blDevice.getIdentifier()}",
                              style: bodySmallStyle,
                            )
                          ]),
                    ]))));
  }
}
