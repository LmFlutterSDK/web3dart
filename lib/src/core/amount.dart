part of 'package:web3dart/web3dart.dart';

enum EtherUnit {
  ///Wei, the smallest and atomic amount of Ether
  wei,

  ///kwei, 1000 wei
  kwei,

  ///Mwei, one million wei
  mwei,

  ///Gwei, one billion wei. Typically a reasonable unit to measure gas prices.
  gwei,

  ///szabo, 10^12 wei or 1 μEther
  szabo,

  ///finney, 10^15 wei or 1 mEther
  finney,

  ether
}

/// Utility class to easily convert amounts of Ether into different units of
/// quantities.
class EtherAmount {
  static final Map<EtherUnit, BigInt> _factors = {
    EtherUnit.wei: BigInt.one,
    EtherUnit.kwei: BigInt.from(10).pow(3),
    EtherUnit.mwei: BigInt.from(10).pow(6),
    EtherUnit.gwei: BigInt.from(10).pow(9),
    EtherUnit.szabo: BigInt.from(10).pow(12),
    EtherUnit.finney: BigInt.from(10).pow(15),
    EtherUnit.ether: BigInt.from(10).pow(18)
  };

  final BigInt _value;

  BigInt get getInWei => _value;
  BigInt get getInEther => getValueInUnitBI(EtherUnit.ether);

  const EtherAmount.inWei(this._value);

  EtherAmount.zero() : this.inWei(BigInt.zero);

  /// Constructs an amount of Ether by a unit and its amount. [amount] can
  /// either be a base10 string, an int, or a BigInt.
  factory EtherAmount.fromUnitAndValue(EtherUnit unit, dynamic amount) {
    BigInt parsedAmount;

    if (amount is BigInt) {
      parsedAmount = amount;
    } else if (amount is int) {
      parsedAmount = BigInt.from(amount);
    } else if (amount is String) {
      parsedAmount = BigInt.parse(amount);
    } else {
      throw ArgumentError('Invalid type, must be BigInt, string or int');
    }

    return EtherAmount.inWei(parsedAmount * _factors[unit]);
  }

  /// Constructs a value of [amount] full ether.
  /// [amount] can either be a base10 [String], an [int] or a [BigInt].
  factory EtherAmount.ether(dynamic amount) =>
      EtherAmount.fromUnitAndValue(EtherUnit.ether, amount);

  /// Constructs an amount of ether consisting of [amount] finney, or [amount] quadrillion wei.
  /// [amount] can either be a base10 [String], an [int] or a [BigInt].
  factory EtherAmount.finney(dynamic amount) =>
      EtherAmount.fromUnitAndValue(EtherUnit.finney, amount);

  /// Constructs an amount of ether consisting of [amount] szabo, or [amount] trillion wei.
  /// [amount] can either be a base10 [String], an [int] or a [BigInt].
  factory EtherAmount.szabo(dynamic amount) =>
      EtherAmount.fromUnitAndValue(EtherUnit.szabo, amount);

  /// Constructs an amount of ether consisting of [amount] gwei, or [amount] billion wei.
  /// [amount] can either be a base10 [String], an [int] or a [BigInt].
  factory EtherAmount.gwei(dynamic amount) =>
      EtherAmount.fromUnitAndValue(EtherUnit.gwei, amount);

  /// Constructs an amount of ether consisting of [amount] mwei, or [amount] million wei.
  /// [amount] can either be a base10 [String], an [int] or a [BigInt].
  factory EtherAmount.mwei(dynamic amount) =>
      EtherAmount.fromUnitAndValue(EtherUnit.mwei, amount);

  /// Constructs an amount of ether consisting of [amount] kwei, or [amount] thousand wei.
  /// [amount] can either be a base10 [String], an [int] or a [BigInt].
  factory EtherAmount.kwei(dynamic amount) =>
      EtherAmount.fromUnitAndValue(EtherUnit.kwei, amount);

  /// Constructs an amount of ether consisting of [amount] wei, the smallest unit in Ethereum.
  /// [amount] can either be a base10 [String], an [int] or a [BigInt].
  factory EtherAmount.wei(dynamic amount) =>
      EtherAmount.fromUnitAndValue(EtherUnit.wei, amount);

  /// Gets the value of this amount in the specified unit as a whole number.
  /// **WARNING**: For all units except for [EtherUnit.wei], this method will
  /// discard the remainder occurring in the division, making it unsuitable for
  /// calculations or storage. You should store and process amounts of ether by
  /// using a BigInt storing the amount in wei.
  BigInt getValueInUnitBI(EtherUnit unit) => _value ~/ _factors[unit];

  /// Gets the value of this amount in the specified unit. **WARNING**: Due to
  /// rounding errors, the return value of this function is not reliable,
  /// especially for larger amounts or smaller units. While it can be used to
  /// display the amount of ether in a human-readable format, it should not be
  /// used for anything else.
  num getValueInUnit(EtherUnit unit) {
    final value = _value ~/ _factors[unit];
    final remainder = _value.remainder(_factors[unit]);

    return value.toInt() + (remainder.toInt() / _factors[unit].toInt());
  }

  @override
  String toString() {
    return 'EtherAmount: $getInWei wei';
  }

  @override
  int get hashCode => getInWei.hashCode;

  @override
  bool operator ==(dynamic other) =>
      other is EtherAmount && other.getInWei == getInWei;
}
