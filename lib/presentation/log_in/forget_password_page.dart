import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/colors.dart';
import 'package:ipicku_dating_app/data/functions/validators.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/presentation/widgets/form_field.dart';
import 'package:ipicku_dating_app/presentation/widgets/logo_widget.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailCheckController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final size = MediaQuery.of(context).size;
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is ResetPasswordFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: AppTheme.red,
              behavior: SnackBarBehavior.floating,
              content: Text("Email not Valid or not registered"),
            ),
          );
        }
        if (state is ResetPasswordInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: AppTheme.grey,
              behavior: SnackBarBehavior.floating,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Loading...."),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Link Sent to your Email...."),
                  Icon(Icons.done_all)
                ],
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.black,
        appBar: AppBar(
          backgroundColor: AppTheme.black,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: AppTheme.white),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const LogoWidget(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FormFieldWidget(
                    controller: emailCheckController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your email ";
                      } else if (!Validators.isValidEmail(value)) {
                        return "Enter your email correctly";
                      }

                      return null;
                    },
                    labelText: "Email",
                    icon: Icons.email_rounded,
                    isPassword: false,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: size.width - 30,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (emailCheckController.text.isNotEmpty) {
                          BlocProvider.of<AuthenticationBloc>(context).add(
                              ResetPasswordRequested(
                                  emailCheckController.text.trim()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text("Send Password Reset mail"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
