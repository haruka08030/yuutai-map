import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_stock/app/theme/app_theme.dart';
import 'package:flutter_stock/app/theme/theme_provider.dart';
import 'package:flutter_stock/features/onboarding/provider/onboarding_provider.dart';

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
      description: 'あなたの優待をマップで管理',
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
    ref.invalidate(onboardingCompletedProvider);
    if (mounted) {
      context.go('/');
    }
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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index], index);
              },
            ),

            // Page Indicators
            Positioned(
              left: 0,
              right: 0,
              bottom: 100, // Position above the continue button
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (index) => _buildPageIndicator(index == _currentPage),
                ),
              ),
            ),

            // Continue Button
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
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSmall),
                      ),
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? '始める' : '次へ',
                      style: const TextStyle(
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        // Icon
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13.80),
          ),
          child: Icon(
            content.icon,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 32),
        // Title and Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                content.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                content.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.43,
                    ),
              ),
            ],
          ),
        ),
        const Spacer(flex: 3),
      ],
    );
  }

  Widget _buildSecondaryPage(OnboardingContent content, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(flex: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content.title,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                content.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
        const Spacer(flex: 1),
      ],
    );
  }

  Widget _buildContentCards(int pageIndex) {
    if (pageIndex == 1) {
      // 優待管理ページのカード
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            _buildFeatureCard(
              title: '優待券を追加',
              description: '会社名や期限を登録',
              icon: Icons.add_circle_outline,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              title: 'フォルダで整理',
              description: 'カテゴリー別に分類',
              icon: Icons.folder_outlined,
              color: Theme.of(context).colorScheme.primary,
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
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            _buildFeatureCard(
              title: 'マップで確認',
              description: '優待が使える店舗をマップで表示',
              icon: Icons.map_outlined,
              color: Theme.of(context).colorScheme.secondary,
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
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
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
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
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
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
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 25 : 8,
      height: 8,
      decoration: ShapeDecoration(
        color: isActive
            ? colorScheme.primary
            : colorScheme.onPrimary.withValues(alpha: 0.4),
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
