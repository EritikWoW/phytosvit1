// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phytosvit/database/user_dao.dart';
import 'package:phytosvit/screens/settings_screen.dart';
import 'package:phytosvit/services/user_sync_service.dart';
import 'package:phytosvit/view_models/login_view_model.dart';
import 'package:provider/provider.dart';
import '../generated/l10n.dart';
import '../style/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<LoginViewModel>(context, listen: false);
      try {
        viewModel.autoLogin(context);
      } catch (e) {
        debugPrint("Ошибка автоматического входа: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(
        userDao: Provider.of<UserDao>(context, listen: false),
        syncService: Provider.of<UserSyncService>(context, listen: false),
      ),
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
                        SvgPicture.asset(
                          'assets/svg/login_logo.svg',
                          width: 30,
                          height: 26,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: 310,
                          child: Text(
                            S.of(context).login_header_1,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          S.of(context).login_header_2,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 47),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17.0),
                    child: Consumer<LoginViewModel>(
                      builder: (context, viewModel, child) {
                        return Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: viewModel.emailController,
                                decoration: InputDecoration(
                                  labelText: S.of(context).user_email,
                                  hintStyle: TextStyle(
                                    color: AppColors.textInputColorDay,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.greenTeeColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.inputBorderColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              TextField(
                                controller: viewModel.passwordController,
                                obscureText: !viewModel.isPasswordVisible,
                                decoration: InputDecoration(
                                  labelText: S.of(context).user_password,
                                  suffixIcon: IconButton(
                                    icon: Icon(viewModel.isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed:
                                        viewModel.togglePasswordVisibility,
                                  ),
                                  hintStyle: TextStyle(
                                    color: AppColors.textInputColorDay,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.greenTeeColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: AppColors.inputBorderColor,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          viewModel.toggleRememberMe();
                                        },
                                        child: SvgPicture.asset(
                                          viewModel.rememberMe
                                              ? 'assets/svg/login_checkbox_checked.svg'
                                              : 'assets/svg/login_checkbox_unchecked.svg',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ),
                                      Text(
                                        S.of(context).login_remember_me,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Forgot Password Logic
                                    },
                                    child: Text(
                                      S.of(context).login_forgot_password,
                                      style: TextStyle(
                                        color: AppColors.yellow,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final isAuthenticated = await viewModel
                                        .authenticateUser(context);
                                    if (!mounted) return;
                                    if (isAuthenticated) {
                                      Navigator.of(context)
                                          .pushReplacementNamed('/main');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.greenTeeColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  child: Text(
                                    S.of(context).user_sign_in,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pushNamed('/registration');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.greenTeeColor,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minimumSize: Size(double.infinity, 50),
                                  ),
                                  child: Text(
                                    S.of(context).register_now,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AppSettings()),
            );
          },
          backgroundColor: AppColors.greenTeeColor,
          child: const Icon(Icons.settings, color: Colors.white),
        ),
      ),
    );
  }
}
