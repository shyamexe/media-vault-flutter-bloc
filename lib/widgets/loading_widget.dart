import 'package:flutter/widgets.dart';
import 'package:redacted/redacted.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: Container(
          padding: const EdgeInsets.all(12),
          child: const Row(
            children: [
              Text('ng'),
              SizedBox(
                width: 15,
              ),
              Text('imagegfdf.png'),
              Spacer(),
              Text('|'),
              SizedBox(
                width: 15,
              ),
            ],
          )).redacted(
        context: context,
        redact: true,
      ),
    );
  }
}
