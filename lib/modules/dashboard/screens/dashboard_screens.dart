import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mediavault/modules/common/screens/settings.dart';
import 'package:mediavault/modules/dashboard/logic/encript_bloc/encript_bloc.dart';

import '../logic/file_finder/file_finder_bloc.dart';
import 'widget/encripted_files_view.dart';
import 'widget/floating_add_button.dart';

class DashBoardScreen extends StatefulWidget {
  static const String routeName = '/';
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>{
   @override
  void initState() {
    context.read<FileFinderBloc>().add(const LoadFileFinderEvent());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        elevation: 0,
        backgroundColor: Colors.transparent,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingAddButton(),
    );
  }
}
