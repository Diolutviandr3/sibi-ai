import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar_navigation.dart';
import 'dashboard/dashboard_screen.dart';
import 'session/live_session_screen.dart';
import 'server/server_management_screen.dart';
import 'settings/settings_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const LiveSessionScreen(),
    const ServerManagementScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 1100;
    final bool isTablet = size.width > 700 && size.width <= 1100;
    final bool isMobile = size.width <= 700;

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.bolt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('SIBI-AI'),
                ],
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          // Main Screen Area (Left side)
          Expanded(
            child: Container(
              color: AppTheme.background,
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ),

          // Sidebar Navigation (Right side)
          if (isDesktop)
            SidebarNavigation(
              currentIndex: _currentIndex,
              onTabSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              isCollapsed: _currentIndex == 1,
            )
          else if (isTablet)
            SidebarNavigation(
              currentIndex: _currentIndex,
              onTabSelected: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              isCollapsed: true,
            ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.accent,
              unselectedItemColor: AppTheme.textSecondary,
              backgroundColor: Colors.white,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.sensors),
                  activeIcon: Icon(Icons.sensors),
                  label: 'Sessions',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.dns_outlined),
                  activeIcon: Icon(Icons.dns),
                  label: 'Server',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings_outlined),
                  activeIcon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            )
          : null,
    );
  }
}
