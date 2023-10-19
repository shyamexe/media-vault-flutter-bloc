import 'package:get_storage/get_storage.dart';

class Storagebox {
  final box = GetStorage();
  String lockKey='lock';
  String lockTime='lockTime';

  bool isLockEnabled(){
   return box.read(lockKey)??false;
  }

  updateLock(bool value){
    box.write(lockKey, value);
  }

  int getLockTime(){
    return box.read(lockTime)??60;
  }

  updateLockTime(int seconds){
   box.write(lockTime, seconds);
  }
}