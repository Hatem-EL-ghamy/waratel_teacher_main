import 'widgets/home_header.dart';
import 'package:flutter/material.dart';
import '../logic/cubit/home_cubit.dart';
import '../logic/cubit/home_state.dart';
import 'widgets/recent_calls_list.dart';
import 'widgets/dashboard_stats_card.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/features/home/data/models/advertisement.dart';

 import 'widgets/ads_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const HomeHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   // Ads Slider Section
                   BlocBuilder<HomeCubit, HomeState>(
                    buildWhen: (previous, current) =>
                        current is HomeAdsLoading ||
                        current is HomeAdsLoaded ||
                        current is HomeAdsError,
                    builder: (context, state) {
                      if (state is HomeAdsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is HomeAdsLoaded) {
                         if (state.ads.isEmpty) return const SizedBox.shrink();
                         final adsList = state.ads.cast<Advertisement>();
                         return Padding(
                           padding: EdgeInsets.symmetric(vertical: 10.h),
                           child: AdsSlider(ads: adsList),
                         );
                      } else if (state is HomeAdsError) {
                        return const SizedBox.shrink();
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: const DashboardStatsCard(),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'المكالمات الناجحة',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.textPrimaryColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const RecentCallsList(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
