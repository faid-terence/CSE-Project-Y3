import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parking_app/provider/user_provider.dart';
import 'package:parking_app/screens/auth/forgot_password_screen.dart';
import 'package:parking_app/screens/auth/login_screen.dart';
import 'package:parking_app/screens/auth/sign_up_screen.dart';
import 'package:parking_app/screens/home/home_screen.dart';
import 'package:parking_app/services/auth/auth_service.dart';
import 'package:parking_app/services/dio_client/dio_client.dart';
import 'package:parking_app/services/storage/storage_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DioClient>(create: (_) => DioClient('http://localhost:8000')),
        Provider<StorageService>(create: (_) => StorageService()),
        Provider<AuthService>(
          create: (context) => AuthService(context.read<DioClient>()),
        ),
        ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Parking App',
        theme: ThemeData(
          primaryColor: const Color(0xFF4CB8B3),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto',
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CB8B3),
            ),
          ),
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final storageService = Provider.of<StorageService>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (await authService.isAuthenticated()) {
      final userData = await storageService.getUserData();
      if (userData != null) {
        userProvider.setUser(userData);
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        final response = await authService.getCurrentUser();
        if (response.success && response.data != null) {
          userProvider.setUser(response.data!);
          await storageService.saveUserData(response.data!);
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/onboarding');
          }
        }
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: Color(0xFF4CB8B3))),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _completeOnboarding() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Find Parking Places\nAround You Easily',
      subtitle: 'Book your parking without any hustle',
      image: 'assets/images/splash_1.svg',
      buttonText: 'Next',
      highlightText: 'Places',
      regularText: 'Find Parking ',
    ),
    OnboardingData(
      title: 'Book and Pay Parking\nQuickly & Safely',
      subtitle: 'Search for nearest parking space\navailable around you',
      image: 'assets/images/splash_3.svg',
      buttonText: 'Next',
      highlightText: 'Parking',
      regularText: 'Book and Pay ',
    ),
    OnboardingData(
      title: 'Extend Parking Time\nAs You Need',
      subtitle: 'Book your parking without any hustle',
      image: 'assets/images/splash_3.svg',
      buttonText: 'Done',
      highlightText: 'Parking',
      regularText: 'Extend ',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index
                              ? const Color(0xFF4CB8B3)
                              : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  } else {
                    _completeOnboarding();
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  _pages[_currentPage].buttonText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: _completeOnboarding,
              child: const Text(
                'Skip',
                style: TextStyle(
                  color: Color(0xFF4CB8B3),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;
  final String buttonText;
  final String regularText;
  final String highlightText;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.buttonText,
    required this.regularText,
    required this.highlightText,
  });
}

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: SvgPicture.asset(
              data.image,
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: data.regularText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: data.highlightText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CB8B3),
                        ),
                      ),
                      if (data.title.contains('\n'))
                        TextSpan(
                          text: data.title.substring(data.title.indexOf('\n')),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
