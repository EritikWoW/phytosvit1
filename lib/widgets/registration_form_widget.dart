import 'package:flutter/material.dart';
import 'package:phytosvit/view_models/registration_view_model.dart';
import 'package:provider/provider.dart';
import '../style/colors.dart';
import '../generated/l10n.dart';

class RegistrationFormWidget extends StatelessWidget {
  const RegistrationFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);

    return Form(
      key: viewModel.formKey,
      child: Column(
        children: [
          _buildInputField(
            context,
            S.of(context).user_name,
            false,
            false,
            viewModel.nameController,
            viewModel.validateName,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            context,
            S.of(context).user_email,
            false,
            false,
            viewModel.emailController,
            viewModel.validateEmail,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            context,
            S.of(context).user_password,
            true,
            false,
            viewModel.passwordController,
            viewModel.validatePassword,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            context,
            S.of(context).user_confirm_password,
            true,
            true,
            viewModel.confirmPasswordController,
            viewModel.validateConfirmPassword,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: viewModel.submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenTeeColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                S.of(context).button_user_register,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
      BuildContext context,
      String label,
      bool isPassword,
      bool isConfirmPassword,
      TextEditingController controller,
      String? Function(String?) validator) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword || isConfirmPassword,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.greenTeeColor),
        ),
      ),
      validator: validator,
    );
  }
}
