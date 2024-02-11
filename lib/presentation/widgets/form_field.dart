import 'package:flutter/material.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';

class FormFieldWidget extends StatefulWidget {
  const FormFieldWidget({
    super.key,
    required TextEditingController controller,
    required this.validator,
    this.labelText,
    required this.icon,
    required this.isPassword,
  }) : _controller = controller;

  final TextEditingController _controller;
  final String? labelText;
  final String? Function(String?)? validator;
  final IconData icon;
  final bool isPassword;

  @override
  State<FormFieldWidget> createState() => _FormFieldWidgetState();
}

class _FormFieldWidgetState extends State<FormFieldWidget> {
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget._controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        icon: Icon(
          widget.icon,
          color: AppTheme.white,
        ),
        labelText: widget.labelText,
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.white),
            borderRadius: BorderRadius.circular(15)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.red),
            borderRadius: BorderRadius.circular(15)),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(
            color: AppTheme.red,
            style: BorderStyle.solid,
          ),
        ),
        labelStyle: const TextStyle(color: AppTheme.white),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(
            color: AppTheme.white,
            style: BorderStyle.solid,
          ),
        ),
      ),
      style: const TextStyle(
        color: AppTheme.white,
      ),
      autocorrect: false,
      validator: widget.validator,
    );
  }
}
