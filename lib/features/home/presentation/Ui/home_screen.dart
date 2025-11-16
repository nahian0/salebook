import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../stock/presentation/ui/stock_screen.dart';
import '../../../sales/presentation/ui/sales_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Sale Book',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: Badge(
              label: const Text('3'),
              backgroundColor: AppColors.badgeBackground,
              textColor: AppColors.badgeText,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              _showMoreMenu(context);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Manage your business efficiently',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              // Responsive Grid using LayoutBuilder
              LayoutBuilder(
                builder: (context, constraints) {
                  // Calculate number of columns based on width
                  int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  double cardWidth = (constraints.maxWidth - (16 * (crossAxisCount - 1))) / crossAxisCount;
                  double cardHeight = cardWidth * 1.1; // Aspect ratio

                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: _buildFeatureCard(
                          context,
                          icon: Icons.inventory_2_rounded,
                          title: 'Stock',
                          subtitle: 'Manage inventory',
                          color: AppColors.stockColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const StockScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: _buildFeatureCard(
                          context,
                          icon: Icons.point_of_sale_rounded,
                          title: 'Sales Entry',
                          subtitle: 'Record sales',
                          color: AppColors.primary,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SalesScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.borderLight, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.getLightColor(color),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    size: 36,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.borderMedium,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.getMenuBackgroundColor('settings'),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: AppColors.getMenuIconColor('settings'),
                    ),
                  ),
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Settings'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.getMenuBackgroundColor('profile'),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: AppColors.getMenuIconColor('profile'),
                    ),
                  ),
                  title: const Text('Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.getMenuBackgroundColor('about'),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: AppColors.getMenuIconColor('about'),
                    ),
                  ),
                  title: const Text('About'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('About'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.getMenuBackgroundColor('help'),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.help_outline,
                      color: AppColors.getMenuIconColor('help'),
                    ),
                  ),
                  title: const Text('Help'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}