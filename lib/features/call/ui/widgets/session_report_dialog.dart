import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../features/home/logic/cubit/home_cubit.dart';
import '../../../../features/record/logic/cubit/record_cubit.dart';
import '../../../../features/record/data/models/session_model.dart';

class SessionReportDialog extends StatefulWidget {
  final String studentName;
  final String trackName;
  final VoidCallback? onSuccess;

  const SessionReportDialog({
    super.key,
    required this.studentName,
    required this.trackName,
    this.onSuccess,
  });

  @override
  State<SessionReportDialog> createState() => _SessionReportDialogState();
}

class _SessionReportDialogState extends State<SessionReportDialog> {
  bool isPresent = true;
  String selectedRating = 'ممتاز';
  final TextEditingController notesController = TextEditingController();
  final TextEditingController nextAssignmentController = TextEditingController();

  final List<String> ratings = ['ممتاز', 'جيد جداً', 'جيد', 'يحتاج متابعة'];

  @override
  void dispose() {
    notesController.dispose();
    nextAssignmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Container(
        padding: EdgeInsets.all(20.w),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تقرير الجلسة',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.textPrimaryColor,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'يجب إكمال التقرير لتحديث سجل الطالب وتثبيت الجلسة',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.h),
              
              // Student Info
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.studentName,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.textPrimaryColor,
                        ),
                      ),
                      Text(
                        widget.trackName,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: ColorsManager.primaryColor,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                         width: 50.w,
                         height: 50.w,
                         color: Colors.grey.shade300,
                         child: Icon(Icons.person, color: Colors.white, size: 30.sp),
                    )
                  ),
                ],
              ),
              
              Divider(height: 30.h),
              
              // Attendance
              _buildSectionTitle('حالة الحضور'),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: _buildAttendanceOption(
                      label: 'غائب',
                      isSelected: !isPresent,
                      onTap: () => setState(() => isPresent = false),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildAttendanceOption(
                      label: 'حاضر',
                      isSelected: isPresent,
                      onTap: () => setState(() => isPresent = true),
                      isPositive: true,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 20.h),
              
              // Rating
              _buildSectionTitle('تقييم مستوى التلقي'),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                alignment: WrapAlignment.center,
                children: ratings.map((rating) {
                   return SizedBox(
                     width: (MediaQuery.of(context).size.width - 100.w) / 2, // Approx half width
                     child: _buildRatingOption(
                       label: rating,
                       isSelected: selectedRating == rating,
                       onTap: () => setState(() => selectedRating = rating),
                     ),
                   );
                }).toList(),
              ),
              
              SizedBox(height: 20.h),
              
              // Notes
              _buildSectionTitle('الملاحظات التعليمية والشرعية'),
              SizedBox(height: 10.h),
              TextFormField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'ملاحظات حول المخارج، التجويد، أو الحفظ...',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                   border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: ColorsManager.primaryColor),
                  ),
                ),
              ),

              SizedBox(height: 20.h),
               // Next Assignment
              _buildSectionTitle('الورد القادم المقترح'),
              SizedBox(height: 10.h),
              TextFormField(
                controller: nextAssignmentController,
                 decoration: InputDecoration(
                  hintText: 'مثال: من الآية 10 إلى 25 سورة البقرة',
                  hintStyle: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: Icon(Icons.menu_book, color: Colors.grey.shade500),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: ColorsManager.primaryColor),
                  ),
                ),
              ),
              
              SizedBox(height: 30.h),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAndEnd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.primaryColor, // Dark green
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'حفظ التقرير وإنهاء الجلسة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _saveAndEnd() {
    final now = DateTime.now();
    
    // Create Session Model
    final session = SessionModel(
      studentName: widget.studentName,
      date: '${now.year}-${now.month}-${now.day}',
      time: '${now.hour}:${now.minute.toString().padLeft(2, '0')}',
      trackName: widget.trackName,
      status: 'مكتملة', 
      notes: notesController.text,
      nextAssignment: nextAssignmentController.text,
      rating: selectedRating,
      isPresent: isPresent,
    );
    
    // Save to RecordCubit
    getIt<RecordCubit>().addSession(session);
    
    // Also update HomeCubit for recent calls (keep existing behavior for compatibility)
    final callData = {
      'name': widget.studentName,
      'initial': widget.studentName.isNotEmpty ? widget.studentName.characters.first : '',
    };
    getIt<HomeCubit>().addCall(callData);
    
    // Check if we have a success callback for specific cleanup (e.g. ending Agora session)
    if (widget.onSuccess != null) {
      widget.onSuccess!();
    } else {
      // Default: Close Dialog AND Call Screen to go back to Home
      Navigator.of(context).pop(); // Close Dialog
      Navigator.of(context).pop(); // Close Call Screen
    }
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: ColorsManager.primaryColor,
        ),
      ),
    );
  }

  Widget _buildAttendanceOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isPositive = false,
  }) {
    Color activeColor = isPositive ? ColorsManager.primaryColor : Colors.redAccent;
    
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: 1.5.w,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : Colors.grey.shade500,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
  
   Widget _buildRatingOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.primaryColor : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : ColorsManager.textPrimaryColor.withOpacity(0.7),
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
        ),
      ),
    );
  }
}
