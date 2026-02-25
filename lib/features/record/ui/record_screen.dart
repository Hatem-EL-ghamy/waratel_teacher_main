import 'widgets/session_card.dart';
import 'package:flutter/material.dart';
import '../logic/cubit/record_cubit.dart';
import '../logic/cubit/record_state.dart';
import '../../../../core/theming/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/widgets/custom_app_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<RecordCubit>(),
      child: Column(
        children: [
          const CustomAppHeader(title: 'جلساتي'),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'سجل الجلسات',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.textPrimaryColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Subtitle
                  Text(
                    'عرض الجلسات السابقة المسجلة وتفاصيلها',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Sessions List
                  BlocBuilder<RecordCubit, RecordState>(
                    builder: (context, state) {
                      if (state is RecordLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is RecordLoaded) {
                        if (state.sessions.isEmpty) {
                          return Center(
                            child: Column(
                              children: [
                                Icon(Icons.history, size: 64.sp, color: Colors.grey[300]),
                                SizedBox(height: 16.h),
                                Text(
                                  'لا توجد جلسات مسجلة بعد',
                                  style: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
                                ),
                              ],
                            ),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.sessions.length,
                          itemBuilder: (context, index) {
                            final session = state.sessions[index];
                            return SessionCard(
                              studentName: session.studentName,
                              time: session.time,
                              date: session.date,
                              status: session.status,
                              statusColor: session.isPresent ? Colors.blue : Colors.red, // Example coloring
                              reportCenter: 'عرض التقرير', // Changed label
                              onReportTap: () => _showSessionDetails(context, session),
                            );
                          },
                        );
                      } else if (state is RecordError) {
                         return Center(
                           child: Text(
                             state.error,
                             style: TextStyle(color: Colors.red),
                           ),
                         );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSessionDetails(BuildContext context, dynamic session) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'تفاصيل الجلسة',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(height: 30.h),
              _buildDetailRow('الطالب:', session.studentName),
              _buildDetailRow('المسار:', session.trackName),
              _buildDetailRow('التاريخ:', '${session.date} - ${session.time}'),
              _buildDetailRow('الحالة:', session.isPresent ? 'حاضر' : 'غائب'),
              _buildDetailRow('التقييم:', session.rating),
              SizedBox(height: 10.h),
              Text('الملاحظات:', style: TextStyle(fontWeight: FontWeight.bold, color: ColorsManager.primaryColor)),
              Text(session.notes.isEmpty ? 'لا توجد ملاحظات' : session.notes),
              SizedBox(height: 10.h),
              Text('الواجب القادم:', style: TextStyle(fontWeight: FontWeight.bold, color: ColorsManager.primaryColor)),
              Text(session.nextAssignment.isEmpty ? 'لم يحدد' : session.nextAssignment),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إغلاق'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text('$label ', style: TextStyle(fontWeight: FontWeight.bold, color: ColorsManager.primaryColor)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
