import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/colors.dart';

/// نافذة طلب السحب — تُعرض عند الضغط على زر "سحب"
class WithdrawalBottomSheet extends StatefulWidget {
  const WithdrawalBottomSheet({super.key});

  @override
  State<WithdrawalBottomSheet> createState() => _WithdrawalBottomSheetState();
}

class _WithdrawalBottomSheetState extends State<WithdrawalBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _accountController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: اربط مع الـ API هنا
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'تم إرسال طلب السحب بنجاح ✓',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: ColorsManager.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // يرفع النافذة فوق الكيبورد
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ═══ Handle Bar ═══
            SizedBox(height: 12.h),
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 20.h),

            // ═══ Header ═══
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: ColorsManager.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.arrow_outward,
                      color: ColorsManager.primaryColor,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طلب سحب رصيد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.textPrimaryColor,
                        ),
                      ),
                      Text(
                        'أدخل بيانات السحب بدقة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12.sp,
                          color: ColorsManager.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 20.h),

            // ═══ Form ═══
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // ─── حقل المبلغ ───
                      _buildField(
                        controller: _amountController,
                        label: 'المبلغ المراد سحبه',
                        hint: 'مثال: 500',
                        icon: Icons.monetization_on_outlined,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'يرجى إدخال المبلغ';
                          }
                          final amount = double.tryParse(v.trim());
                          if (amount == null || amount <= 0) {
                            return 'يرجى إدخال مبلغ صحيح';
                          }
                          return null;
                        },
                        suffix: Text(
                          'ر.س',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorsManager.primaryColor,
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // ─── حقل رقم الكاش / الحساب ───
                      _buildField(
                        controller: _accountController,
                        label: 'رقم الكاش أو الحساب البنكي',
                        hint: 'مثال: 0512345678',
                        icon: Icons.account_balance_outlined,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'يرجى إدخال رقم الحساب';
                          }
                          if (v.trim().length < 5) {
                            return 'رقم الحساب يبدو قصيراً جداً';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 16.h),

                      // ─── حقل الملاحظة ───
                      _buildField(
                        controller: _notesController,
                        label: 'ملاحظة (اختياري)',
                        hint: 'أي تفاصيل إضافية...',
                        icon: Icons.notes_outlined,
                        maxLines: 3,
                        validator: (_) => null,
                      ),

                      SizedBox(height: 24.h),

                      // ─── الأزرار ───
                      Row(
                        children: [
                          // زر الإلغاء
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: ColorsManager.primaryColor,
                                side: BorderSide(
                                    color: ColorsManager.primaryColor,
                                    width: 1.5),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r)),
                              ),
                              child: Text(
                                'إلغاء',
                                style: TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 12.w),

                          // زر الإرسال
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsManager.primaryColor,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor:
                                    ColorsManager.primaryColor.withOpacity(0.5),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r)),
                                elevation: 0,
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      height: 20.h,
                                      width: 20.h,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.send_rounded, size: 18.sp),
                                        SizedBox(width: 6.w),
                                        Text(
                                          'إرسال الطلب',
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Label
        Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Text(
            label,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: ColorsManager.textPrimaryColor,
            ),
          ),
        ),
        // Field
        TextFormField(
          controller: controller,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          maxLines: maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14.sp,
            color: ColorsManager.textPrimaryColor,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13.sp,
              color: ColorsManager.textSecondaryColor,
            ),
            hintTextDirection: TextDirection.rtl,
            prefixIcon: Icon(icon,
                color: ColorsManager.primaryColor, size: 20.sp),
            suffix: suffix,
            filled: true,
            fillColor: ColorsManager.backgroundColor,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
                  BorderSide(color: ColorsManager.primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

/// دالة مساعدة لعرض النافذة من أي مكان
void showWithdrawalSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const WithdrawalBottomSheet(),
  );
}
