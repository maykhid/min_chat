import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  static const String name = '/chats';

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> with WidgetsBindingObserver {
  double _bottomOffset = 50;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final keyboardHeight = WidgetsBinding
        .instance.platformDispatcher.views.first.viewInsets.bottom;
    setState(() {
      _bottomOffset = keyboardHeight * 0.35;
      // prevent textfield from reaching the bottom on keyboard hide
      if (keyboardHeight < 50) {
        _bottomOffset = 50;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 2,
            backgroundColor: Colors.white,
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: context.pop,
                        child: const FaIcon(FontAwesomeIcons.arrowLeft),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      const CircleAvatar(
                        radius: 16,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Text(
                          'Sandra Achus',
                          // style: AppTextStyles.normalTextStyleDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: const SizedBox.expand(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    SenderChatBubble(),
                    SizedBox(
                      height: 32,
                    ),
                    RecipientChatBubble(),
                    SizedBox(
                      height: 32,
                    ),
                    SenderChatBubble(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(bottom: _bottomOffset),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 3,
                          sigmaY: 3,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                // controller: TextEditingController(),
                                maxLines: null,
                                enabled: true,
                                // expands: true,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  filled: true,
                                  // fillColor: AppColors.lightGrey3,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      color: Colors.transparent,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  hintText: 'new message',
                                ),
                              ),
                            ),
                            const Gap(12),
                            const FaIcon(FontAwesomeIcons.paperPlane),
                          ],
                        ),
                      ),
                    ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RecipientChatBubble extends StatelessWidget {
  const RecipientChatBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(8),
                bottomEnd: Radius.circular(8),
                bottomStart: Radius.circular(8),
              ),
            ),
            child: const SizedBox(
              // width: 200,
              child: Text(
                '''Yes ma, I would. ''',
                style: TextStyle(color: Colors.white),
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '16:03',
              // style: AppTextStyles.smallTextStylePrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class SenderChatBubble extends StatelessWidget {
  const SenderChatBubble({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            // height: 56,
            // width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(8),
                bottomEnd: Radius.circular(8),
                bottomStart: Radius.circular(8),
              ),
            ),
            child: const SizedBox(
              // width: 200,
              child: Text(
                '''Hello Ayo, I was expecting you around to fix the broken pipe. I was expecting you around to fix the broken pipe.''',
                textWidthBasis: TextWidthBasis.longestLine,
              ),
            ),
          ),
          const SizedBox(
            height: 6,
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '16:03',
              // style: AppTextStyles.smallTextStylePrimary,
            ),
          ),
        ],
      ),
    );
  }
}
