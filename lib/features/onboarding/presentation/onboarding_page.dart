import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _pages = [
    const OnboardingContent(
      title: '優待マップ',
      description: '優待を管理するためのマップ',
      icon: Icons.map_outlined,
    ),
    const OnboardingContent(
      title: '優待を管理',
      description: 'あなたの優待券を簡単に管理できます',
      icon: Icons.card_giftcard_outlined,
    ),
    const OnboardingContent(
      title: '期限を確認',
      description: '期限が近い優待券をお知らせします',
      icon: Icons.notifications_outlined,
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF24A19C),
      body: SafeArea(
        child: Stack(
          children: [
            // Status Bar
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: 44,
                color: const Color(0xFF24A19C),
                child: Stack(
                  children: [
                    // Battery indicator
                    Positioned(
                      right: 21,
                      top: 17.33,
                      child: Opacity(
                        opacity: 0.35,
                        child: Container(
                          width: 22,
                          height: 11.33,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                width: 1,
                                color: Colors.white,
                              ),
                              borderRadius: BorderRadius.circular(2.67),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 19.33,
                      top: 19.33,
                      child: Container(
                        width: 18,
                        height: 7.33,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(1.33),
                          ),
                        ),
                      ),
                    ),
                    // Time
                    const Positioned(
                      left: 21,
                      top: 7,
                      child: SizedBox(
                        width: 54,
                        child: Text(
                          '9:41',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'SF Pro Text',
                            fontWeight: FontWeight.w600,
                            height: 1.33,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Home Indicator
            Positioned(
              left: 0,
              bottom: 0,
              child: Container(
                width: screenWidth,
                height: 34,
                color: const Color(0xFF24A19C),
                child: Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Main Content
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),

            // Page Indicators
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
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
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

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
  });
}
