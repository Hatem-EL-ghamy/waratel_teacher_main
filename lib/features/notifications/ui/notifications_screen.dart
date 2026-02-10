import 'widgets/balance_card.dart';
import 'package:flutter/material.dart';
import 'widgets/transaction_item.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../logic/cubit/notifications_cubit.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/custom_app_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotificationsCubit>(),
      child: Column(
        children: [
          const CustomAppHeader(title: 'المحفظة'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  BalanceCard(
                    balance: 1240.50,
                    onDetailsPressed: () {},
                    onWithdrawPressed: () {},
                  ),
                  SizedBox(height: 24.h),

                  // Stats Section
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'عدد الحلقات',
                          value: '156',
                          subtitle: 'حلقة',
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildStatCard(
                          title: 'ساعات العمل',
                          value: '48',
                          subtitle: 'ساعة',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Recent Transactions Header
                  Text(
                    'آخر العمليات',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Transactions List
                  TransactionItem(
                    title: 'حلقة جديدة',
                    date: '26 أكتوبر',
                    amount: 25.00,
                    isIncome: true,
                  ),
                  TransactionItem(
                    title: 'سحب رصيد',
                    date: '25 أكتوبر',
                    amount: 100.00,
                    isIncome: false,
                  ),
                  TransactionItem(
                    title: 'حلقة جديدة',
                    date: '24 أكتوبر',
                    amount: 30.00,
                    isIncome: true,
                  ),
                  TransactionItem(
                    title: 'حلقة جديدة',
                    date: '23 أكتوبر',
                    amount: 25.00,
                    isIncome: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
