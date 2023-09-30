import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediavault/modules/common/logic/bio_auth_bloc/bio_auth_bloc.dart';
import 'package:mediavault/modules/common/logic/download_path_cubit.dart';
import 'package:mediavault/modules/common/logic/theme_cubit.dart';
import 'package:mediavault/modules/dashboard/logic/encript_bloc/encript_bloc.dart';
import 'package:mediavault/modules/dashboard/logic/file_finder/file_finder_bloc.dart';

import '../../modules/common/screens/settings.dart';
import '../../modules/dashboard/screens/dashboard_screens.dart';
import '../../widgets/biometric_widget.dart';

/// AppRouter is a class that handles the generation of routes in the app.
class AppRouter {
  /// Private constructor to prevent instance creation.
  const AppRouter._();

  /// A static method that generates a route based on the provided [settings].
  ///
  /// This method takes a [RouteSettings] object as input, which contains
  /// information about the route being generated. It returns a [Route<dynamic>]
  /// object based on the name of the route in the [settings].
  ///
  /// If the route name matches the [DashBoardScreen.routeName], it returns
  /// a [MaterialPageRoute] with a [DashBoardScreen] as its builder.
  ///
  /// If the route name doesn't match any known routes, it throws a [Scaffold]
  /// with a centered [Text] widget displaying 'Route not found!'
  ///
  /// Usage:
  /// ```dart
  /// final route = AppRouter.onGenerateRoute(settings);
  /// Navigator.of(context).pushNamed(DashBoardScreen.routeName);
  /// ```  /// A static method that generates a route based on the provided [settings].
  ///
  /// This method takes a [RouteSettings] object as input, which contains
  /// information about the route being generated. It returns a [Route<dynamic>]
  /// object based on the name of the route in the [settings].
  ///
  /// If the route name matches the [DashBoardScreen.routeName], it returns
  /// a [MaterialPageRoute] with a [DashBoardScreen] as its builder.
  ///
  /// If the route name doesn't match any known routes, it throws a [Scaffold]
  /// with a centered [Text] widget displaying 'Route not found!'
  ///
  /// Usage:
  /// final route = AppRouter.onGenerateRoute(settings);
  /// Navigator.of(context).pushNamed([DashBoardScreen.routeName]);
  ///

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DashBoardScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocBuilder<BioAuthBloc, BioAuthState>(
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => EncriptBloc(),
                  ),
                  BlocProvider(
                    create: (context) => FileFinderBloc(),
                  ),
                  BlocProvider.value(
                    value: context.read<BioAuthBloc>(),
                  ),
                ],
                child: (state is BioAuthSuccess ||state is BioAuthSuspended)
                    ? const DashBoardScreen()
                    : const BiometricWidget(),
              );
            },
          ),
        );
      case Settings.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: context.read<ThemeCubit>(),
                  ),
                  BlocProvider(
                    create: (context) => DownloadPathCubit(),
                  ),
                ],
                child: const Settings(),
              );
            },
          ),
        );
      default:
        throw const Scaffold(
          body: Center(
            child: Text('Route not found!'),
          ),
        );
    }
  }
}
