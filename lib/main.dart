import 'package:clothify_app/controllers/auth_service.dart';
import 'package:clothify_app/firebase_options.dart';
import 'package:clothify_app/providers/cart_provider.dart';
import 'package:clothify_app/providers/user_provider.dart';
import 'package:clothify_app/views/cart_page.dart';
import 'package:clothify_app/views/checkout_page.dart';
import 'package:clothify_app/views/home_nav.dart';
import 'package:clothify_app/views/login.dart';
import 'package:clothify_app/views/orders_page.dart';
import 'package:clothify_app/views/signup.dart';
import 'package:clothify_app/views/specific_products.dart';
import 'package:clothify_app/views/update_profile.dart';
import 'package:clothify_app/views/view_product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await dotenv.load(fileName: ".env");
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent.shade400,
          ),
        ),
        routes: {
          "/": (context) => const CheckUser(),
          "/home": (context) => const HomeNav(),
          "/login": (context) => const LoginPage(),
          "/signup": (context) => const SignupPage(),
          "/update_profile": (context) => const UpdateProfile(),
          "/specific": (context) => const SpecificProducts(),
          "/view_product": (context) => const ViewProduct(),
          "/cart": (context) => const CartPage(),
          "/checkout": (context) => const CheckoutPage(),
          "/orders": (context) => const OrdersPage(),
          "/view_order": (context) => const ViewOrder(),
        },
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
