

class PlaceModel {
  String address;
  double lat;
  double lng;

  PlaceModel({
    required this.address,
    required this.lat,
    required this.lng
  });
}

class MarkerModel {
  String address;
  double lat;
  double lng;
  MarkerType type;

  MarkerModel({
    required this.address, required this.lat, required this.lng, required this.type
  });
}

enum MarkerType { MY, FROM, TO }