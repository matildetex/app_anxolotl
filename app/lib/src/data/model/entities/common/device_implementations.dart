import 'package:anxolotl_app/src/data/model/entities/hband/hband_controller.dart';
import 'package:anxolotl_app/src/data/services/device/contracts/idevice_controller.dart';

///Used to map the name to the devices themselves
enum DeviceImplementations { BITALINO_CUSTOM, BITALINO_ISEL, HBAND }

///Used to map the enum to a instance of a configuration
extension instance on DeviceImplementations {
  IDeviceController get deviceController {
    switch (this) {
      /*case DeviceImplementations.BITALINO_CUSTOM:
        return BitalinoController(BitalinoCustom());
      case DeviceImplementations.BITALINO_ISEL:
        return BitalinoController(BitalinoIsel());*/
      case DeviceImplementations.HBAND:
        return HBandController();
      default:
        throw UnimplementedError();
    }
    throw Exception(
        "The value $this is not a valid sensor"); //TODO exception management and string
  }
}
