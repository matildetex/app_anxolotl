import 'dart:convert';

import 'package:anxolotl_app/src/data/data_acces/api/amqp/amqp_utils.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/measurements/measurement_json_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/user_info/user_device_json_dto.dart';
import 'package:anxolotl_app/src/data/data_acces/dto/api/user_info/user_info_json_dto.dart';
import 'package:dart_amqp/dart_amqp.dart';

class AmqpApi {
  late Client amqpClient;
  final List<Consumer> consumersOnline = [];

  Future<void> initClient(String host, String port) async {
    ConnectionSettings settings = ConnectionSettings(
        host: host,
        port: int.parse(port),
        authProvider:
            const PlainAuthenticator(AmqpInfo.username, AmqpInfo.userPass));
    //tlsContext: await SSLConfig.getSSLConfig());
    amqpClient = Client(settings: settings);
  }

  Future<bool> _sendMessage(AmqpPaths amqpPath, String message,
      {String routingKey = "", MessageProperties? messageProperties}) async {
    try {
      await amqpClient.connect();
      Channel channel = await amqpClient.channel();
      Exchange exchange = await channel
          .exchange(amqpPath.getAmqpName, ExchangeType.FANOUT, passive: true);
      if (messageProperties != null) {
        exchange.publish(message, routingKey, properties: messageProperties);
      } else {
        exchange.publish(message, routingKey);
      }
      await amqpClient.close();
      print("client connected and message sent");
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> _sendMessages(AmqpPaths amqpPath, Iterable<String> messages,
      {String routingKey = "", MessageProperties? messageProperties}) async {
    int msgCounter = 0;
    try {
      await amqpClient.connect();
      Channel channel = await amqpClient.channel();
      Exchange exchange = await channel
          .exchange(amqpPath.getAmqpName, ExchangeType.FANOUT, passive: true);
      if (messageProperties != null) {
        for (var message in messages) {
          print("publishin");
          exchange.publish(message, routingKey, properties: messageProperties);

          msgCounter++;
        }
      } else {
        for (var message in messages) {
          print("publishin");
          exchange.publish(message, routingKey);
          msgCounter++;
        }
      }
      await amqpClient.close();
      print("client connected and message sent");
      return msgCounter;
    } catch (e) {
      print(e);
      return msgCounter;
    }
  }

  Future<void> createListener(AmqpPaths amqpPath, String routingKey,
      void Function(AmqpMessage event) onEventCb) async {
    Consumer? localConsumer;
    try {
      await amqpClient.connect();
      Channel channel = await amqpClient.channel();
      Queue queue = await channel.queue(amqpPath.getAmqpName, passive: true);
      localConsumer = await queue.consume();
      localConsumer.listen(onEventCb);
      consumersOnline.add(localConsumer);
      // Get the payload as a string
      //print(" [x] Received string: ${message.payloadAsString}");
    } catch (e) {
      print(e);
      if (localConsumer != null) {
        await localConsumer.channel.close();
        consumersOnline
            .removeWhere((element) => element.tag == localConsumer!.tag);
      }
    }
  }

  Future<void> clearListeners() async {
    consumersOnline.forEach((Consumer consumer) async {
      await consumer.channel.close();
    });

    consumersOnline.clear();
  }

  Future<bool> uploadMeasurement(MeasurementJsonDto measurementJsonDto) async {
    MessageProperties messageProperties = MessageProperties();
    messageProperties.contentEncoding = 'utf-8';
    return _sendMessage(AmqpPaths.HRV_EXC, jsonEncode(measurementJsonDto));
  }

  Future<int> uploadMultiMeasurements(
      Iterable<MeasurementJsonDto> measurementsJsonDto) async {
    MessageProperties messageProperties = MessageProperties();
    messageProperties.contentEncoding = 'utf-8';
    return _sendMessages(
        AmqpPaths.HRV_EXC,
        measurementsJsonDto
            .map((measurementJsonDto) => jsonEncode(measurementJsonDto)),
        messageProperties: messageProperties);
  }

  Future<bool> uploadUserProfile(UserProfileJsonDto userProfileJsonDto) async {
    MessageProperties messageProperties = MessageProperties();
    messageProperties.contentEncoding = 'utf-8';
    messageProperties.contentType = "userInfo";

    return _sendMessage(AmqpPaths.USER_INFO_EXC, jsonEncode(userProfileJsonDto),
        messageProperties: messageProperties);
  }

  Future<bool> uploadUserDevice(UserDeviceJsonDto userDeviceJsonDto) async {
    MessageProperties messageProperties = MessageProperties();
    messageProperties.contentEncoding = 'utf-8';
    messageProperties.contentType = "userBlDevice";

    return _sendMessage(AmqpPaths.USER_INFO_EXC, jsonEncode(userDeviceJsonDto),
        messageProperties: messageProperties);
  }
}
