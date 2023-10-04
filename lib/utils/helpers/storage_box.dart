import 'package:get_storage/get_storage.dart';

class Storagebox {
  final box = GetStorage();
  String lockKey='lock';

  bool isLockEnabled(){
   return box.read(lockKey)??false;
  }

  updateLock(bool value){
    box.write(lockKey, value);
  }
}