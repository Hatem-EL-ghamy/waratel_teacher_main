import 'widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'widgets/recent_calls_list.dart';
import 'widgets/dashboard_stats_card.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/features/ads/logic/cubit/ads_cubit.dart';
import 'package:waratel_app/features/ads/logic/cubit/ads_state.dart';
import 'package:waratel_app/features/ads/ui/widgets/ads_slider.dart';

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
                   BlocBuilder<AdsCubit, AdsState>(
                    builder: (context, state) {
                      if (state is AdsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AdsLoaded) {
                         if (state.ads.isEmpty) return const SizedBox.shrink();
                         return Padding(
                           padding: EdgeInsets.symmetric(vertical: 10.h),
                           child: AdsSlider(ads: state.ads),
                         );
                      } else if (state is AdsError) {
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
