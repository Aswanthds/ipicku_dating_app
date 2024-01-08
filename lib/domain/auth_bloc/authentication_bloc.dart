import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ipicku_dating_app/data/repositories/user_repositories.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  AuthenticationBloc({required this.userRepository})
      : super(IntialAuthenticationState()) {
    // on<AuthenticationEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    Stream<AuthenticationState> mapEventToState(
        AuthenticationEvent event) async* {
      if (event is AppStarted) {
        yield* mapAppStartToState();
      } else if (event is LoggedIn) {
        yield* mapLoggedInState();
      } else if (event is LoggedOut) {
        yield* mapLoggedOutToState();
      }
    }
  }

  Stream<AuthenticationState> mapAppStartToState() async* {
    try {
      yield AuthenticationLoading(true);
      final isSigned = await userRepository.isSignedIn();
      if (isSigned) {
        final userId = await userRepository.getUser();
        final isFirst = await userRepository.isFirstTime(userId);

        if (!isFirst) {
          yield AuthenticationSucessButNotSet(userId);
        } else {
          yield AuthenticationSuccess(userId);
        }
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> mapLoggedInState() async* {
    final isFirstTime =
        await userRepository.isFirstTime(await userRepository.getUser());

    if (!isFirstTime) {
      yield AuthenticationSucessButNotSet(await userRepository.getUser());
    } else {
      yield AuthenticationSuccess(await userRepository.getUser());
    }
  }

  Stream<AuthenticationState> mapLoggedOutToState() async* {
    yield Unauthenticated();
    userRepository.signOut();
  }
}
