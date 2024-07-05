import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/bloc/challenge/challenge_bloc.dart';
import 'package:hoora/bloc/create_crowd_report/create_crowd_report_bloc.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/bloc/first_launch/first_launch_bloc.dart';
import 'package:hoora/bloc/map/map_bloc.dart';
import 'package:hoora/bloc/offer/offer_bloc.dart';
import 'package:hoora/bloc/project/project_bloc.dart';
import 'package:hoora/bloc/ranking/ranking_bloc.dart';
import 'package:hoora/bloc/transaction/transaction_bloc.dart';
import 'package:hoora/bloc/user/user_bloc.dart';
import 'package:hoora/bloc/validate_spot/validate_spot_bloc.dart';
import 'package:hoora/common/decoration.dart';
import 'package:hoora/common/globals.dart';
import 'package:hoora/repository/challenge_repository.dart';
import 'package:hoora/repository/company_repository.dart';
import 'package:hoora/repository/crowd_report_repository.dart';
import 'package:hoora/repository/level_repository.dart';
import 'package:hoora/repository/offer_repository.dart';
import 'package:hoora/repository/organization_repository.dart';
import 'package:hoora/repository/project_repository.dart';
import 'package:hoora/repository/region_repository.dart';
import 'package:hoora/repository/playlist_repository.dart';
import 'package:hoora/repository/transaction_repository.dart';
import 'package:hoora/ui/page/auth/forgot_password.dart';
import 'package:hoora/ui/page/auth/nickname_page.dart';
import 'package:hoora/ui/page/auth/sign_in.dart';
import 'package:hoora/ui/page/auth/sign_up.dart';
import 'package:hoora/ui/page/auth/sign_up_gift_gems.dart';
import 'package:hoora/ui/page/first_launch/explanation_page.dart';
import 'package:hoora/ui/page/first_launch/welcome_page.dart';
import 'package:hoora/ui/page/first_launch/request_geolocation_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hoora/ui/page/home_page.dart';
import 'package:hoora/repository/auth_repository.dart';
import 'package:hoora/repository/crash_repository.dart';
import 'package:hoora/repository/spot_repository.dart';
import 'package:hoora/repository/user_repository.dart';
import 'package:hoora/ui/page/user/earnings_page.dart';
import 'package:hoora/ui/page/user/level_page.dart';
import 'package:hoora/ui/page/user/settings/faq_page.dart';
import 'package:hoora/ui/page/user/settings/feedback_page.dart';
import 'package:hoora/ui/page/user/settings/privacy_page.dart';
import 'package:hoora/ui/page/user/settings/profile_page.dart';
import 'package:hoora/ui/page/user/settings/settings_page.dart';
import 'package:hoora/ui/page/user/settings/traffic_point_explanation_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Set the application oriention to portrait only.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Set status bar to dark.
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  await Firebase.initializeApp();

  /// Localhost
  // if (true) {
  //   FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  //   FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false, sslEnabled: false);
  //   await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // }

  /// Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  /// Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  /// Null if first time lauching.
  String? isFirstLaunch = (await SharedPreferences.getInstance())
      .getString(AppConstants.kSSKeyFirstLaunch);

  User? user = FirebaseAuth.instance.currentUser;

  String initialRoute = user != null ? "/home" : "/auth/sign_up";
  if (isFirstLaunch == null) {
    initialRoute = "/first_launch/welcome";
  }

  runApp(HooraApp(initialRoute: initialRoute));
}

