import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:min_chat/app/shared/ui/app_button.dart';

class StartGroupchatScreen extends StatefulWidget {
  const StartGroupchatScreen({super.key});

  static const String name = '/startGroupchat';

  @override
  State<StartGroupchatScreen> createState() => _StartGroupchatScreenState();
}

class _StartGroupchatScreenState extends State<StartGroupchatScreen> {
  final List<Contact> _contacts = [
    // Add your contacts here
    Contact(name: 'Alice'),
    Contact(name: 'Bob'),
    Contact(name: 'Charlie'),
  ];

  bool _isCreateGroupButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          'Start Group Chat',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          ListView.separated(
            itemCount: _contacts.length,
            shrinkWrap: true,
            padding: const EdgeInsets.all(8),
            separatorBuilder: (context, index) => const Gap(8),
            itemBuilder: (context, index) {
              final contact = _contacts[index];
              return CheckboxListTile(
                activeColor: Colors.black,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.3, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // shape: const CircleBorder(side: BorderSide()),
                title: Text(contact.name),
                subtitle: const Text('2939933BH'),
                value: contact.isSelected,
                onChanged: (selected) {
                  setState(() {
                    contact.isSelected = selected!;
                    _updateCreateGroupButtonState();
                  });
                },
              );
            },
          ),
          const Gap(80),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.bottomRight,
              child: AppIconButton(
                text: 'Start Conversation',
                color: Colors.black,
                icon: Container(),
                height: 40,
                // width: 130,
                onPressed: _isCreateGroupButtonEnabled
                    ? () {
                        // Implement group creation logic using selected contacts
                      }
                    : null,
              ),
              // child: ElevatedButton(
              //   style: ButtonStyle(),
              //   onPressed: _isCreateGroupButtonEnabled
              //       ? () {
              //           // Implement group creation logic using selected contacts
              //         }
              //       : null,
              //   child: const Text('Create Group'),
              // ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateCreateGroupButtonState() {
    setState(() {
      _isCreateGroupButtonEnabled =
          _contacts.any((contact) => contact.isSelected);
    });
  }
}

class Contact {
  Contact({required this.name, this.isSelected = false});
  final String name;
  bool isSelected;
}
