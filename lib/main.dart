import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'config/routes/routes.dart';
import 'modules/common/logic/bio_auth_bloc/bio_auth_bloc.dart';
import 'modules/common/logic/theme_cubit.dart';
import 'modules/dashboard/screens/dashboard_screens.dart';
import 'utils/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationApi().initNotification();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  // await dotenv.load(fileName: ".env");
  runApp(BlocProvider(
    create: (context) => BioAuthBloc()
      ..add(
        const CheckBioAuthEvent(),
      ),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        {
          // The app has been minimized or switched away from.
          print('hidden');
          context.read<BioAuthBloc>().add( RemoveBioAuthEvent(time: DateTime.now()));
        }

      case AppLifecycleState.resumed:
        {
          print('hidrteteden');
          context.read<BioAuthBloc>().add(const ResumedBioAuthEvent());
          // The app has been resumed.
        }
      default:
        print(state);
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            themeMode: state.theme,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            debugShowCheckedModeBanner: false,
            initialRoute: DashBoardScreen.routeName,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
