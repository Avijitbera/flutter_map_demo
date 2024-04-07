import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map_demo/data.model.dart';

import 'package:flutter_map_demo/search.dialog.dart';

import 'package:geolocator/geolocator.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  Position? _position;
  Set<Marker> markers = {};

  final LocationSettings locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  List<MarkerModel> makers = [];




  
 

late AnimationController animationController;
late Animation animation;
List<LatLng> routeCoords = [];

  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyAXARVkTfuYEUVT6f0qo2WGx3E3yoePMdc");
  final List<Polyline> polyline = [];
  GoogleMapController? _googleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );


  @override
  void dispose() {
    _googleMapController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }
      
  @override
  void initState() {
    
  super.initState();
 
    Future(()async{
      var _data = await _determinePosition();
      if(_data != null){
        setState(() {
          _position = _data;
         
         
          makers.add(MarkerModel(address: "", lat: _data.latitude, lng: _data.longitude, type: MarkerType.MY));
        });
      
        
        listonLocation();
      }
    });

  }

  computePath(PlaceModel from, PlaceModel to)async{
   List<LatLng> _d = [];
    LatLng origin = new LatLng(from.lat, from.lng);
    LatLng end = new LatLng(to.lat, to.lng);
    var _data = await googleMapPolyline.getCoordinatesWithLocation(origin: origin, destination: end, mode: RouteMode.driving);
    _d.addAll(_data!);
    routeCoords.addAll(_data);
    animationController = AnimationController(
     duration: Duration(seconds: 3),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward(from: 0);
    setState(() {
     polyline.add(Polyline(polylineId: PolylineId("id"),
        color: Colors.blue,
        points: routeCoords));
    });
   


   
  }


  void listonLocation(){
    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
    (Position? position) {
      if(position != null && _googleMapController != null){
        setState(() {
          _googleMapController!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_position!.latitude, _position!.longitude),
          zoom: 18.0, bearing: 120.0)));
        });
      }
      print(position);
        print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }


  Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
     
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
   
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.');
  } 

 
  return await Geolocator.getCurrentPosition();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => SearchDialog(onSubmit: (from, to){
          
         
          markers.add(Marker(markerId: MarkerId(from.address),
          position: LatLng(from.lat, from.lng),
          visible: true,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
          infoWindow: InfoWindow(title: from.address,
          )));

          markers.add(Marker(markerId: MarkerId(to.address),

          position: LatLng(to.lat, to.lng),
          visible: true,
          infoWindow: InfoWindow(title: to.address)));
          _googleMapController!.animateCamera(
            CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(from.lat, from.lng),
            zoom: 10))
          );
          // getDirection(from.address, to.address);
          computePath(from, to);

          setState(() {
            
          });
        }),
        fullscreenDialog: true));
      },
      child:  Icon(Icons.search),),

     body:  GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        initialCameraPosition:_kGooglePlex,
        markers: markers,
        polylines: Set.from(polyline),
        onMapCreated: (GoogleMapController controller) {
          
          _googleMapController = controller;
        },
      )
    
    );

  }
}

