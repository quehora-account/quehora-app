import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoora/bloc/auth/auth_bloc.dart';
import 'package:hoora/bloc/challenge/challenge_bloc.dart';
import 'package:hoora/bloc/create_crowd_report/create_crowd_report_bloc.dart';
import 'package:hoora/bloc/explore/explore_bloc.dart';
import 'package:hoora/bloc/first_launch/first_launch_bloc.dart';
import 'package:hoora/bloc/nearby_spots_loading/nearby_spots_loading_bloc.dart';
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
import 'package:hoora/repository/super_type_repository.dart';
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

import 'bloc/spotPage/spot_page_bloc.dart';
import 'local_storage.dart';

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
    //FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  /// Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    //FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await LocalStorage.initLocalStorage();
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.debug,
  // );
  /// Null if first time lauching.
  var sharedPreferences = (await SharedPreferences.getInstance());
  String? isFirstLaunch = sharedPreferences.getString(AppConstants.kSSKeyFirstLaunch);

  User? user = FirebaseAuth.instance.currentUser;

  String initialRoute = user != null ? "/home" : "/auth/sign_up";

  sharedPreferences.setBool("watch_first_time_tutorial", false);
  if (isFirstLaunch == null) {
    initialRoute = "/first_launch/welcome";
    sharedPreferences.setBool("watch_first_time_tutorial", true);
  }

  runApp(HooraApp(initialRoute: initialRoute));
}

void trackAppLaunch() {
  String platform = defaultTargetPlatform == TargetPlatform.iOS ? 'iOS' : 'Android';

  FirebaseAnalytics.instance.logEvent(
    name: 'app_launch',
    parameters: {
      'platform': platform,
    },
  );
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
        RepositoryProvider<SuperTypeRepository>(create: (context) => SuperTypeRepository()),
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
              create: (_) => SpotPageBloc(
                areaRepository: context.read<RegionRepository>(),
                crashRepository: context.read<CrashRepository>(),
                offerRepository: context.read<OfferRepository>(),
                companyRepository: context.read<CompanyRepository>(),
              ),
            ),
            BlocProvider(
              create: (_) => NearbySpotsLoadingBloc(
                spotRepository: context.read<SpotRepository>(),
                areaRepository: context.read<RegionRepository>(),
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
                areaRepository: context.read<RegionRepository>(),
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
                superTypeRepository: context.read<SuperTypeRepository>(),
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
                levelRepository: context.read<LevelRepository>(),
                areaRepository: context.read<RegionRepository>()
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
            theme: kTheme.copyWith(scaffoldBackgroundColor: kPrimary),
            title: 'Hoora',
            // initialRoute: "/first_launch/welcome",

            // initialRoute: '/auth/sign_up',
            initialRoute: initialRoute,
            routes: {
              '/first_launch/welcome': (context) => const WelcomePage(),
              '/first_launch/request_geolocation': (context) => const RequestGeolocationPage(),
              '/first_launch/explanation': (context) => ExplanationPage(),
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
