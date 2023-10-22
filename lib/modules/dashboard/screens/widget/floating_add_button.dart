// import 'package:animated_fab_button_menu/animated_fab_button_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediavault/modules/dashboard/logic/encript_bloc/encript_bloc.dart';
import 'package:pie_menu/pie_menu.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(bottom: 20),
      child: PieMenu(
        actions: [
          PieAction(
            tooltip: const Text('Add Documents'), 
            onSelect: (){
                context.read<EncriptBloc>().add( EncryptFilesEvent(type: FileType.any,context: context));
            }, 
            child: Icon(
              Icons.file_present_sharp,
              color: Theme.of(context).iconTheme.color,
            ),),
          PieAction(

            tooltip: const Text('Add Images'), 
            onSelect: (){
                context.read<EncriptBloc>().add( EncryptFilesEvent(type: FileType.image, context: context));
            }, 
            child: Icon(
              Icons.image,
              color: Theme.of(context).iconTheme.color,
            ),),
          PieAction(
            tooltip: const Text('Add Videos'), 
            onSelect: (){
                context.read<EncriptBloc>().add( EncryptFilesEvent(type: FileType.video,context: context));
            }, 
            child: Icon(
              Icons.movie,
              color: Theme.of(context).iconTheme.color,
            ),),
        ],
        child: const FloatingActionButton(onPressed: null, child: Icon(Icons.add)))
      
      //  FabMenu(
      //   fabBackgroundColor: Theme.of(context).iconTheme.color,
      //       elevation: 2.0,
      //       fabAlignment: Alignment.bottomCenter,
      //       fabIcon: const Icon(Icons.add),
      //       closeMenuButton:   Icon(
      //         Icons.arrow_back,
      //         color: Theme.of(context).iconTheme.color,
      //       ),
      //       overlayOpacity: .8,
      //       overlayColor: Theme.of(context).cardColor,
      //       children: [
      //          MenuItem(
      //           title: 'Add Documents',
      //           onTap: () {
      //             context.read<EncriptBloc>().add( EncryptFilesEvent(type: FileType.any,context: context));
      //             Navigator.pop(context);
      //           },
      //           style:  TextStyle(
      //               color: Theme.of(context).iconTheme.color,
      //               fontSize: 24,
      //               fontWeight: FontWeight.bold),
      //         ),
      //         MenuItem(
      //           title: 'Add Images',
      //           onTap: () {
      //             context.read<EncriptBloc>().add( EncryptFilesEvent(type: FileType.image, context: context));
      //             Navigator.pop(context);
      //             },
      //           style:  TextStyle(
      //               color: Theme.of(context).iconTheme.color,
      //               fontSize: 24,
      //               fontWeight: FontWeight.bold),
      //         ),
      //         MenuItem(
      //           title: 'Add Videos',
      //           onTap: () {
      //             context.read<EncriptBloc>().add( EncryptFilesEvent(type: FileType.video,context: context));
      //             Navigator.pop(context);
      //           },
      //           style:  TextStyle(
      //               color: Theme.of(context).iconTheme.color,
      //               fontSize: 24,
      //               fontWeight: FontWeight.bold),
      //         ),
      //       ],
      // ),
    );
  }
}