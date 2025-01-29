import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter/common.dart';
import 'package:story_app_flutter/provider/pick_image_provider.dart';
import 'package:story_app_flutter/provider/post_story_provider.dart';
import 'package:story_app_flutter/provider/story_provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

class PostStoryScreen extends StatefulWidget {
  final Function() toHomeScreen;

  const PostStoryScreen({
    super.key,
    required this.toHomeScreen,
  });

  @override
  State<PostStoryScreen> createState() => _PostStoryScreenState();
}

class _PostStoryScreenState extends State<PostStoryScreen> {
  final _storyDescController = TextEditingController();
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);

  late GoogleMapController mapController;

  late final Set<Marker> markers = {};

  double? latitude;
  double? longitude;
  bool _isIncludeLocation = false;

  geo.Placemark? placemark;

  @override
  void dispose() {
    super.dispose();

    _storyDescController.dispose();
  }

  Future<void> setMapStyle() async {
    String style = await DefaultAssetBundle.of(context)
        .loadString('assets/style/map_style.json');

    // ignore: deprecated_member_use
    await mapController.setMapStyle(style);
  }

  @override
  void initState() {
    super.initState();
    _onMyLocationButtonPress();
  }

  @override
  Widget build(BuildContext context) {
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
          AppLocalizations.of(context)!.postStoryTitle,
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
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            context.watch<PickImageProvider>().imagePath == null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      color: const Color.fromARGB(31, 126, 126, 126),
                      height: MediaQuery.of(context).size.height / 2,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.photo,
                          size: 170,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                  )
                : _showImage(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.pink],
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () => _onCameraView(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                            child: SizedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(Icons.camera),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.cameraText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Product-Sans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15.0),
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.pink],
                            ),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: ElevatedButton(
                            onPressed: () => _onGalleryView(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                            ),
                            child: SizedBox(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(Icons.photo),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    AppLocalizations.of(context)!.galleryText,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Product-Sans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(width: 1, color: Colors.blue),
                    ),
                    child: TextFormField(
                      controller: _storyDescController,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.formDescHint,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 15.0,
                        ),
                        prefixIcon: const Icon(
                          Icons.description,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () => _storyDescController.clear(),
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.grey,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    AppLocalizations.of(context)!.mapInstruction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 5.0),
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
                              target: dicodingOffice,
                              zoom: 18,
                            ),
                            markers: markers,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            mapToolbarEnabled: false,
                            myLocationEnabled: true,
                            onMapCreated: (controller) async {
                              final info = await geo.placemarkFromCoordinates(
                                dicodingOffice.latitude,
                                dicodingOffice.longitude,
                              );

                              final place = info[0];
                              final street = place.street!;
                              final address =
                                  '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                              setState(() {
                                placemark = place;
                              });

                              defineMarker(dicodingOffice, street, address);

                              setState(() {
                                mapController = controller;
                              });
                            },
                            onLongPress: (LatLng latLng) {
                              _onLongPressGoogleMap(latLng);

                              setState(() {
                                latitude = latLng.latitude;
                                longitude = latLng.longitude;
                              });
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 8,
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
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: FloatingActionButton.small(
                            backgroundColor: Colors.pink,
                            foregroundColor: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(Icons.my_location),
                            onPressed: () async => _onMyLocationButtonPress(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Text(
                    AppLocalizations.of(context)!.includeLocationText,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  Switch.adaptive(
                    value: _isIncludeLocation,
                    onChanged: (value) {
                      setState(() {
                        _isIncludeLocation = !_isIncludeLocation;
                      });
                    },
                    activeTrackColor: Colors.blue,
                    activeColor: Colors.blueGrey,
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.pink],
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        _onPostStory(_storyDescController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                      ),
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            context.watch<PostStoryProvider>().isUploading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.btnPostTitle,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Product-Sans',
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                ],
              ),
            ),
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

  void _onLongPressGoogleMap(LatLng latLng) async {
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
      latitude = locationData.latitude;
      longitude = locationData.longitude;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  _onGalleryView() async {
    final provider = context.read<PickImageProvider>();

    final isMacOs = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOs || isLinux) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<PickImageProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isIos);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onPostStory(String desc) async {
    final postProvider = context.read<PostStoryProvider>();
    final storyprovider = context.read<StoryProvider>();

    final provider = context.read<PickImageProvider>();
    final imagePath = provider.imagePath;
    final imageFile = provider.imageFile;

    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (imagePath == null || imageFile == null || desc.isEmpty) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Center(
            child:
                Text(AppLocalizations.of(context)!.postStoryEmptyFieldMessage),
          ),
        ),
      );
    } else {
      final fileName = imageFile.name;
      final bytes = await imageFile.readAsBytes();

      final newBytes = await postProvider.compressImage(bytes);

      double? lat = _isIncludeLocation ? latitude : null;
      double? lng = _isIncludeLocation ? longitude : null;

      await postProvider
          .postStory(newBytes, fileName, _storyDescController.text, lat, lng)
          .then((value) {
        if (postProvider.isPosted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Center(
                child: Text(AppLocalizations.of(context)!.postStorySuccess),
              ),
            ),
          );

          if (postProvider.postResponse != null) {
            provider.imageFile = null;
            provider.imagePath = null;

            storyprovider.refreshStories();
            widget.toHomeScreen();
          }
        } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(
              content: Center(
                child: Text(AppLocalizations.of(context)!.postStoryFailed),
              ),
            ),
          );
        }
      });
    }
  }

  Widget _showImage() {
    final imagePath = context.read<PickImageProvider>().imagePath;

    return Padding(
      padding: const EdgeInsets.only(bottom: 25.0),
      child: kIsWeb
          ? Image.network(
              imagePath.toString(),
              fit: BoxFit.contain,
            )
          : Image.file(
              File(imagePath.toString()),
              fit: BoxFit.contain,
            ),
    );
  }
}
