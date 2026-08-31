import 'dart:typed_data';

import 'package:bit_array/bit_array.dart';

extension bluetoothUtils on List<int> {
  List<int> setBitData(int offset, int length, int value) {
    int initialLength = this.length;

    List<int> newList = [];
    newList.addAll(this);
    while (newList.length % 4 != 0) {
      newList.add(0);
    }
    Uint8List uint8List = Uint8List.fromList(newList);
    //Uint8List uint8List = Uint8List.fromList(this.map((e) => _reverseBits(e)).toList());

    BitArray bitArray = BitArray.fromUint8List(uint8List);

    Iterable<int> bitCounterIter =
        Iterable.generate(length, (int i) => offset + i);

    bitArray.clearBits(bitCounterIter);

    for (var bitIndex in bitCounterIter) {
      int currentIndex = bitIndex - offset;
      int bitToCompare = 1 << currentIndex;
      if (value & bitToCompare > 0) {
        bitArray.setBit(bitIndex);
      }
    }
    Uint8List test = bitArray.byteBuffer.asUint8List();
    return bitArray.byteBuffer.asUint8List().sublist(0, initialLength);
  }

  int getBitData(int offset, int length) {
    //Uint8List uint8List = Uint8List.fromList(this.map((e) => _reverseBits(e)).toList());
    List<int> newList = [];
    newList.addAll(this);
    while (newList.length % 4 != 0) {
      newList.add(0);
    }
    Uint8List uint8List = Uint8List.fromList(newList);

    BitArray bitArray = BitArray.fromUint8List(uint8List);

    Iterable<int> bitCounterIter =
        Iterable.generate(length, (int i) => offset + i);

    int result = 0;

    for (var bitIndex in bitCounterIter) {
      int currentIndex = bitIndex - offset;
      if (bitArray[bitIndex]) {
        result += 1 << currentIndex;
      }
    }

    return result;
  }
}
