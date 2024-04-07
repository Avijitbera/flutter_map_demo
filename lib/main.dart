import 'package:flutter/material.dart';
import 'package:flutter_map_demo/map.screen.dart';
import 'package:google_maps_widget/google_maps_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MapScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final mapsWidgetController = GlobalKey<GoogleMapsWidgetState>();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: GoogleMapsWidget(
        key: mapsWidgetController,
    apiKey: "AIzaSyAXARVkTfuYEUVT6f0qo2WGx3E3yoePMdc",
    sourceLatLng: LatLng(40.484000837597925, -3.369978368282318),
    destinationLatLng: LatLng(40.48017307700204, -3.3618026599287987),
    routeWidth: 2,
                  sourceMarkerIconInfo: MarkerIconInfo(
                    infoWindowTitle: "This is source name",
                    onTapInfoWindow: (_) {
                      print("Tapped on source info window");
                    },
                    assetPath: "assets/images/location_1.png",
                  ),
                  destinationMarkerIconInfo: MarkerIconInfo(
                    assetPath: "assets/images/location_2.png",
                  ),
                  driverMarkerIconInfo: MarkerIconInfo(
                    infoWindowTitle: "Alex",
                    assetPath: "assets/images/car.png",
                    onTapMarker: (currentLocation) {
                      print("Driver is currently at $currentLocation");
                    },
                    assetMarkerSize: Size.square(100),
                    rotation: 90,
                  ),
                  updatePolylinesOnDriverLocUpdate: true,
                  onPolylineUpdate: (_) {
                    print("Polyline updated");
                  },
                  // mock stream
                  // driverCoordinatesStream: Stream.periodic(
                  //   Duration(milliseconds: 500),
                  //   (i) => LatLng(
                  //     40.47747872288886 + i / 10000,
                  //     -3.368043154478073 - i / 10000,
                  //   ),
                  // ),
                  totalTimeCallback: (time) => print(time),
                  totalDistanceCallback: (distance) => print(distance),
),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
