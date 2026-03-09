import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/core/theming/colors.dart';
import 'package:waratel_app/features/ads/data/models/ads_response.dart';

/// بانر الإعلانات - تم تبسيطه لأقصى درجة لضمان السلاسة
class AdsSlider extends StatefulWidget {
  final List<Advertisement> ads;
  const AdsSlider({super.key, required this.ads});

  @override
  State<AdsSlider> createState() => _AdsSliderState();
}

class _AdsSliderState extends State<AdsSlider> {
  int _currentPage = 0;
  late PageController _pageController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (!mounted) return;
      if (_pageController.hasClients) {
        final nextPage = _currentPage < widget.ads.length - 1 ? _currentPage + 1 : 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.ads.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final ad = widget.ads[index];
              return _AdCard(ad: ad);
            },
          ),
        ),
        SizedBox(height: 10.h),
        _DotsIndicator(count: widget.ads.length, currentIndex: _currentPage),
      ],
    );
  }
}

class _AdCard extends StatelessWidget {
  final Advertisement ad;
  const _AdCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ColorsManager.primaryColor;
    if (ad.bgColor != null && ad.bgColor!.isNotEmpty) {
      try {
        final hexColor = ad.bgColor!.replaceAll('#', '');
        backgroundColor = Color(int.parse('FF$hexColor', radix: 16));
      } catch (_) {}
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ad.title,
                  style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Text(
                  ad.subtitle,
                  style: TextStyle(fontSize: 13.sp, color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (ad.imageUrl != null) ...[
            SizedBox(width: 12.w),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                ad.imageUrl!,
                width: 80.w,
                height: 80.w,
                fit: BoxFit.cover,
                // أزلت الـ cacheWidth/cacheHeight للتخلص من أي "تشويش"
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DotsIndicator extends StatelessWidget {
  final int count, currentIndex;
  const _DotsIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: currentIndex == index ? 20.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.r),
            color: currentIndex == index ? ColorsManager.primaryColor : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}
