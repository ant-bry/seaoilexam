import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:seaoil/core/services/api.dart';
import 'package:seaoil/core/utils/generic_exception.dart';
import 'package:seaoil/features/home/models/gas_stations_list.dart';

class HomeController extends GetxController {
  RxBool isGettingCurrentPositionInit = false.obs;
  RxBool isStationsListLoading = false.obs;
  RxBool searchState = false.obs;
  RxBool detailState = false.obs;

  late Future<GasStations> getGasStations;

  Rx<GasStations> gasStations = Rx<GasStations>(GasStations());

  Rx<Station> selectedGasStation = Rx<Station>(Station());

  RxList<Station> searchResultStations = RxList<Station>();

  Rx<Completer<GoogleMapController>> gMapController =
      Rx<Completer<GoogleMapController>>(Completer<GoogleMapController>());

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Marker> markers = <Marker>[];

  final CameraPosition kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future<Position>.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future<Position>.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future<Position>.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Position? currentPosition;
  CameraPosition? currentCameraPosition;

  Future<void> getCurrentPosition() async {
    isGettingCurrentPositionInit.value = true;
    currentPosition = await determinePosition();
    currentCameraPosition = await CameraPosition(
      target: LatLng(
        currentPosition!.latitude,
        currentPosition!.longitude,
      ),
      zoom: 14.4746,
    );

    getGasStations = getStationList(
        page: 1, perPage: 10, isPlcOnboarded: true, platformType: 'plc');

    isGettingCurrentPositionInit.value = false;
  }

  Future<void> goBackToCurrentPosition() async {
    GoogleMapController controller = await gMapController.value.future;
    controller
        .animateCamera(CameraUpdate.newCameraPosition(currentCameraPosition!));
    selectedGasStation.value = Station();
    detailState.value = false;
    searchState.value = false;
  }

  Future<GasStations> getStationList({
    required int page,
    required int perPage,
    required bool isPlcOnboarded,
    required String platformType,
  }) async {
    isStationsListLoading.value = true;
    try {
      markers.clear();
      final http.Response response = await Api.get(
          'ms-fleet/station?page=$page&perPage=$perPage&isPlcOnboarded=$isPlcOnboarded&platformType=$platformType');

      gasStations.value = gasStationsFromJson(response.body);

      // Sort gas stations based on the distance to get nearby gas stations.
      gasStations.value.gasStationData!.stations!.sort((Station a, Station b) =>
          getDistanceKm(a.latitude!, a.longitude!)
              .compareTo(getDistanceKm(b.latitude!, b.longitude!)));

      isStationsListLoading.value = false;

      generateMarkers();

      return gasStations.value;
    } on GenericException catch (e) {
      isStationsListLoading.value = false;
      showGenericAlertDialog(context: Get.context!, error: e);
      throw e;
    }
  }

  int getDistanceKm(double stationLat, double stationLong) {
    double distance = Geolocator.distanceBetween(
      currentPosition!.latitude,
      currentPosition!.longitude,
      stationLat,
      stationLong,
    );
    return distance ~/ 1000;
  }

  Future<void> goToSelectedGasStation(Station station) async {
    GoogleMapController controller = await gMapController.value.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        await CameraPosition(
          target: LatLng(
            station.latitude!,
            station.longitude!,
          ),
          zoom: 14.4746,
        ),
      ),
    );
  }

  void generateMarkers() {
    for (Station s in gasStations.value.gasStationData!.stations!) {
      markers.add(Marker(
        markerId: MarkerId(s.name!),
        position: LatLng(s.latitude!, s.longitude!),
        infoWindow: InfoWindow(
          title: s.name!,
          snippet: s.address!,
        ),
      ));
    }
    print('markers: $markers');
  }

  void searchStation(String text) {
    searchResultStations.clear();
    if (searchState.value) {
      gasStations.value.gasStationData!.stations!.forEach((Station station) {
        if (station.name!.toLowerCase().contains(text.toLowerCase())) {
          searchResultStations.add(station);
        }
      });
    }
  }
}
