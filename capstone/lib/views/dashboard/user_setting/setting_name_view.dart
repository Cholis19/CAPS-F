import 'package:flutter/material.dart';
import 'package:mobile_flutter/shared/buttons.dart';
import 'package:mobile_flutter/shared/custom_appbar.dart';
import 'package:mobile_flutter/shared/form.dart';

class SettingNameView extends StatefulWidget {
  const SettingNameView({super.key});

  @override
  State<SettingNameView> createState() => _SettingNameViewState();
}

class _SettingNameViewState extends State<SettingNameView> {

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: 'Nama Lengkap', isBackButton: true),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nama Lengkap',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              customForm(controller: nameController, hintText: 'your name'),
              const SizedBox(height: 30),
              fullWidthButton(label: 'Perbarui', onPressed: () {
                
              })
            ],
          ),
        ),
      )
    );
  }
}