import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/constants.dart';
import 'package:ipicku_dating_app/data/functions/validators.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/auth_bloc/authentication_bloc.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_bloc.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_event.dart';
import 'package:ipicku_dating_app/domain/signup_bloc/sign_up_state.dart';
import 'package:ipicku_dating_app/presentation/sign_up/widgets/forget_password.dart';
import 'package:ipicku_dating_app/presentation/sign_up/widgets/register_button.dart';
import 'package:ipicku_dating_app/presentation/widgets/form_field.dart';
import 'package:ipicku_dating_app/presentation/widgets/logo_widget.dart';

class RegisterForm extends StatefulWidget {
  final UserRepository userRepository;
  const RegisterForm({super.key, required this.userRepository});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  void initState() {
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);

    super.initState();
  }

  bool isSignUpButtonEnabled(SignUpState state) {
    return !state.isSubmitting;
  }

  void _onFormSubmitted() {
    BlocProvider.of<SignUpBloc>(context).add(
      SignUpPressed(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentMaterialBanner()
            ..showSnackBar(
              failedSignUp,
            );
        }

        if (state.isSubmitting) {
          debugPrint("isSubmitting");

          ScaffoldMessenger.of(context).showSnackBar(
            submitiingSignUp,
          );
        }
        if (state.isSuccess) {
          debugPrint("Success");
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  const LogoWidget(),
                  const RegisterTitle(),
                  FormFieldWidget(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your email ";
                      } else if (!Validators.isValidEmail(value)) {
                        return "Enter your email correctly";
                      }

                      return null;
                    },
                    labelText: "Email",
                    icon: EvaIcons.email,
                    isPassword: false,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FormFieldWidget(
                    controller: _passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your password ";
                      } else if (!Validators.isValidPassword(value)) {
                        return "Enter your password correctly";
                      }

                      return null;
                    },
                    labelText: "Password",
                    icon: EvaIcons.lock,
                    isPassword: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: isPopulated
                        ? RegisterButton(
                            onPressed: isSignUpButtonEnabled(state)
                                ? _onFormSubmitted
                                : null)
                        : ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: const Text("Register"),
                          ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    icon: const Icon(EvaIcons.google, color: Colors.white),
                    onPressed: () async {
                      final account =
                          await widget.userRepository.performGoogleSignIn();
                      BlocProvider.of<SignUpBloc>(context)
                          .add(GoogleSignUpEvent(account: account));
                    },
                    label: const Text('Sign in with Google',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onEmailChanged() {
    BlocProvider.of<SignUpBloc>(context).add(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    BlocProvider.of<SignUpBloc>(context).add(
      PasswordChanged(password: _passwordController.text),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }
}
