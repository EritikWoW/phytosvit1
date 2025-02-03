import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:phytosvit/database/user_dao.dart';
import 'package:phytosvit/generated/l10n.dart';
import 'package:phytosvit/view_models/registration_view_model.dart';
import 'package:phytosvit/widgets/registration_form_widget.dart';
import 'package:provider/provider.dart';
import '../style/colors.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegistrationViewModel(userDao: UserDao()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(color: AppColors.greenTeeColor),
                ),
                Expanded(
                  flex: 1,
                  child: Container(color: AppColors.lightBackgroundColor),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 109),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        SvgPicture.asset('assets/svg/login_logo.svg'),
                        const SizedBox(height: 24),
                        Text(
                          S.of(context).registration_header_1,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              S.of(context).registration_header_2,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                S.of(context).login_back_to_login,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.yellow,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17.0),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const RegistrationFormWidget(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
