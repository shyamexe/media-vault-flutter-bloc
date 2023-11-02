import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mediavault/modules/common/logic/update_bloc/update_bloc.dart';
import 'package:mediavault/modules/common/screens/settings.dart';
import 'package:mediavault/modules/dashboard/logic/encript_bloc/encript_bloc.dart';
import 'package:pie_menu/pie_menu.dart';

import '../logic/file_finder/file_finder_bloc.dart';
import 'widget/encripted_files_view.dart';
import 'widget/floating_add_button.dart';

class DashBoardScreen extends StatefulWidget {
  static const String routeName = '/';
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    context.read<FileFinderBloc>().add(const LoadFileFinderEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateBloc, UpdateState>(
      listener: (context, update) {
        if (update is UpdateCheckComplete) {
          showDialog<void>(
            context: context,
            builder: (BuildContext ctx) {
              return BlocProvider.value(
                value: context.read<UpdateBloc>(),
                child: AlertDialog(
                  title: const Text('Update available'),
                  content: const Text(
                      'A new version of SecureDocs is available for download'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Update Now'),
                      onPressed: () {
                        context.read<UpdateBloc>().add(const ImmediateUpdateEvent());
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text(
                        'Download in Background',
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        context.read<UpdateBloc>().add(const FlexibleUpdateEvent());

                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Later'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
        if (update is UpdateInflexible) {
          showDialog<void>(
            context: context,
            builder: (BuildContext ctx) {
              return BlocProvider.value(
                value: context.read<UpdateBloc>(),
                child: AlertDialog(
                  title: const Text('Update Ready to Install'),
                  content: const Text(
                      'The update for SecureDocs is ready to install. Would you like to install it now?'),
                  actions: <Widget>[
                    
                    TextButton(
                      child: const Text(
                        'Install Now',
                        overflow: TextOverflow.ellipsis,
                      ),
                      onPressed: () {
                        context.read<UpdateBloc>().add(const InstallUpdateEvent());

                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Later'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      builder: (context, update) {
        return PieCanvas(
          theme: PieTheme(
            buttonTheme: PieButtonTheme(
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                iconColor: Theme.of(context).colorScheme.onSecondaryContainer
                ),
            pointerColor: Colors.transparent,
            delayDuration: Duration.zero,
            tooltipTextStyle: Theme.of(context).textTheme.headlineLarge,
            tooltipUseFittedBox: false,
            tooltipTextAlign: TextAlign.center,
            // buttonTheme: const PieButtonTheme(
            //   backgroundColor: Colors.black,
            //   iconColor: Colors.white,
            // ),
            buttonThemeHovered: const PieButtonTheme(
              backgroundColor: Colors.transparent,
              iconColor: Colors.transparent,
            ),
            overlayColor: Colors.transparent,
            rightClickShowsMenu: false,
          ),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'SecureDocs Manager',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Settings.routeName,
                    );
                  },
                  icon: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).iconTheme.color,
                  ),
                )
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: BlocConsumer<EncriptBloc, EncriptState>(
              listener: (context, state) {
                if (state is EncriptLoaded) {
                  Future.delayed(
                    const Duration(seconds: 1),
                    () {
                      context.read<FileFinderBloc>().add(
                            const LoadFileFinderEvent(),
                          );
                    },
                  );
                }
              },
              builder: (context, state) {
                if (state is EncriptLoading) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 300,
                        width: double.infinity,
                        child: Lottie.asset(
                          'assets/animations/loding.json',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Text(
                        state.title ?? '',
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  );
                } else {
                  return const EncriptedFilesView();
                }
              },
            ),
            floatingActionButton: const FloatingAddButton(),
          ),
        );
      },
    );
  }
}
