
class TextHelper {
  final availableFiletypes = {
    {"3gp": 'video'},
    {"asf": 'video'},
    {"avi": 'video'},
    {"m4u": 'video'},
    {"m4v": 'video'},
    {"mov": 'video'},
    {"mp4": 'video'},
    {"mpe": 'video'},
    {"mpeg": 'video'},
    {"mpg": 'video'},
    {"mpg4": 'video'},
    {"bmp": 'image'},
    {"gif": 'image'},
    {"jpeg": 'image'},
    {"jpg": 'image'},
    {"png": 'image'},
    {"m3u": "audio"},
    {"m4a": "audio"},
    {"m4b": "audio"},
    {"m4p": "audio"},
    {"mp2": "audio"},
    {"mp3": "audio"},
    {"mpga": "audio"},
    {"ogg": "audio"},
    {"rmvb": "audio"},
    {"wav": "audio"},
    {"wma": "audio"},
    {"opus": "audio"},
    {"wmv": "audio"}
  };

  String checkFile(String fileType) {
    if (availableFiletypes.map((e) => e.keys.contains(fileType)).isNotEmpty) {
      return availableFiletypes
        .where((e) => e.keys.any((element) => element == fileType))
        .map((e) => e[fileType])
        .toString();
    } else {
      return 'any';
    }
    
  }
}
