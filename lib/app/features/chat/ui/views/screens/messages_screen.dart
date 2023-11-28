import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:min_chat/app/features/chat/ui/views/screens/chat_screen.dart';
import 'package:min_chat/core/utils/sized_context.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  static const String name = '/messages';

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const FaIcon(FontAwesomeIcons.penToSquare),
        onPressed: () {},
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  Text(
                    'Messages',
                    style: GoogleFonts.varelaRound(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Gap(8),
                  CupertinoSearchTextField(
                    placeholder: 'Search',
                    backgroundColor: Colors.grey.shade300,
                    // borderRadius: BorderRadius.circular(10),
                  ),
                  const Gap(20),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return const MessagesListItem();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesListItem extends StatelessWidget {
  const MessagesListItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const border = BorderSide(width: 0.3, color: Colors.grey);
    return InkWell(
      onTap: () => context.push(Chats.name),
      child: Container(
        height: 72,
        width: context.width,
        padding: const EdgeInsets.only(
          left: 9,
          right: 9,
        ),
        decoration: const BoxDecoration(
          border: Border(top: border, bottom: border),
        ),
        child: const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: CircleAvatar()),
            SizedBox(
              width: 9,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sandra Achus',
                  // style: AppTextStyles.normalTextStyleDarkGrey2,
                ),
                Text(
                  'Hello sir, how are you?',
                  // style: AppTextStyles.smallTextStyleGrey,
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '16:03',
                // style: AppTextStyles.smallTextStyleGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
