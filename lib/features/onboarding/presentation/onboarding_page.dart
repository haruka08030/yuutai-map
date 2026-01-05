import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';
import 'package:intl/intl.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    const OnboardingContent(
      title: '優待マップ',
      description: 'The best to do list application for you',
      icon: Icons.map_outlined,
      isFirstPage: true,
    ),
    const OnboardingContent(
      title: '優待を管理',
      description: 'あなたの優待券を簡単に管理できます\n期限や使用状況を一目で確認できます',
      icon: Icons.card_giftcard_outlined,
      isFirstPage: false,
    ),
    const OnboardingContent(
      title: '期限を確認',
      description: '期限が近い優待券をお知らせします\n通知で見逃しを防ぎます',
      icon: Icons.notifications_outlined,
      isFirstPage: false,
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

  Future<void> _completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('onboardingCompleted', true);
    if (mounted) {
      context.go('/');
    }
  }

  void _onSkip() {
    _completeOnboarding();
  }

  void _onContinue() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeString = DateFormat('H:mm').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFF24A19C),
      body: SafeArea(
        child: Stack(
          children: [
            // Status Bar with Time and Skip button (for pages after first)
            if (_currentPage > 0)
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  height: 44,
                  color: const Color(0xFF24A19C),
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        timeString,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w600,
                          height: 1.33,
                          letterSpacing: -0.24,
                        ),
                      ),
                      TextButton(
                        onPressed: _onSkip,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Main Content
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index], index);
              },
            ),

            // Page Indicators (only for first page)
            if (_currentPage == 0)
              Positioned(
                left: 0,
                right: 0,
                bottom: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildPageIndicator(index == _currentPage),
                  ),
                ),
              ),

            // Continue Button (for pages after first)
            if (_currentPage > 0)
              Positioned(
                left: 0,
                right: 0,
                bottom: 40,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF24A19C),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingContent content, int index) {
    if (content.isFirstPage) {
      return _buildFirstPage(content);
    } else {
      return _buildSecondaryPage(content, index);
    }
  }

  Widget _buildFirstPage(OnboardingContent content) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 120),
          // Icon
          Container(
            width: 68,
            height: 68,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.80),
              ),
            ),
            child: Icon(content.icon, size: 40, color: const Color(0xFF24A19C)),
          ),
          const SizedBox(height: 32),
          // Title and Description
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 250,
                child: Text(
                  content.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 250,
                child: Text(
                  content.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSecondaryPage(OnboardingContent content, int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  content.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: 'Helvetica',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  content.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Expanded(child: _buildContentCards(index)),
        ],
      ),
    );
  }

  Widget _buildContentCards(int pageIndex) {
    if (pageIndex == 1) {
      // 優待管理ページのカード
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildFeatureCard(
              title: '優待券を追加',
              description: '会社名や期限を登録',
              icon: Icons.add_circle_outline,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              title: 'フォルダで整理',
              description: 'カテゴリー別に分類',
              icon: Icons.folder_outlined,
              color: Colors.orange,
            ),
          ],
        ),
      );
    } else if (pageIndex == 2) {
      // 期限確認ページのカード
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            _buildFeatureCard(
              title: '期限通知',
              description: '期限が近づいたら通知',
              icon: Icons.notifications_active_outlined,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              title: 'マップで確認',
              description: '優待が使える店舗をマップで表示',
              icon: Icons.map_outlined,
              color: Colors.green,
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withAlpha(10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 25 : 8,
      height: 8,
      decoration: ShapeDecoration(
        color: const Color(0xFFCAF1EF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;
  final bool isFirstPage;

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.isFirstPage,
  });
}
