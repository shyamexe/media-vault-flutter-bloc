import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

import '../../logic/encript_bloc/encript_bloc.dart';
import '../../logic/file_finder/file_finder_bloc.dart';
import 'document_tile_widget.dart';

class DocList extends StatelessWidget {
  const DocList({super.key});

  // Future<Uint8List> _renderPdf(filePath) async {
  //   final document = await PdfDocument.openFile(filePath);
  //   final page = await document.getPage(1);
  //   final image = await page.render(width: page.width, height: page.height);
  //   await page.close();
  //   await document.close();
  //   return image!.bytes;
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileFinderBloc, FileFinderState>(
      builder: (context, state) {
        if (state is FileFinderLoaded) {
          return state.docfiles.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<FileFinderBloc>()
                        .add(const LoadFileFinderEvent());
                  },
                  child: ListView.builder(
                    itemCount: state.docfiles.length,
                    padding: const EdgeInsets.all(30),
                    itemBuilder: (context, index) => DocumentTileWidget(
                      file: state.docfiles[index],
                      icon: Icons.insert_drive_file_outlined,
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Lottie.asset('assets/animations/nodata.json',
                            fit: BoxFit.fitHeight),
                      ),
                      const Text('Nothing To Show'),
                      IconButton(onPressed: () {
                        context.read<EncriptBloc>().add(const EncryptFilesEvent(type: FileType.any));
                      }, icon: const Icon(Icons.add)),
                      const SizedBox(
                        height: 100,)
                    ],
                  ),
                );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: Lottie.asset('assets/animations/loding.json',
                      fit: BoxFit.fitHeight),
                ),
                if (state is FileFinderFailure && state.error != null)
                  Text(state.error ?? ''),
                if (state is FileFinderFailure)
                  IconButton(
                      onPressed: () {
                        context
                            .read<FileFinderBloc>()
                            .add(const LoadFileFinderEvent());
                      },
                      icon: const Icon(Icons.refresh))
              ],
            ),
          );
        }
      },
    );
  }
}
