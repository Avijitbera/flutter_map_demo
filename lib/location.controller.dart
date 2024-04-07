

import 'package:dio/dio.dart';
import 'package:flutter_map_demo/data.model.dart';

String _key = "";

getDirection(String from, String to)async{
  var result = await Dio().get("https://maps.googleapis.com/maps/api/directions/json?destination=${to}&origin=${from}&key=${_key}");
  print(result);
}

Future<PlaceModel?> findDetails(String input)async{
  var result = await Dio().get("https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address%2Cname%2Crating%2Copening_hours%2Cgeometry&input=${input}&inputtype=textquery&key=${_key}");
  print(result);
  if(result.data['status'] == "OK"){
   var place = PlaceModel(address: input,
    lat: result.data['candidates'][0]['geometry']['location']['lat'],
    lng: result.data['candidates'][0]['geometry']['location']['lng']);
    return place;
  }else{
    return null;
  }
}


Future<List<String>> searchLocality(String input)async{
  try {
    var result = await Dio().get("https://maps.googleapis.com/maps/api/place/autocomplete/json?input=${input}&types=geocode&key=${_key}");
    if(result.data['status'] == "OK"){
      List<String> data = [];
      for(var item in result.data['predictions']){
        data.add(item['description']);
      }
      return data;
    }else{
      return [];
    }
  } catch (e) {
    return [];
  }
}

