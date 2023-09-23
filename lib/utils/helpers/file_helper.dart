import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  Future<FilePickerResult?> openFiles({required FileType type}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
      allowMultiple: true,
    );
    return result;
  }

  // Future<String?> encryptFile(
  //     File file, String keyString, String folder, String fileName) async {
  //   final key = Key.fromUtf8(keyString);
  //   final iv = IV.fromLength(8);
  //   final encrypter = Encrypter(Salsa20(key));

  //   final encryptedFile =
  //       encrypter.encryptBytes(file.readAsBytesSync(), iv: iv);
  //   final directory = await getApplicationDocumentsDirectory();
  //   final encryptedFilePath = '${directory.path}/$folder/$fileName';
  //   final encryptedFileOutput = File(encryptedFilePath);
  //   if (fileExists(encryptedFilePath)) {
  //     await encryptedFileOutput.writeAsBytes(encryptedFile.bytes);
  //     return encryptedFilePath;
  //   } else {
  //     final directoryPath = Directory(encryptedFilePath).parent.path;

  //     final directory = Directory(directoryPath);
  //     if (!(await directory.exists())) {
  //       await directory.create(recursive: true);
  //       await encryptedFileOutput.writeAsBytes(encryptedFile.bytes);
  //       return encryptedFilePath;
  //     } else {
  //       await encryptedFileOutput.writeAsBytes(encryptedFile.bytes);
  //       return encryptedFilePath;
  //     }
  //   }
  // }

  // Future<File> decryptFile(FileSystemEntity file, String keyString) async {
  //   final key = Key.fromUtf8(keyString);
  //   final iv = IV.fromLength(8);
  //   final encrypter = Encrypter(Salsa20(key));
  //   final File ifile =File(file.path);

  //   final encryptedFile = Encrypted(ifile.readAsBytesSync());
  //   final decryptedFile = encrypter.decryptBytes(encryptedFile, iv: iv);

  //   Directory tempDir = await getTemporaryDirectory();
  //   File outFile=File('${tempDir.path}/${ifile.path.split('/').last}');
  //   await outFile.writeAsBytes(decryptedFile);
  //   return  outFile;

  // }

  bool fileExists(String filePath) {
    final file = File(filePath);
    return file.existsSync();
  }

  Future<String?> encryptFileRaw(
      File file, String keyString, String folder, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final encryptedFilePath = '${directory.path}/$folder/$fileName';
    final encryptedFileOutput = File(encryptedFilePath);
    if (fileExists(encryptedFilePath)) {
      await encryptedFileOutput.writeAsBytes(await file.readAsBytes());
      return encryptedFilePath;
    } else {
      final directoryPath = Directory(encryptedFilePath).parent.path;

      final directory = Directory(directoryPath);
      if (!(await directory.exists())) {
        await directory.create(recursive: true);
        await encryptedFileOutput.writeAsBytes(await file.readAsBytes());
        return encryptedFilePath;
      } else {
        await encryptedFileOutput.writeAsBytes(await file.readAsBytes());
        return encryptedFilePath;
      }
    }
  }

  Future<File> decryptFileRwa(FileSystemEntity file, String keyString) async {
    final File ifile = File(file.path);

    return ifile;
  }
}
