import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:seaoil/core/utils/strings.dart';
import 'package:seaoil/core/widgets/adaptive.dart';
import 'package:seaoil/core/widgets/bottom_sheet_container.dart';
import 'package:seaoil/features/home/controllers/home_controller.dart';
import 'package:seaoil/features/home/models/gas_stations_list.dart';
import 'package:seaoil/features/login/login.dart';
import 'package:seaoil/gen/colors.gen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController homeController;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  TextEditingController searchTEC = TextEditingController();

  Future<void> _setup() async {
    homeController = Get.put(HomeController());
    await homeController.getCurrentPosition();
    showBottomSheet();
  }

  @override
  void initState() {
    super.initState();
    _setup();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: homeController.scaffoldKey,
        appBar: AppBar(
          leading: Obx(
            () => Visibility(
              visible: homeController.searchState.value,
              child: IconButton(
                onPressed: () {
                  homeController.searchState.value = false;
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          centerTitle: true,
          backgroundColor: ColorName.deepPurple,
          title: Text(
            Strings.searchStation,
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            Obx(
              () => Visibility(
                visible: !homeController.searchState.value,
                child: IconButton(
                  onPressed: () {
                    homeController.searchState.value = true;
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Obx(
              () => Visibility(
                visible: !homeController.searchState.value,
                child: IconButton(
                  onPressed: () async {
                    await _storage.deleteAll();
                    Get.offAll(() => LoginPage());
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Obx(
            () => Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: ColorName.deepPurple,
                  padding: EdgeInsets.only(bottom: 8),
                  child: Center(
                    child: Text(
                      Strings.whichPriceLOCQStationWillYouLikelyVisit,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                homeController.searchState.value
                    ? Container(
                        color: ColorName.deepPurple,
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 32,
                        ),
                        child: TextFormField(
                            enabled: true,
                            controller: searchTEC,
                            keyboardType: TextInputType.text,
                            maxLength: 50,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintText: Strings.search,
                              prefixIcon: Icon(Icons.search),
                              prefixIconColor: Colors.black,
                              counterText: '',
                            ),
                            onChanged: (String text) {
                              homeController.searchStation(text);
                            }),
                      )
                    : Container(),
                homeController.isGettingCurrentPositionInit.value
                    ? LinearProgressIndicator()
                    : Expanded(
                        child: Obx(
                          () => GoogleMap(
                            mapType: MapType.normal,
                            initialCameraPosition:
                                homeController.currentCameraPosition!,
                            onMapCreated: (GoogleMapController controller) {
                              homeController.gMapController.value
                                  .complete(controller);
                            },
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: true,
                            markers: Set<Marker>.of(homeController.markers),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
        floatingActionButton: Obx(
          () => Visibility(
            visible: !homeController.searchState.value,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 76.0),
              child: FloatingActionButton(
                onPressed: () => homeController.goBackToCurrentPosition(),
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.my_location_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void showBottomSheet() {
    homeController.scaffoldKey.currentState!.showBottomSheet(
      (BuildContext context) {
        return FutureBuilder<GasStations>(
          future: homeController.getGasStations,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Obx(
                () => homeController.searchState.value
                    ? searchGasStationList(context)
                    : homeController.detailState.value
                        ? stationDetails(context)
                        : bottomSheetNearbyStations(context),
              );
            } else if (snapshot.hasError) {
              return bottomSheetError(context);
            } else {
              return bottomSheetLoading(context);
            }
          },
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 5,
      enableDrag: false,
    );
  }

  Widget stationDetails(BuildContext context) {
    Station station = homeController.selectedGasStation.value;
    return BottomSheetContainer(
      height: MediaQuery.of(context).size.height / 3.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    homeController.goBackToCurrentPosition();
                  },
                  child: Text(
                    Strings.backToList,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    homeController.goBackToCurrentPosition();
                  },
                  child: Text(
                    Strings.done,
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    station.name!,
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    station.address!,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.directions_car_filled_outlined,
                        color: Colors.blue.shade900,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${homeController.getDistanceKm(station.latitude!, station.longitude!)} km away',
                      ),
                      SizedBox(width: 32),
                      Icon(
                        Icons.watch_later_outlined,
                        color: Colors.blue.shade900,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${homeController.getDistanceKm(station.latitude!, station.longitude!)} km away',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchGasStationList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(),
        color: Colors.white,
      ),
      height: MediaQuery.of(context).viewInsets.bottom > 0
          ? MediaQuery.of(context).size.height - (kToolbarHeight * 7.5)
          : MediaQuery.of(context).size.height - (kToolbarHeight * 3),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            SizedBox(height: 8),
            Obx(
              () => Expanded(
                child: homeController.searchResultStations.isNotEmpty ||
                        searchTEC.text.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: homeController.searchResultStations.length,
                        itemBuilder: ((BuildContext context, int index) {
                          Station station =
                              homeController.searchResultStations[index];
                          return Obx(
                            () => RadioListTile<Station>(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: station,
                              groupValue:
                                  homeController.selectedGasStation.value,
                              onChanged: (Station? x) {
                                homeController.selectedGasStation.value = x!;
                                homeController.goToSelectedGasStation(
                                    homeController.selectedGasStation.value);
                                homeController.detailState.value = true;
                                homeController.searchState.value = false;
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    station.name!,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${homeController.getDistanceKm(station.latitude!, station.longitude!)} km away from you',
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: homeController
                            .gasStations.value.gasStationData!.stations!.length,
                        itemBuilder: ((BuildContext context, int index) {
                          Station station = homeController.gasStations.value
                              .gasStationData!.stations![index];
                          return Obx(
                            () => RadioListTile<Station>(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: station,
                              groupValue:
                                  homeController.selectedGasStation.value,
                              onChanged: (Station? x) {
                                homeController.selectedGasStation.value = x!;
                                homeController.goToSelectedGasStation(
                                    homeController.selectedGasStation.value);
                                homeController.detailState.value = true;
                                homeController.searchState.value = false;
                              },
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    station.name!,
                                    style: GoogleFonts.roboto(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${homeController.getDistanceKm(station.latitude!, station.longitude!)} km away from you',
                                    style: GoogleFonts.roboto(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetNearbyStations(BuildContext context) {
    return BottomSheetContainer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Strings.nearbyStations,
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IgnorePointer(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      Strings.done,
                      style: GoogleFonts.roboto(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: homeController
                    .gasStations.value.gasStationData!.stations!.length,
                itemBuilder: ((BuildContext context, int index) {
                  Station station = homeController
                      .gasStations.value.gasStationData!.stations![index];
                  return Obx(
                    () => RadioListTile<Station>(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: station,
                      groupValue: homeController.selectedGasStation.value,
                      onChanged: (Station? x) {
                        homeController.selectedGasStation.value = x!;
                        homeController.goToSelectedGasStation(
                            homeController.selectedGasStation.value);
                        homeController.detailState.value = true;
                        homeController.searchState.value = false;
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            station.name!,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${homeController.getDistanceKm(station.latitude!, station.longitude!)} km away from you',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheetError(BuildContext context) {
    return BottomSheetContainer(
      child: Center(child: Text(Strings.error)),
    );
  }

  Widget bottomSheetLoading(BuildContext context) {
    return BottomSheetContainer(
      child: AdaptiveActivityIndicator(color: ColorName.deepPurple),
    );
  }
}
