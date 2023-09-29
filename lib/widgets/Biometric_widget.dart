import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:mediavault/modules/common/logic/bio_auth_bloc/bio_auth_bloc.dart';

class BiometricWidget extends StatefulWidget {
  const BiometricWidget({
    super.key,
  });

  @override
  State<BiometricWidget> createState() => _BiometricWidgetState();
}

class _BiometricWidgetState extends State<BiometricWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BioAuthBloc, BioAuthState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 150,
                  width: 150,
                  child: Lottie.asset(
                    'assets/animations/bio.json',
                  ),
                ),
                if (state is BioAuthFailed || state is BioAuthSuspended)
                  IconButton(
                      onPressed: () {
                        context.read<BioAuthBloc>().add(
                              const CheckBioAuthEvent(),
                            );
                      },
                      icon: const Icon(Icons.refresh))
              ],
            ),
          ),
        );
      },
    );
  }
}
