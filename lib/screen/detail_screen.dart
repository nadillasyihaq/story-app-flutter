import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:story_app_flutter/common.dart';
import 'package:story_app_flutter/data/model/story.dart';
import 'package:story_app_flutter/utils/date_time_format.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:story_app_flutter/widget/placemark_widget.dart';

class DetailScreen extends StatefulWidget {
  final Story storyData;

  const DetailScreen({
    super.key,
    required this.storyData,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final unand = const LatLng(-6.8957473, 107.6337669);

  late GoogleMapController mapController;

  late final Set<Marker> markers = {};

  geo.Placemark? placemark;

  Future<void> setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/style/map_style.json');

    // ignore: deprecated_member_use
    await mapController.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    double? lat = widget.storyData.lat;
    double? lng = widget.storyData.lon;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.detailPageTitle,
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.white,
            fontFamily: 'Product-Sans',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    child: Image.asset(
                      'assets/images/user_blue.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.storyData.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      Text(
                        dateTimeFormat(widget.storyData.createdAt, context),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(115, 25, 18, 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            FadeInImage.assetNetwork(
              width: MediaQuery.of(context).size.width,
              placeholder: 'assets/images/loading.gif',
              image: widget.storyData.photoUrl,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 5.0),
                  Text(
                    AppLocalizations.of(context)!.descText,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontFamily: 'Product-Sans',
                    ),
                  ),
                  Text(
                    widget.storyData.description,
                    style: const TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppLocalizations.of(context)!.locationCoordinate,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Product-Sans',
                        ),
                      ),
                      Text(
                        (lat != null) ? "Lat: $lat" : "-",
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        (lng != null) ? "Lng: $lng" : "-",
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black26,
                        width: 3,
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 1.5,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: (lat != null && lng != null)
                                  ? LatLng(lat, lng)
                                  : unand,
                              zoom: 18,
                            ),
                            markers: markers,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            myLocationEnabled: true,
                            onMapCreated: (controller) async {
                              if (lat != null && lng != null) {
                                final info = await geo.placemarkFromCoordinates(
                                  lat,
                                  lng,
                                );
                                final place = info[0];
                                final street = place.street!;
                                final address =
                                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                                setState(() {
                                  placemark = place;
                                });

                                defineMarker(LatLng(lat, lng), street, address);
                              }

                              setState(() {
                                mapController = controller;
                              });

                              await setMapStyle();
                            },
                          ),
                        ),
                        if (placemark == null)
                          const SizedBox()
                        else
                          Positioned(
                            bottom: 16,
                            right: 16,
                            left: 16,
                            child: PlacemarkWidget(
                              placemark: placemark!,
                            ),
                          ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Column(
                            children: <Widget>[
                              FloatingActionButton.small(
                                onPressed: () {
                                  mapController.animateCamera(
                                    CameraUpdate.zoomIn(),
                                  );
                                },
                                heroTag: "zoom-in",
                                backgroundColor: Colors.pink,
                                foregroundColor: Colors.white,
                                shape: const CircleBorder(),
                                child: const Icon(
                                  Icons.add,
                                ),
                              ),
                              FloatingActionButton.small(
                                onPressed: () {
                                  mapController.animateCamera(
                                    CameraUpdate.zoomOut(),
                                  );
                                },
                                heroTag: "zoom-out",
                                backgroundColor: Colors.pink,
                                foregroundColor: Colors.white,
                                shape: const CircleBorder(),
                                child: const Icon(
                                  Icons.remove,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void _onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info = await geo.placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}
