import 'package:clothify_app/controllers/auth_service.dart';
import 'package:clothify_app/providers/cart_provider.dart';
import 'package:clothify_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withOpacity(0.85),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 20,
                      top: 36,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value.name.isNotEmpty ? value.name : 'Guest User',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            value.email,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 20,
                      bottom: -40,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 44,
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            Icons.account_circle,
                            size: 72,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 56),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 18,
                    ),
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: 'Name',
                          valueText: value.name,
                        ),
                        Divider(),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          label: 'Email',
                          valueText: value.email,
                        ),
                        Divider(),
                        _buildInfoRow(
                          icon: Icons.home_outlined,
                          label: 'Address',
                          valueText: value.address.isNotEmpty
                              ? value.address
                              : 'Add your address',
                        ),
                        Divider(),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          label: 'Phone',
                          valueText: value.phone.isNotEmpty
                              ? value.phone
                              : 'Add your phone number',
                        ),
                        SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.edit, size: 16),
                            label: Text('Edit Profile'),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/update_profile');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 18),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            Icons.local_shipping_outlined,
                            color: Colors.grey[800],
                          ),
                        ),
                        title: Text('My Orders'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.pushNamed(context, "/orders");
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey[100],
                          child: Icon(
                            Icons.logout_outlined,
                            color: Colors.grey[800],
                          ),
                        ),
                        title: Text('Logout'),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () async {
                          Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).cancelProvider();
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).cancelProvider();
                          await AuthService().logout();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/login',
                            (route) => true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String valueText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey[700]),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(valueText, style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
