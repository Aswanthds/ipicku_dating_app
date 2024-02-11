import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipicku_dating_app/data/functions/validators.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';
import 'package:ipicku_dating_app/domain/firebase_data/firebase_data_bloc.dart';
import 'package:ipicku_dating_app/domain/login_bloc/login_bloc.dart';
import 'package:ipicku_dating_app/presentation/log_in/widgets/create_account.dart';
import 'package:ipicku_dating_app/presentation/log_in/widgets/forget_password.dart';
import 'package:ipicku_dating_app/presentation/log_in/widgets/google_sign_in.dart';
import 'package:ipicku_dating_app/presentation/log_in/widgets/login_button.dart';
import 'package:ipicku_dating_app/presentation/main_page.dart';
import 'package:ipicku_dating_app/presentation/sign_up/profile_signup.dart';
import 'package:ipicku_dating_app/presentation/ui_utils/constants.dart';
import 'package:ipicku_dating_app/presentation/widgets/form_field.dart';

class LoginForm extends StatefulWidget {
  final UserRepository _userRepository;

  const LoginForm({Key? key, required UserRepository userRepository})
      : _userRepository = userRepository,
        super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  late LoginBloc _loginBloc;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  void _onFormSubmitted(BuildContext ctx) {
      BlocProvider.of<FirebaseDataBloc>(context)
        .add(const UpdateUserFieldEvent('notifications_picks', true));
    BlocProvider.of<FirebaseDataBloc>(context)
        .add(const UpdateUserFieldEvent('notifications_messages', true));
    BlocProvider.of<FirebaseDataBloc>(context)
        .add(const UpdateUserFieldEvent('notifications_recomendations', true));
    _loginBloc.add(
      LoginPressed(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()),
    );
  }

  @override
  void dispose() {
    _passwordController.clear();
    _emailController.clear();
    _passwordController.dispose();
    _emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBarManager.profileFailedSnackBar,
            );
        }
        if (state is LoginLoading) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBarManager.profileLoading);
        }
        if (state is LoginSucess) {
          debugPrint("Success");

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    MainPageNav(repository: widget._userRepository),
              ),
              (route) => false);
        }
        if (state is LoginProfileNotSet) {
          debugPrint("Success");

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) =>
                    SignupProfilePage(userRepository: widget._userRepository),
              ),
              (route) => false);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formkey,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset('assets/images/logo_light.png',
                        height: 200),
                  ),
                  FormFieldWidget(
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter your email ";
                      } else if (!Validators.isValidEmail(value)) {
                        return "Enter a valid email address";
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
                      }

                      return null;
                    },
                    labelText: "Password",
                    icon: EvaIcons.lock,
                    isPassword: true,
                  ),
                  const ForgetPasswordText(),
                  GoogleLoginButton(userRepository: widget._userRepository),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LoginButton(
                          onPressed: () {
                            if (_formkey.currentState!.validate()) {
                              return _onFormSubmitted(context);
                            }
                          },
                        ),
                        CreateAccountButton(
                            userRepository: widget._userRepository),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