class HooraApp extends StatelessWidget {
  final String initialRoute;
  const HooraApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
        RepositoryProvider<CrashRepository>(create: (context) => CrashRepository()),
        RepositoryProvider<UserRepository>(create: (context) => UserRepository()),
        RepositoryProvider<SpotRepository>(create: (context) => SpotRepository()),
        RepositoryProvider<RegionRepository>(create: (context) => RegionRepository()),
        RepositoryProvider<PlaylistRepository>(create: (context) => PlaylistRepository()),
        RepositoryProvider<CrowdReportRepository>(create: (context) => CrowdReportRepository()),
        RepositoryProvider<ChallengeRepository>(create: (context) => ChallengeRepository()),
        RepositoryProvider<OfferRepository>(create: (context) => OfferRepository()),
        RepositoryProvider<CompanyRepository>(create: (context) => CompanyRepository()),
        RepositoryProvider<ProjectRepository>(create: (context) => ProjectRepository()),
        RepositoryProvider<OrganizationRepository>(create: (context) => OrganizationRepository()),
        RepositoryProvider<TransactionRepository>(create: (context) => TransactionRepository()),
        RepositoryProvider<LevelRepository>(create: (context) => LevelRepository()),
      ],
      child: Builder(builder: (context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => FirstLaunchBloc(),
            ),
            BlocProvider(
              create: (_) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
                crashRepository: context.read<CrashRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => UserBloc(
                userRepository: context.read<UserRepository>(),
                companyRepository: context.read<CompanyRepository>(),
                offerRepository: context.read<OfferRepository>(),
                levelRepository: context.read<LevelRepository>(),
                crashRepository: context.read<CrashRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => ValidateSpotBloc(
                spotRepository: context.read<SpotRepository>(),
                crashRepository: context.read<CrashRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => CreateCrowdReportBloc(
                crowdReportRepository: context.read<CrowdReportRepository>(),
                crashRepository: context.read<CrashRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => ExploreBloc(
                areaRepository: context.read<RegionRepository>(),
                playlistRepository: context.read<PlaylistRepository>(),
                spotRepository: context.read<SpotRepository>(),
                crashRepository: context.read<CrashRepository>(),
                crowdReportRepository: context.read<CrowdReportRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => MapBloc(
                areaRepository: context.read<RegionRepository>(),
                playlistRepository: context.read<PlaylistRepository>(),
                spotRepository: context.read<SpotRepository>(),
                crashRepository: context.read<CrashRepository>(),
                crowdReportRepository: context.read<CrowdReportRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => ChallengeBloc(
                crashRepository: context.read<CrashRepository>(),
                challengeRepository: context.read<ChallengeRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => RankingBloc(
                userRepository: context.read<UserRepository>(),
                crashRepository: context.read<CrashRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => OfferBloc(
                offerRepository: context.read<OfferRepository>(),
                companyRepository: context.read<CompanyRepository>(),
                crashRepository: context.read<CrashRepository>(),
                levelRepository: context.read<LevelRepository>()
              ),
            ),
            BlocProvider(
              create: (_) => ProjectBloc(
                organizationRepository: context.read<OrganizationRepository>(),
                projectRepository: context.read<ProjectRepository>(),
                crashRepository: context.read<CrashRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => TransactionBloc(
                transactionRepository: context.read<TransactionRepository>(),
                crashRepository: context.read<CrashRepository>(),
              ),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: kTheme,
            title: 'Hoora',
            // initialRoute: "/first_launch/welcome",

            // initialRoute: '/auth/sign_up',
            initialRoute: initialRoute,
            routes: {
              '/first_launch/welcome': (context) => const WelcomePage(),
              '/first_launch/request_geolocation': (context) => const RequestGeolocationPage(),
              '/first_launch/explanation': (context) => const ExplanationPage(),
              '/auth/sign_in': (context) => const SignInPage(),
              '/auth/sign_up': (context) => const SignUpPage(),
              '/auth/sign_up_gift_gems': (context) => const SignUpGiftGemsPage(),
              '/auth/nickname': (context) => const NicknamePage(),
              '/auth/forgot_password': (context) => const ForgotPasswordPage(),
              '/home': (context) => const HomePage(),
              '/home/earnings': (context) => const EarningsPage(),
              '/home/earnings/level': (context) => const LevelPage(),
              '/home/earnings/settings': (context) => const SettingsPage(),
              '/home/earnings/settings/faq': (context) => const FAQPage(),
              '/home/earnings/settings/traffic_point': (context) => const TrafficPointExplanationPage(),
              '/home/earnings/settings/feedback': (context) => const FeedbackPage(),
              '/home/earnings/settings/privacy': (context) => const PrivacyPage(),
              '/home/earnings/settings/profile': (context) => const ProfilePage(),
            },
          ),
        );
      }),
    );
  }
}
