import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'order_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final ApiService _apiService = ApiService();
  
  // Shared state
  List<dynamic> _orders = [];
  bool _isLoading = true;
  bool _isOnline = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _refreshTimer = Timer.periodic(Duration(seconds: 15), (timer) {
      if (_isOnline && _selectedIndex == 0) _loadOrders(silent: true);
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadOrders({bool silent = false}) async {
    if (!mounted) return;
    if (!silent) setState(() => _isLoading = true);
    try {
      final orders = await _apiService.getAssignedOrders();
      if (!mounted) return;
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FD),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildTasksView(),
          _buildWalletView(),
          _buildProfileView(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: Offset(0, -5))],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: Color(0xFF0F172A),
        unselectedItemColor: Colors.grey[400],
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 10, letterSpacing: 0.5),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.delivery_dining_rounded), label: 'TASKS'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'EARNINGS'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'PROFILE'),
        ],
      ),
    );
  }

  // --- VIEW 1: TASKS ---
  Widget _buildTasksView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar('PARTNER PORTAL'),
        SliverToBoxAdapter(child: _buildShiftSummary()),
        _isLoading 
          ? SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
          : _orders.isEmpty 
              ? _buildEmptyState()
              : SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildOrderCard(_orders[index]),
                      childCount: _orders.length,
                    ),
                  ),
                ),
      ],
    );
  }

  // --- VIEW 2: WALLET ---
  Widget _buildWalletView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar('MY EARNINGS'),
        SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                _buildEarningsCard(),
                SizedBox(height: 24),
                Row(
                  children: [
                    Text('RECENT ACTIVITY', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1, color: Colors.blueGrey[400])),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildHistoryItem(index),
            childCount: 5,
          ),
        ),
      ],
    );
  }

  // --- VIEW 3: PROFILE ---
  Widget _buildProfileView() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar('MY PROFILE'),
        SliverPadding(
          padding: EdgeInsets.all(20),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                CircleAvatar(radius: 50, backgroundColor: Color(0xFF0F172A), child: Icon(Icons.person, size: 50, color: Colors.white)),
                SizedBox(height: 16),
                Text('John Partner', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
                Text('Vehicle: Toyota Prius (WN68 XYZ)', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600)),
                SizedBox(height: 30),
                _buildProfileOption(Icons.star_rounded, 'My Rating', '4.95 (Expert)'),
                _buildProfileOption(Icons.history_rounded, 'Delivery History', '142 Tasks'),
                _buildProfileOption(Icons.settings_rounded, 'App Settings', 'Dark Mode, Audio'),
                _buildProfileOption(Icons.help_outline_rounded, 'Support', 'Live Chat'),
                SizedBox(height: 20),
                TextButton(
                  onPressed: _logout,
                  child: Text('LOG OUT', style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // --- REUSABLE COMPONENTS ---
  Widget _buildSliverAppBar(String subTitle) {
    return SliverAppBar(
      expandedHeight: 120, pinned: true, elevation: 0,
      backgroundColor: Color(0xFF0F172A), automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 20, bottom: 20, right: 20),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Allen\'s Mart', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                Text(subTitle, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.blue[300], letterSpacing: 2)),
              ],
            ),
            if (_selectedIndex == 0) _buildOnlineStatusIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineStatusIndicator() {
    return GestureDetector(
      onTap: () => setState(() => _isOnline = !_isOnline),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isOnline ? Colors.green[600] : Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
            SizedBox(width: 6),
            Text(_isOnline ? 'ONLINE' : 'OFFLINE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildShiftSummary() {
    return Container(
      margin: EdgeInsets.all(20), padding: EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSummaryItem('IDLE', '32m', Icons.timer_outlined, Colors.blue),
          _buildSummaryItem('DONE', '12', Icons.task_alt_rounded, Colors.green),
          _buildSummaryItem('PAY', '£142', Icons.wallet_rounded, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon, Color color) {
    return Column(children: [
      Icon(icon, color: color, size: 20),
      SizedBox(height: 4),
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
    ]);
  }

  Widget _buildOrderCard(dynamic order) {
    bool isOut = order['status'] == 'out_for_delivery';
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: order))).then((_) => _loadOrders()),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(gradient: LinearGradient(colors: isOut ? [Colors.indigo[400]!, Colors.indigo[700]!] : [Colors.orange[400]!, Colors.orange[600]!]), borderRadius: BorderRadius.circular(16)), child: Icon(Icons.shopping_bag_rounded, color: Colors.white)),
              SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Order #${order['id']}', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                Text(isOut ? 'CONTINUE DELIVERY' : 'START TASK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: isOut ? Colors.indigo : Colors.orange)),
              ])),
              Text('£${order['total_amount']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.green[700])),
            ]),
            SizedBox(height: 16),
            Container(width: double.infinity, height: 48, decoration: BoxDecoration(color: isOut ? Color(0xFF0F172A) : Colors.indigo[50], borderRadius: BorderRadius.circular(16)), child: Center(child: Text(isOut ? 'GO TO TRACKER' : 'ACCEPT', style: TextStyle(color: isOut ? Colors.white : Colors.indigo, fontWeight: FontWeight.w900)))),
          ]),
        ),
      ),
    );
  }

  Widget _buildEarningsCard() {
    return Container(
      width: double.infinity, padding: EdgeInsets.all(30),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0F172A), Color(0xFF1E293B)]), borderRadius: BorderRadius.circular(32)),
      child: Column(children: [
        Text('TOTAL BALANCE', style: TextStyle(color: Colors.blue[300], fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
        SizedBox(height: 10),
        Text('£1,242.50', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900)),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildBalanceStat('Today', '+£42.00'),
          Container(width: 1, height: 30, color: Colors.white10),
          _buildBalanceStat('Week', '+£280.00'),
        ]),
      ]),
    );
  }

  Widget _buildBalanceStat(String label, String val) {
    return Column(children: [
      Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.bold)),
      Text(val, style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.w800)),
    ]);
  }

  Widget _buildHistoryItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green[50], shape: BoxShape.circle), child: Icon(Icons.check_rounded, color: Colors.green, size: 16)),
        SizedBox(width: 15),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Delivery #84${index}', style: TextStyle(fontWeight: FontWeight.w800)),
          Text('Completed yesterday', style: TextStyle(color: Colors.grey, fontSize: 11)),
        ])),
        Text('+£4.20', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.green[700])),
      ]),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, String val) {
    return Container(
      margin: EdgeInsets.only(bottom: 15), padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [
        Icon(icon, color: Color(0xFF0F172A)),
        SizedBox(width: 15),
        Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.w700))),
        Text(val, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
        Icon(Icons.chevron_right_rounded, color: Colors.grey[300]),
      ]),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(child: Center(child: Text('Looking for tasks...')));
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
