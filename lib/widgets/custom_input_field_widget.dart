import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phytosvit/style/colors.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final String? errorMessage;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.isPassword,
    this.errorMessage,
  });

  @override
  CustomInputFieldState createState() => CustomInputFieldState();
}

class CustomInputFieldState extends State<CustomInputField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: SvgPicture.asset(
                      isPasswordVisible
                          ? 'assets/svg/icon_visible.svg'
                          : 'assets/svg/icon_invisible.svg',
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  )
                : Icon(Icons.person, color: AppColors.greenTeeColor),
          ),
        ),
        if (widget.errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
