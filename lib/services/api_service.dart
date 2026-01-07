import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Using the same backend URL as ecommerce app
  static const String baseUrl = 'http://localhost:8001/backend/api'; 
  // NOTE: For Android Emulator use 'http://10.0.2.2:8001/backend/api'
  // For iOS Simulator use 'http://127.0.0.1:8001/backend/api'

  Future<String?> login(String email, String password) async {
    try {
      print('Attempting driver login to: $baseUrl/drivers/login.php');
      final response = await http.post(
        Uri.parse('$baseUrl/drivers/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        return token;
      } else {
        print('Login failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<List<dynamic>> getAssignedOrders() async {
    print('=== getAssignedOrders called ===');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('Token: ${token != null ? "EXISTS" : "NULL"}');
    
    if (token == null) {
      print('No token found, returning empty list');
      return [];
    }

    try {
      final url = '$baseUrl/drivers/orders.php';
      print('Fetching orders from: $url');
      
      final response = await http.get(
        Uri.parse(url), 
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded data: $data');
        final orders = data['orders'] as List;
        print('Number of orders: ${orders.length}');
        return orders;
      } else {
        print('Failed with status ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<bool> updateOrderStatus(int orderId, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/drivers/update_status.php?order_id=$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'status': status}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating status: $e');
      return false;
    }
  }

  Future<bool> updateDriverLocation(double lat, double lng) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/drivers/update_location.php'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({'lat': lat, 'lng': lng}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating location: $e');
      return false;
    }
  }
}
