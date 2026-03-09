import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:lottie/lottie.dart';
import 'package:waratel_app/core/di/dependency_injection.dart';
import 'package:waratel_app/core/helpers/size_box.dart';
import 'package:waratel_app/core/theming/colors.dart';
import 'package:waratel_app/core/theming/styles.dart';
import 'package:waratel_app/features/profile/logic/cubit/profile_cubit.dart';

class GeminiChatScreen extends StatefulWidget {
  const GeminiChatScreen({super.key});

  @override
  State<GeminiChatScreen> createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final String _apiKey = 'AIzaSyBBkw_s-79L9GPbvLWzkAmc2XBiMtRoNck';
  late GenerativeModel _model;
  late ChatSession _chat;

  @override
  void initState() {
    super.initState();
    
    // Initialize Gemini Model
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
    _chat = _model.startChat();

    final profileCubit = getIt<ProfileCubit>();
    final userName = (profileCubit.profileData?.user?.name ?? 'Teacher').trim();
    
    _messages.add(
      {
        "role": "bot",
        "text": "Hello, $userName! How can I help you today?",
      },
    );
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "text": text});
      _controller.clear();
      _isLoading = true;
    });

    try {
      final response = await _chat.sendMessage(Content.text(text));
      final reply = response.text;

      setState(() {
        _messages.add(
            {"role": "bot", "text": reply ?? "Sorry, I couldn't understand that. Please try again."});
      });
    } catch (e) {
      debugPrint('❌ [GEMINI ERROR]: $e');
      
      // Fallback logic for Not Found / 404
      if (e.toString().contains('404') || e.toString().contains('not found')) {
        try {
          debugPrint('🔄 Attempting fallback to gemini-pro...');
          _model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
          _chat = _model.startChat();
          final fallbackResponse = await _chat.sendMessage(Content.text(text));
          setState(() {
            _messages.add({"role": "bot", "text": fallbackResponse.text ?? ''});
          });
          return;
        } catch (f) {
           debugPrint('❌ Fallback failed: $f');
        }
      }

      setState(() {
        _messages.add({"role": "bot", "text": "An error occurred. details: ${e.toString().split(':').last}"});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Bot"),
        leading: const Icon(Icons.auto_awesome),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18.0.w,
            vertical: 12.h,
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['role'] == 'user';
                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isUser 
                              ? ColorsManager.accentColor 
                              : ColorsManager.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: isUser ? null : Border.all(color: ColorsManager.borderColor),
                        ),
                        child: Text(
                          msg['text'] ?? '',
                          style: isUser
                              ? TextStyles.font14RegularTextSecondary.copyWith(color: Colors.white)
                              : TextStyles.font14RegularTextSecondary.copyWith(color: ColorsManager.textPrimaryColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (_isLoading)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Lottie.asset(
                    'assets/lottie/indicator.json',
                    height: 80.h,
                    errorBuilder: (context, error, stackTrace) => const CircularProgressIndicator(),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Write your message...',
                        ),
                        style: TextStyles.font14RegularTextSecondary.copyWith(color: ColorsManager.textPrimaryColor),
                      ),
                    ),
                    AppSpacing.horizontalSpace8,
                    Container(
                      decoration: const BoxDecoration(
                        color: ColorsManager.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: _isLoading ? null : _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
