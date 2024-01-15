import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
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
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              content: Text("Email not Valid or not registered"),
            ),
          );
        }
        if (state is ResetPasswordInProgress) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 2),
              backgroundColor: Colors.grey,
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
                  Icon(EvaIcons.doneAll)
                ],
              ),
            ),
          );
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: kPrimary,
            appBar: AppBar(
              backgroundColor: kPrimary,
              automaticallyImplyLeading: true,
              iconTheme: const IconThemeData(color: Colors.white),
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
                        icon: EvaIcons.emailOutline,
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
                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<AuthenticationBloc>(context).add(
                                  ResetPasswordRequested(
                                      emailCheckController.text.trim()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
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
          );
        },
      ),
    );
  }
}
