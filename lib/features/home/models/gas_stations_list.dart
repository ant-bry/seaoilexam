// To parse this JSON data, do
//
//     final gasStations = gasStationsFromJson(jsonString);

import 'dart:convert';

GasStations gasStationsFromJson(String str) =>
    GasStations.fromJson(json.decode(str));

String gasStationsToJson(GasStations data) => json.encode(data.toJson());

class GasStations {
  GasStations({
    this.message,
    this.gasStationData,
  });

  String? message;
  GasStationData? gasStationData;

  factory GasStations.fromJson(Map<String, dynamic> json) => GasStations(
        message: json['message'] == null ? null : json['message'],
        gasStationData:
            json['data'] == null ? null : GasStationData.fromJson(json['data']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message == null ? null : message,
        'data': gasStationData == null ? null : gasStationData!.toJson(),
      };
}

class GasStationData {
  GasStationData({
    this.stations,
    this.count,
  });

  List<Station>? stations;
  int? count;

  factory GasStationData.fromJson(Map<String, dynamic> json) => GasStationData(
        stations: json['stations'] == null
            ? null
            : List<Station>.from(
                json['stations'].map((dynamic x) => Station.fromJson(x))),
        count: json['count'] == null ? null : json['count'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'stations': stations == null
            ? null
            : List<dynamic>.from(stations!.map((dynamic x) => x.toJson())),
        'count': count == null ? null : count,
      };
}

class Station {
  Station({
    this.stationId,
    this.depotId,
    this.name,
    this.stationCode,
    this.mobileNumber,
    this.latitude,
    this.longitude,
    this.province,
    this.city,
    this.address,
    this.stationType,
    this.opensAt,
    this.closesAt,
    this.status,
    this.isPlbOnboarded,
    this.isPlcOnboarded,
    this.stationProduct,
  });

  int? stationId;
  int? depotId;
  String? name;
  int? stationCode;
  String? mobileNumber;
  double? latitude;
  double? longitude;
  String? province;
  String? city;
  String? address;
  String? stationType;
  String? opensAt;
  String? closesAt;
  String? status;
  bool? isPlbOnboarded;
  bool? isPlcOnboarded;
  StationProduct? stationProduct;

  factory Station.fromJson(Map<String, dynamic> json) => Station(
        stationId: json['stationId'] == null ? null : json['stationId'],
        depotId: json['depotId'] == null ? null : json['depotId'],
        name: json['name'] == null ? null : json['name'],
        stationCode: json['stationCode'] == null ? null : json['stationCode'],
        mobileNumber:
            json['mobileNumber'] == null ? null : json['mobileNumber'],
        latitude: json['latitude'] == null ? null : json['latitude'].toDouble(),
        longitude:
            json['longitude'] == null ? null : json['longitude'].toDouble(),
        province: json['province'] == null ? null : json['province'],
        city: json['city'] == null ? null : json['city'],
        address: json['address'] == null ? null : json['address'],
        stationType: json['stationType'] == null ? null : json['stationType'],
        opensAt: json['opensAt'] == null ? null : json['opensAt'],
        closesAt: json['closesAt'] == null ? null : json['closesAt'],
        status: json['status'] == null ? null : json['status'],
        isPlbOnboarded:
            json['isPlbOnboarded'] == null ? null : json['isPlbOnboarded'],
        isPlcOnboarded:
            json['isPlcOnboarded'] == null ? null : json['isPlcOnboarded'],
        stationProduct: json['stationProduct'] == null
            ? null
            : StationProduct.fromJson(json['stationProduct']),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'stationId': stationId == null ? null : stationId,
        'depotId': depotId == null ? null : depotId,
        'name': name == null ? null : name,
        'stationCode': stationCode == null ? null : stationCode,
        'mobileNumber': mobileNumber == null ? null : mobileNumber,
        'latitude': latitude == null ? null : latitude,
        'longitude': longitude == null ? null : longitude,
        'province': province == null ? null : province,
        'city': city == null ? null : city,
        'address': address == null ? null : address,
        'stationType': stationType == null ? null : stationType,
        'opensAt': opensAt == null ? null : opensAt,
        'closesAt': closesAt == null ? null : closesAt,
        'status': status == null ? null : status,
        'isPlbOnboarded': isPlbOnboarded == null ? null : isPlbOnboarded,
        'isPlcOnboarded': isPlcOnboarded == null ? null : isPlcOnboarded,
        'stationProduct':
            stationProduct == null ? null : stationProduct!.toJson(),
      };
}

class StationProduct {
  StationProduct({
    this.diesel,
    this.gas91,
    this.gas95,
    this.gas97,
  });

  bool? diesel;
  bool? gas91;
  bool? gas95;
  bool? gas97;

  factory StationProduct.fromJson(Map<String, dynamic> json) => StationProduct(
        diesel: json['diesel'] == null ? null : json['diesel'],
        gas91: json['gas91'] == null ? null : json['gas91'],
        gas95: json['gas95'] == null ? null : json['gas95'],
        gas97: json['gas97'] == null ? null : json['gas97'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'diesel': diesel == null ? null : diesel,
        'gas91': gas91 == null ? null : gas91,
        'gas95': gas95 == null ? null : gas95,
        'gas97': gas97 == null ? null : gas97,
      };
}

// enum StationType { COCO, COXO, CODO }

// final stationTypeValues = EnumValues({
//     "COCO": StationType.COCO,
//     "CODO": StationType.CODO,
//     "COXO": StationType.COXO
// });

// enum Status { ACTIVE }

// final statusValues = EnumValues({
//     "active": Status.ACTIVE
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         if (reverseMap == null) {
//             reverseMap = map.map((k, v) => new MapEntry(v, k));
//         }
//         return reverseMap;
//     }
// }
