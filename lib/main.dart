import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'config/routes/routes.dart';
import 'modules/common/logic/bio_auth_bloc/bio_auth_bloc.dart';
import 'modules/common/logic/theme_cubit.dart';
import 'modules/dashboard/screens/dashboard_screens.dart';
import 'utils/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  NotificationApi().initNotification();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
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
          context
              .read<BioAuthBloc>()
              .add(RemoveBioAuthEvent(time: DateTime.now()));
        }

      case AppLifecycleState.resumed:
        {
          context.read<BioAuthBloc>().add(const ResumedBioAuthEvent());
          // The app has been resumed.
        }
      default:
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return DynamicColorBuilder(
            builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
              return MaterialApp(
                themeMode: state.theme,
                theme: ThemeData.light().copyWith(
                  useMaterial3: true,
                  colorScheme: lightDynamic
                ),
                darkTheme: ThemeData.dark().copyWith(
                  useMaterial3: true,
                  colorScheme: darkDynamic
                ),
                debugShowCheckedModeBanner: false,
                initialRoute: DashBoardScreen.routeName,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            }
          );
        },
      ),
    );
  }
}
