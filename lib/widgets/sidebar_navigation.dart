import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SidebarNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;
  final bool isCollapsed;

  const SidebarNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
    this.isCollapsed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCollapsed ? 80 : 260,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: AppTheme.border, width: 1.5),
        ),
      ),
      child: isCollapsed ? _buildCollapsedLayout(context) : _buildExpandedLayout(context),
    );
  }

  // Expanded Sidebar Layout
  Widget _buildExpandedLayout(BuildContext context) {
    return Column(
      children: [
        // User Profile Card at top
        _buildProfileArea(context),
        const SizedBox(height: 24),
        const Divider(color: AppTheme.border, height: 1),
        const SizedBox(height: 24),

        // Menu Navigation Links
        Expanded(
          child: ListView(
            children: [
              _buildNavItem(context, 0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(context, 1, Icons.sensors, Icons.sensors, 'Sessions'),
              _buildNavItem(context, 2, Icons.dns_outlined, Icons.dns, 'Server'),
              _buildNavItem(context, 3, Icons.settings_outlined, Icons.settings, 'Settings'),
            ],
          ),
        ),
        
        // Brand Logo Area at bottom
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.bolt,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'SIBI-AI',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Collapsed Sidebar Layout (Matches Live Transcription spec)
  Widget _buildCollapsedLayout(BuildContext context) {
    return Column(
      children: [
        // Top: Profile Avatar only
        _buildAvatar(),
        const SizedBox(height: 16),
        const Divider(color: AppTheme.border, height: 1),
        const SizedBox(height: 24),

        // Center: Navigation Icons
        Expanded(
          child: ListView(
            children: [
              _buildCollapsedNavItem(context, 0, Icons.home_outlined, Icons.home),
              _buildCollapsedNavItem(context, 1, Icons.sensors, Icons.sensors),
              _buildCollapsedNavItem(context, 2, Icons.dns_outlined, Icons.dns),
              _buildCollapsedNavItem(context, 3, Icons.settings_outlined, Icons.settings),
            ],
          ),
        ),

        // Bottom: Notifications & Logout
        Column(
          children: [
            // Bell icon with red badge
            Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: AppTheme.textSecondary),
                  onPressed: () {},
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            IconButton(
              icon: const Icon(Icons.logout, color: AppTheme.textSecondary),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    IconData inactiveIcon,
    IconData activeIcon,
    String label,
  ) {
    final bool isActive = currentIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => onTabSelected(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isActive ? activeIcon : inactiveIcon,
                color: isActive ? Colors.white : AppTheme.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isActive ? Colors.white : AppTheme.textSecondary,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedNavItem(
    BuildContext context,
    int index,
    IconData inactiveIcon,
    IconData activeIcon,
  ) {
    final bool isActive = currentIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Tooltip(
        message: index == 0 ? 'Home' : index == 1 ? 'Sessions' : index == 2 ? 'Server' : 'Settings',
        child: InkWell(
          onTap: () => onTabSelected(index),
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: isActive ? AppTheme.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isActive ? activeIcon : inactiveIcon,
              color: isActive ? Colors.white : AppTheme.textSecondary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bapak Guru SIBI',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Administrator',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                        fontSize: 11,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.logout, color: AppTheme.textSecondary, size: 20),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return ClipOval(
      child: Image.network(
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&q=80&w=256',
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 40,
            height: 40,
            color: AppTheme.primary,
            child: const Center(
              child: Text(
                'BG',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
