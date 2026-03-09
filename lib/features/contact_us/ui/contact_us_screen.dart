import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waratel_app/core/di/dependency_injection.dart';
import 'package:waratel_app/core/theming/colors.dart';
import 'package:waratel_app/features/contact_us/logic/cubit/contact_cubit.dart';
import 'package:waratel_app/features/contact_us/logic/cubit/contact_state.dart';
import 'package:waratel_app/features/localization/data/app_localizations.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendEmail(String recipient) async {
    final String name = _nameController.text.trim();
    final String userEmail = _emailController.text.trim();
    final String subject = _subjectController.text.trim();
    final String message = _messageController.text.trim();

    if (name.isEmpty || userEmail.isEmpty || subject.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
      return;
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: recipient,
      query: _encodeQueryParameters(<String, String>{
        'subject': '[$name] $subject',
        'body': 'من: $name ($userEmail)\n\n$message',
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا يمكن فتح تطبيق البريد الإلكتروني')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: $e')),
        );
      }
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ContactCubit>()..getContactSettings(),
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundColor,
        appBar: AppBar(title: Text('contact_us_title'.tr(context))),
        body: BlocBuilder<ContactCubit, ContactState>(
          builder: (context, state) {
            if (state is ContactLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ContactError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.error),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<ContactCubit>().getContactSettings(),
                      child: Text('retry'.tr(context)),
                    ),
                  ],
                ),
              );
            } else if (state is ContactSuccess) {
              return _buildBody(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ContactSuccess state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Header banner ────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(24.w),
            decoration: const BoxDecoration(
              gradient: ColorsManager.headerGradient,
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.support_agent,
                      color: Colors.white, size: 36.sp),
                ),
                SizedBox(height: 12.h),
                Text(
                  'contact_us_title'.tr(context),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: ColorsManager.accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'we_are_here'.tr(context),
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'support_team_desc'.tr(context),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                // ── Contact info tiles ───────────────────────────────
                _ContactInfoTile(
                  label: 'email_hint'.tr(context),
                  value: state.contactSettings.email,
                  icon: Icons.email_outlined,
                ),
                SizedBox(height: 12.h),
                _ContactInfoTile(
                  label: 'customer_service'.tr(context),
                  value: state.contactSettings.phone,
                  icon: Icons.phone_outlined,
                ),
                SizedBox(height: 24.h),

                // ── Message form ─────────────────────────────────────
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: ColorsManager.surfaceColor,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: ColorsManager.cardShadow,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'send_message'.tr(context),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.textPrimaryColor,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          Expanded(
                              child: _AppTextField(
                                  hint: 'full_name'.tr(context),
                                  controller: _nameController)),
                          SizedBox(width: 12.w),
                          Expanded(
                              child: _AppTextField(
                                  hint: 'email_hint'.tr(context),
                                  controller: _emailController)),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      _AppTextField(
                          hint: 'subject_hint'.tr(context),
                          controller: _subjectController),
                      SizedBox(height: 12.h),
                      _AppTextField(
                          hint: 'message_hint'.tr(context),
                          maxLines: 5,
                          controller: _messageController),
                      SizedBox(height: 24.h),
                      ElevatedButton.icon(
                        onPressed: () => _sendEmail(state.contactSettings.email),
                        icon:
                            Icon(Icons.send, size: 18.sp, color: Colors.white),
                        label: Text(
                          'send_message'.tr(context),
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactInfoTile extends StatelessWidget {
  const _ContactInfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label, value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceColor,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
              color: ColorsManager.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon,
                color: ColorsManager.primaryColor, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorsManager.textPrimaryColor)),
                Text(value,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorsManager.textSecondaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField(
      {required this.hint, this.maxLines = 1, required this.controller});
  final String hint;
  final int maxLines;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(hintText: hint),
    );
  }
}
