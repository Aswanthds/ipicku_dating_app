import 'package:flutter/material.dart';

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
          color: Colors.white,
        ),
        labelText: widget.labelText,
        focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(15)),
        errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(15)),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(
            color: Colors.red,
            style: BorderStyle.solid,
          ),
        ),
        labelStyle: const TextStyle(color: Colors.white),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          borderSide: BorderSide(
            color: Colors.white,
            style: BorderStyle.solid,
          ),
        ),
      ),
      //autovalidate: true,
      style: const TextStyle(
        color: Colors.white,
      ),
      autocorrect: false,
      validator: widget.validator,
    );
  }
}
