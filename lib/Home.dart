import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

 double? long;
  double? lat;

  Completer<GoogleMapController> _controller=Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.65192994,73.08141522),
    zoom: 16.4746,
  );
  List<Marker> _marker=[  Marker (markerId:MarkerId('1'),
      position: LatLng(33.65192994,73.08141522),
      infoWindow:InfoWindow(title: 'My Current Location')
  )];
  /*List<Marker> _list=[

  ];*/
@override
  /*void initState() {
  _marker.addAll(_list );
    // TODO: implement initState
    super.initState();
  }*/
  @override

  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: GoogleMap(initialCameraPosition: _kGooglePlex,
          //mapType: MapType.normal,
          //mapType: MapType.satellite,
          mapType: MapType.hybrid,
          compassEnabled: true,
          myLocationEnabled: true,
          markers: Set<Marker>.of(_marker),
          zoomControlsEnabled: false,

          onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation:0,backgroundColor: Colors.transparent,
        child: Icon(Icons.my_location),
      onPressed: ()async{
      //  GoogleMapController controller=await _controller.future;
       // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(33.55058919,72.82486951),zoom: 16)));
        getLocation().then((value) async{
          long=value.longitude;
          lat=value.latitude;
          print(value.latitude.toString()+""+value.longitude.toString());
          _marker.add(Marker(markerId: MarkerId("2"),
              position: LatLng(value.latitude,value.longitude),
              infoWindow: InfoWindow(title: "My current location")));

          CameraPosition cameraPosition=CameraPosition(
              zoom: 30,
              target:LatLng(lat!,long!) );
          final GoogleMapController controller=await _controller.future;
          controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        });
         setState(() {


         
        });
      },),
    );
  }

Future<Position> getLocation()async{
  await Geolocator.requestPermission().then((value) {
  }).onError((error, stackTrace) {
    print("error"+error.toString());
  });
  return await Geolocator.getCurrentPosition();
}





}
