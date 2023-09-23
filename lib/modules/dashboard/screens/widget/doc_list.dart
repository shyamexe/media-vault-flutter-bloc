import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pdfx/pdfx.dart';

import '../../logic/file_finder/file_finder_bloc.dart';

class DocList extends StatelessWidget {
  const DocList({super.key});

  Future<Uint8List> _renderPdf(filePath) async {
    final document = await PdfDocument.openFile(filePath);
    final page = await document.getPage(1);
    final image = await page.render(width: page.width, height: page.height);
    await page.close();
    await document.close();
    return image!.bytes;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FileFinderBloc, FileFinderState>(
      builder: (context, state) {
        if (state is FileFinderLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<FileFinderBloc>().add(const LoadFileFinderEvent());
            },
            child: ListView.builder(
              itemCount: state.docfiles.length,
              padding: const EdgeInsets.all(30),
              itemBuilder: (context, index) => Card(
                child: Column(
                  children: [
                    SizedBox(
                      width: 150,
                      child: state.docfiles[index].path
                                  .split('.')
                                  .last
                                  .toLowerCase() ==
                              'pdf'
                          ? FutureBuilder<Uint8List>(
                              future: _renderPdf(state.docfiles[index].path),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return SizedBox(
                                    height: 150,
                                    child: Container(
                                        color: Colors.white,
                                        child: Image.memory(snapshot.data!)),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.description_rounded,
                              ),
                            ),
                    ),
                    ListTile(
                      title: Text(state.docfiles[index].path.split('/').last),
                      trailing: PopupMenuButton(
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                          PopupMenuItem(
                            onTap: () {
                              context.read<FileFinderBloc>().add(
                                  OpenFileFinderEvent(state.docfiles[index]));
                            },
                            value: 1,
                            child: const Text('Open'),
                          ),
                          PopupMenuItem(
                            onTap: () {},
                            value: 2,
                            child: const Text('Export'),
                          ),
                          PopupMenuItem(
                            onTap: () {
                              context.read<FileFinderBloc>().add(
                                  DeleteFileFinderEvent(
                                      file: state.docfiles[index]));
                            },
                            value: 3,
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
