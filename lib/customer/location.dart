import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class PickLocationScreen extends StatefulWidget {
  final TextEditingController addressController;

  PickLocationScreen(this.addressController);

  @override
  _PickLocationScreenState createState() => _PickLocationScreenState();
}

// const kGoogleApiKey = 'AIzaSyD-bzKamIyjcGjfjchgzRF9RtFqdak8Es8';
// final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _PickLocationScreenState extends State<PickLocationScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _selectedLocation = LatLng(0, 0); // Vị trí mặc định
  }

  @override
  void dispose() {
    // Giải phóng tài nguyên khi widget bị hủy
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });
  }

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _saveSelectedLocation() {
    if (_selectedLocation != null) {
      // Kiểm tra xem `_mapController` có khả dụng hay không
      if (_mapController != null) {
        final selectedLocation =
            'Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}';
        widget.addressController.text = selectedLocation;
        Navigator.pop(context); // Đóng màn hình bản đồ
      }
    }
  }

  void _goToLocation(String address) async {
    try {
      List<geocoding.Location> locations =
          await geocoding.locationFromAddress(address);

      if (locations.isNotEmpty) {
        geocoding.Location location = locations[0];
        LatLng latLng = LatLng(location.latitude, location.longitude);

        // Move the map to the searched location
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(latLng, 15),
        );
      } else {
        print('Không tìm thấy địa chỉ.');
      }
    } catch (e) {
      print('Lỗi: $e');
    }
  }

  // static const CameraPosition initialCameraPosition =
  //     CameraPosition(target: LatLng(37.42796, -122.08574), zoom: 14.0);

  // Set<Marker> markersList = {};

  // late GoogleMapController googleMapController;

  // final Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Chọn vị trí trên bản đồ'),
          actions: <Widget>[
            if (_selectedLocation != null)
              IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  // Kiểm tra xem `_mapController` có khả dụng hay không
                  if (_mapController != null) {
                    _saveSelectedLocation();
                  }
                },
              ),
          ],
        ),
        body: Column(children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Nhập địa chỉ',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _goToLocation(_searchController.text);
            },
            child: Text('Tìm Kiếm'),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onMapTap,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation ?? LatLng(0, 0),
                zoom: 10,
              ),
              markers: _selectedLocation != null
                  ? {
                      Marker(
                        markerId: MarkerId('selectedLocation'),
                        position: _selectedLocation!,
                      ),
                    }
                  : Set<Marker>(),
            ),
          ),
        ]));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     key: homeScaffoldKey,
  //     appBar: AppBar(
  //       title: const Text("Google Search Places"),
  //     ),
  //     body: Stack(
  //       children: [
  //         GoogleMap(
  //           initialCameraPosition: initialCameraPosition,
  //           markers: markersList,
  //           mapType: MapType.normal,
  //           onMapCreated: (GoogleMapController controller) {
  //             googleMapController = controller;
  //           },
  //         ),
  //         ElevatedButton(
  //             onPressed: _handlePressButton, child: const Text("Search Places"))
  //       ],
  //     ),
  //   );
  // }

  // Future<void> _handlePressButton() async {
  //   Prediction? p = await PlacesAutocomplete.show(
  //       context: context,
  //       apiKey: kGoogleApiKey,
  //       onError: onError,
  //       mode: _mode,
  //       language: 'en',
  //       strictbounds: false,
  //       types: [""],
  //       decoration: InputDecoration(
  //           hintText: 'Search',
  //           focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(20),
  //               borderSide: BorderSide(color: Colors.white))),
  //       components: [
  //         Component(Component.country, "pk"),
  //         Component(Component.country, "usa"),
  //         Component(Component.country, "vn")
  //       ]);

  //   displayPrediction(p!, homeScaffoldKey.currentState);
  // }

  // void onError(PlacesAutocompleteResponse response) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     elevation: 0,
  //     behavior: SnackBarBehavior.floating,
  //     backgroundColor: Colors.transparent,
  //     content: AwesomeSnackbarContent(
  //       title: 'Message',
  //       message: response.errorMessage!,
  //       contentType: ContentType.failure,
  //     ),
  //   ));

  //   // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  // }

  // Future<void> displayPrediction(
  //     Prediction p, ScaffoldState? currentState) async {
  //   GoogleMapsPlaces places = GoogleMapsPlaces(
  //       apiKey: kGoogleApiKey,
  //       apiHeaders: await const GoogleApiHeaders().getHeaders());

  //   PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

  //   final lat = detail.result.geometry!.location.lat;
  //   final lng = detail.result.geometry!.location.lng;

  //   markersList.clear();
  //   markersList.add(Marker(
  //       markerId: const MarkerId("0"),
  //       position: LatLng(lat, lng),
  //       infoWindow: InfoWindow(title: detail.result.name)));

  //   setState(() {});

  //   googleMapController
  //       .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  // }
}
