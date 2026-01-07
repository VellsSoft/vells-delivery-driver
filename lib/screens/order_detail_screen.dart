import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../services/api_service.dart';
import 'dart:async';

class OrderDetailScreen extends StatefulWidget {
  final dynamic order;
  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final ApiService _apiService = ApiService();
  final MapController _mapController = MapController();
  
  late LatLng _deliveryLocation;
  LatLng? _currentLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isTrackingLocation = false;
  String _currentStep = 'on_the_way';
  int _etaMinutes = 15;
  bool _isArrived = false;
  bool _photoTaken = false;

  @override
  void initState() {
    super.initState();
    double lat = widget.order['lat'] ?? 51.5074;
    double lng = widget.order['lng'] ?? -0.1278;
    _deliveryLocation = LatLng(lat, lng);
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    _startLocationTracking();
  }

  void _startLocationTracking() {
    setState(() => _isTrackingLocation = true);
    const LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 5);

    _positionStreamSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        _currentLocation = newLocation;
        _updateETAAndStep();
      });
      _mapController.move(newLocation, _mapController.camera.zoom);
      _apiService.updateDriverLocation(position.latitude, position.longitude);
    });
  }

  void _updateETAAndStep() {
    if (_currentLocation == null) return;
    final dist = Geolocator.distanceBetween(
      _currentLocation!.latitude, _currentLocation!.longitude,
      _deliveryLocation.latitude, _deliveryLocation.longitude,
    );
    
    setState(() {
      _etaMinutes = (dist / 300).ceil(); // Simple simulation: 1 min per 300m
      if (dist < 50) {
        _currentStep = 'arrived';
        _isArrived = true;
      } else if (dist < 500) {
        _currentStep = 'nearby';
        _isArrived = false;
      } else {
        _currentStep = 'on_the_way';
        _isArrived = false;
      }
    });
  }

  void _simulatePhotoCapture() {
    setState(() => _photoTaken = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📸 Photo Captured! Evidence attached to Order.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      body: Stack(
        children: [
          _buildMap(),
          _buildTopHUD(),
          _buildBottomActionCard(),
          _buildFloatingChat(),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(initialCenter: _deliveryLocation, initialZoom: 15.0),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c', 'd'],
        ),
        PolylineLayer(
          polylines: [
            if (_currentLocation != null)
              Polyline(points: [_currentLocation!, _deliveryLocation], strokeWidth: 5.0, color: Colors.indigo[400]!),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(point: _deliveryLocation, width: 60, height: 60, child: Icon(Icons.location_on_rounded, color: Colors.redAccent, size: 40)),
            if (_currentLocation != null)
              Marker(
                point: _currentLocation!, width: 40, height: 40,
                child: Center(
                  child: Container(
                    width: 16, height: 16,
                    decoration: BoxDecoration(
                      color: Colors.indigo[400], shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.5), blurRadius: 10)],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopHUD() {
    return Positioned(
      top: 50, left: 20, right: 20,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Color(0xFF1E293B).withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20, offset: Offset(0, 10))],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.indigo[400]!.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(Icons.navigation_rounded, color: Colors.indigo[300], size: 24),
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('ESTIMATED ARRIVAL', style: TextStyle(color: Colors.blue[200], fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                Row(
                  children: [
                    Text(_isArrived ? 'ARRIVED' : '$_etaMinutes MIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                    if (!_isArrived) Text(' • 4.2 km', style: TextStyle(color: Colors.blueGrey[400], fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],),
            ),
            IconButton(icon: Icon(Icons.close_rounded, color: Colors.white54), onPressed: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingChat() {
    return Positioned(
      bottom: 300, right: 20,
      child: FloatingActionButton(
        onPressed: () => _showChatMockup(),
        backgroundColor: Colors.indigo[600],
        child: Icon(Icons.chat_bubble_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomActionCard() {
    return Positioned(
      bottom: 40, left: 20, right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 40)],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(children: [
                Row(children: [
                  CircleAvatar(backgroundColor: Color(0xFF0F172A), child: Icon(Icons.person, color: Colors.white)),
                  SizedBox(width: 15),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.order['customer_name'] ?? 'Alex Johnson', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                    Text('LEAVE AT DOORSTEP', style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w900, fontSize: 10)),
                  ])),
                  IconButton(icon: Icon(Icons.phone_in_talk_rounded, color: Colors.indigo[700]), onPressed: () {}),
                ]),
                SizedBox(height: 20),
                if (_isArrived && !_photoTaken) 
                  GestureDetector(
                    onTap: _simulatePhotoCapture,
                    child: Container(
                      width: double.infinity, height: 100,
                      decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.indigo[100]!, width: 2, style: BorderStyle.solid)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.add_a_photo_rounded, color: Colors.indigo),
                        SizedBox(height: 8),
                        Text('TAKE PROOF OF DELIVERY PHOTO', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900, fontSize: 11)),
                      ]),
                    ),
                  )
                else if (_photoTaken)
                  Container(
                    width: double.infinity, padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
                    child: Row(children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 10),
                      Text('POD PHOTO CAPTURED', style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.w900, fontSize: 12)),
                    ]),
                  )
                else
                  Container(
                    width: double.infinity, padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(16)),
                    child: Text(widget.order['delivery_address'] ?? 'Loading...', style: TextStyle(fontSize: 13, color: Colors.blueGrey[800], fontWeight: FontWeight.w600)),
                  ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: (_isArrived && _photoTaken) || !_isArrived 
                    ? () => _isArrived ? _completeDelivery() : _mapController.move(_deliveryLocation, 16)
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isArrived ? Colors.green : Color(0xFF0F172A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    disabledBackgroundColor: Colors.grey[300],
                  ),
                  child: Text(_isArrived ? 'CONFIRM HAND-OFF' : 'CENTER ON TARGET', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeDelivery() {
    _apiService.updateOrderStatus(widget.order['id'], 'delivered').then((_) => Navigator.pop(context));
  }

  void _showChatMockup() {
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(children: [
          Container(margin: EdgeInsets.symmetric(vertical: 12), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(padding: EdgeInsets.all(20), child: Text('SUPPORT CHAT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5))),
          Expanded(child: Center(child: Text('Connecting to Store Dispatch...', style: TextStyle(color: Colors.grey)))),
          Padding(padding: EdgeInsets.all(20), child: TextField(decoration: InputDecoration(hintText: 'Type your message...', border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))))),
        ]),
      ),
    );
  }
}
