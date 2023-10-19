import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediavault/modules/common/logic/theme_cubit.dart';

import '../logic/download_path_cubit.dart';

class Settings extends StatelessWidget {
  static const String routeName = '/settings';
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.close_rounded,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: BlocBuilder<DownloadPathCubit, DownloadPathState>(
          builder: (context, pathState) {
            return Column(
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('Security Lock'),
                        trailing: CupertinoSwitch(
                          value: pathState.isLockEnabled,
                          onChanged: (value) {
                            context
                                .read<DownloadPathCubit>()
                                .updateLock(value, context);
                          },
                        ),
                      ),
                      ListTile(
                         
                        title: const Text('Automatically lock'),
                        trailing: DropdownButton(
                          underline: const SizedBox(),
                          value: pathState.lockTime,
                          items: [10, 30, 60, 80]
                              .map<DropdownMenuItem>(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    'After $e Sec',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            context.read<DownloadPathCubit>().updateLockTime(value);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Card(
                  child: Column(
                    children: [
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) {
                          return ListTile(
                              title: const Text('Theme'),
                              trailing: DropdownButton<ThemeMode>(
                                underline: const SizedBox(),
                                value: state.theme,
                                onChanged: (value) {
                                  context
                                      .read<ThemeCubit>()
                                      .changeTheme(value ?? ThemeMode.system);
                                },
                                items: ThemeMode.values
                                    .map<DropdownMenuItem<ThemeMode>>(
                                        (ThemeMode value) {
                                  return DropdownMenuItem<ThemeMode>(
                                    value: value,
                                    child:Text(value.name.toString()),
                                  );
                                }).toList(),

                                ),
                              // trailing: DropdownMenu<ThemeMode>(
                              //   inputDecorationTheme:
                              //       const InputDecorationTheme(
                              //     border: InputBorder.none,
                              //   ),
                              //   onSelected: (value) {
                              //     context
                              //         .read<ThemeCubit>()
                              //         .changeTheme(value ?? ThemeMode.system);
                              //   },
                              //   initialSelection: state
                              //       .theme, // Make sure `state.theme` is defined and has a valid value
                              //   dropdownMenuEntries: ThemeMode.values
                              //       .map<DropdownMenuEntry<ThemeMode>>(
                              //           (ThemeMode value) {
                              //     return DropdownMenuEntry<ThemeMode>(
                              //       value: value,
                              //       label: value.name.toString(),
                              //     );
                              //   }).toList(),
                              // )
                              );
                        },
                      ),
                      ListTile(
                        onTap: () {
                          context.read<DownloadPathCubit>().updatePath();
                        },
                        title: const Text('Downloads folder'),
                        subtitle: Text('~${pathState.path}'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                // const Card(
                //   child: ListTile(
                //     title: Text('Clear Files'),
                //     subtitle: Text('Delete all secured Files'),
                //   ),
                // ),
                const SizedBox(
                  height: 60,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('Built with Flutter'),
                    SizedBox(
                      height: 10,
                    ),
                    FlutterLogo(),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
