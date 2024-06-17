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
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(colors: [
            AppTheme.pinkAccent,
            AppTheme.red,
          ])),
      child: Container(
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          controller: widget._controller,
          obscureText: widget.isPassword && !_obscureText,
          decoration: InputDecoration(
            // filled: true,
            // fillColor: Colors.white,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(!_obscureText
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                widget.icon,
                color: AppTheme.black,
              ),
            ),
            labelText: widget.labelText,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            labelStyle: const TextStyle(color: AppTheme.black),
          ),
          style: const TextStyle(
            color: AppTheme.black,
          ),
          autocorrect: false,
          validator: widget.validator,
        ),
      ),
    );
  }
}
