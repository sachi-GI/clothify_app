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
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, value, child) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[200],
                child: Icon(
                  Icons.account_circle,
                  size: 110,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.blueGrey),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                value.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.blueGrey),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                value.email,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.home, color: Colors.blueGrey),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                value.address.isNotEmpty
                                    ? value.address
                                    : "Add your address",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.blueGrey),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                value.phone.isNotEmpty
                                    ? value.phone
                                    : "Add your phone number",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.edit, size: 16),
                              label: Text(
                                "Edit Profile",
                                style: TextStyle(fontSize: 14),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent.shade400,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                minimumSize: Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                elevation: 1,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/update_profile');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    ListTile(
                      title: Text("My Orders"),
                      leading: Icon(Icons.local_shipping_outlined),
                      onTap: () {
                        Navigator.pushNamed(context, "/orders");
                      },
                    ),
                    Divider(thickness: 1, endIndent: 10, indent: 10),
                    ListTile(
                      title: Text("Help & Support"),
                      leading: Icon(Icons.support_agent),
                      onTap: () {},
                    ),
                    Divider(thickness: 1, endIndent: 10, indent: 10),
                    ListTile(
                      title: Text("Logout"),
                      leading: Icon(Icons.logout_outlined),
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
}
