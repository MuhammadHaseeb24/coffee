import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'login_screen.dart';

class _Page {
  final String title;
  final String subtitle;
  final IconData badge;
  final Color tint;
  const _Page(this.title, this.subtitle, this.badge, this.tint);
}

const _pages = [
  _Page(
    'Find your favorite\nCoffee Taste!',
    'We provide the best coffee\nfor you from all over the world.',
    Icons.coffee_rounded,
    Color(0xFFEBDDD0),
  ),
  _Page(
    'Made exactly\nthe way you like',
    'Pick your size, milk and quantity.\nCustomize every single cup.',
    Icons.tune_rounded,
    Color(0xFFE4EBD9),
  ),
  _Page(
    'Fast pickup\nor delivery',
    'Order in a few taps and track it\nuntil it is ready for you.',
    Icons.delivery_dining_rounded,
    Color(0xFFDDE7F0),
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  bool get _isLast => _index == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await AppState.instance.completeOnboarding();
    if (!mounted) return;
    Navigator.pushReplacement(context, fadeRoute(const LoginScreen()));
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isLast ? 0 : 1,
                child: TextButton(
                  onPressed: _isLast ? null : _finish,
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: AppColors.muted, fontSize: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) => _PageView(page: _pages[i]),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                final active = i == _index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 26 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.brown.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: PrimaryButton(
                label: _isLast ? 'Get Started' : 'Continue',
                onTap: _next,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  final _Page page;
  const _PageView({required this.page});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 290,
            width: 290,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 260,
                  width: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: page.tint,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(34),
                    child: CoffeeLogo(size: 180),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 18,
                  child: Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(page.badge, color: Colors.white, size: 28),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
              height: 1.3,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            page.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
