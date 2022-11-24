import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as ll;
import 'package:location/location.dart';
class Property_search_screen extends StatefulWidget {
  const Property_search_screen({Key? key}) : super(key: key);

  @override
  State<Property_search_screen> createState() => _Property_search_screenState();
}

class _Property_search_screenState extends State<Property_search_screen> {
  String? _chosenValue;
  var log;
  var lat;
  LatLng? latlong;
  CameraPosition cm =  CameraPosition(target: LatLng(31.5204, 74.3587),zoom: 25);



  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    current();
    lis.addAll(marker);
 _polyline.add(
        Polyline(polylineId: PolylineId('1'),
          points: Polylinelist,
          color: Colors.red,
          width: 3,));}
  late LatLng first;
  Uint8List? markerImage;
  List<LatLng> Polylinelist = [];
  List<Marker> marker = [];
  List<Marker> lis = [];
  var index = 8;
  final Set<Polyline> _polyline={};

  Future<Uint8List>  getBytesFromAsset(String path, int width)async{
    ByteData data =await rootBundle.load(path);
    ui.Codec codec =await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: width);
    ui.FrameInfo fi=await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
  void _onAddMarkerButtonPressed(LatLng latlang)async {

    final Uint8List markerIcon = await getBytesFromAsset('assets/icons/marker1.png',80);

    setState(() {
      marker.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId('$index'),
        position: latlang,
        infoWindow: InfoWindow(
          title: 'tap location',
          //  snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ));


      Polylinelist.add(latlang);



      index++;
      print(marker.length.toString());
    });
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
  Container(color:Color(0xffFFF4F4),height: 70.h,
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
    GestureDetector(onTap:(){},child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(//color: Colors.white,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.w)
          ),child: Icon(Icons.arrow_back_ios_outlined,size: 30,color: const Color(0xff213E50))),
    ),),
      Text("Dashboard",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
      GestureDetector(onTap:(){},child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(//color: Colors.white,
           decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.w)
        ),
            child: Icon(Icons.logout,size: 30,color: const Color(0xff213E50))),
      ),),
    ],
    ),
  ),
            Expanded(
              child: Stack(children: [

                GoogleMap(initialCameraPosition: cm,
                  polylines: _polyline,
                  mapType: MapType.normal,

                  onMapCreated: (GoogleMapController controller){
                    _controller.complete(controller);
                  },
zoomControlsEnabled: false,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: true,
                  markers:Set<Marker>.of(marker),
                  onTap: (latlang){
                    print("onclick");

                    _onAddMarkerButtonPressed(latlang);
                  },



                ) ,



                Positioned(top: 10.h,left: 70.w,
                  child: Container(height: 100.h,width: 216.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(13.w)
                    ),
                      color: Colors.white,
                    ),
                    child: Column(children: [
                      SizedBox(height: 15.h,),
                      Row(
                        children: [
                          SizedBox(width: 20.w,height: 20.h,),
                          Text("Map",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16.sp),),
                          Spacer()
                        ],
                      ),
SizedBox(height: 10.h,),
                      Container(width: 170.w,color: Colors.grey.shade50,
                        child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            focusColor:Colors.white,
                            value: _chosenValue,
                            //elevation: 5,
                            style: TextStyle(color: Colors.white),
                            iconEnabledColor:Colors.black,
                            items: <String>[
                              'OSM',
                              'PST',
                              'RTMDPT',

                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,style:TextStyle(color:Colors.black),),
                              );
                            }).toList(),
                            hint:Text(
                              "   Please select",
                              style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),

                            onChanged: ( value) {
                              setState(() {
                                _chosenValue = value;
                              });
                            },
                             ),
                        ),
                      ),
                    ],),
                  ),
                )
              ],

              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation:0,backgroundColor: Colors.grey.shade500,
        child: Icon(Icons.location_off_rounded),
        onPressed: ()async{

          setState(() {
            if(marker.length>1) {
              marker.removeLast();
            }
            if(Polylinelist.length>1) {
            Polylinelist.removeLast();}
          });

        },),
    );
  }
 void current()async{

    getlocation().then((value) async{
      debugPrint(''+value.latitude.toString());
      final Uint8List markerIcon = await getBytesFromAsset('assets/icons/start.png',50);
setState(() {
        Polylinelist.add(LatLng(value.latitude, value.longitude),);
marker.add(
            Marker(
              markerId: MarkerId('1'),
              position: LatLng(value.latitude,value.longitude),
              infoWindow: InfoWindow(title: 'usercurrent postion'),
              icon: BitmapDescriptor.fromBytes(markerIcon),

            ));});
      CameraPosition campos = CameraPosition(target: LatLng(value.latitude,value.longitude),zoom:14);

      GoogleMapController controller =await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(campos));});
  }
  Future<Position> getlocation() async{
    await Geolocator.requestPermission().then((value){}).onError((error, stackTrace) {});
    return await Geolocator.getCurrentPosition();




  }









}
