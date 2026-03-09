import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waratel_app/core/theming/colors.dart';
import 'package:waratel_app/features/ads/logic/cubit/ads_cubit.dart';
import 'package:waratel_app/features/ads/logic/cubit/ads_state.dart';
import 'package:waratel_app/features/home/ui/widgets/ads_slider.dart';
import 'package:waratel_app/features/home/ui/widgets/dashboard_stats_card.dart';
import 'package:waratel_app/features/home/ui/widgets/home_header.dart';
import 'package:waratel_app/features/home/ui/widgets/recent_calls_list.dart';
import 'package:waratel_app/core/routing/routers.dart';
import 'package:waratel_app/features/home/logic/cubit/home_cubit.dart';
import 'package:waratel_app/features/localization/data/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Re-triggering of data is now primarily handled by the parent HomeLayout
    // or through the RefreshIndicator manually.
  }

  Future<void> _refreshData() async {
    // Manually refresh home data from the RefreshIndicator
    if (mounted) {
      context.read<HomeCubit>().loadSoon();
      context.read<HomeCubit>().getInitialOnlineStatus();
      context.read<AdsCubit>().getAds();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        color: ColorsManager.primaryColor,
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ads Slider Section
                    BlocBuilder<AdsCubit, AdsState>(
                      builder: (context, state) {
                        if (state is AdsLoading) {
                          return Container(
                            height: 160.h,
                            margin: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: const Center(child: CircularProgressIndicator()),
                          );
                        } else if (state is AdsLoaded) {
                          if (state.ads.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            child: AdsSlider(ads: state.ads),
                          );
                        } else if (state is AdsError) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.w),
                              child: TextButton.icon(
                                onPressed: () => context.read<AdsCubit>().getAds(),
                                icon: const Icon(Icons.refresh),
                                label: Text('retry'.tr(context)),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),

                    // Dashboard & Next Session (NextSessionCard is inside DashboardStatsCard)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: const DashboardStatsCard(),
                    ),
                    SizedBox(height: 15.h),

                    // Successful Calls Label + View All
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'successful_calls'.tr(context),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorsManager.textPrimaryColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to Statistics screen for full call history
                              Navigator.pushNamed(context, Routes.statistics);
                            },
                            child: Text(
                              'view_all'.tr(context),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorsManager.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const RecentCallsList(),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
