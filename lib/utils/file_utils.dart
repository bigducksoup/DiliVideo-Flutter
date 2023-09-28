import 'dart:io';



// split file into chunks
class FileChunker {
  // 默认块大小
  static const int DEFAULT_CHUNK_SIZE = 1024 * 1024; // 默认块大小为 1MB

  // 分块
  static List<File> chunkSync(File file, [int chunkSize = DEFAULT_CHUNK_SIZE * 10]) {
    List<int> bytes = file.readAsBytesSync(); // 读取文件为字节数组

    List<File> chunks = [];

    int index = 0;
    for (int i = 0; i < bytes.length; i += chunkSize) {
      int end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
      List<int> chunkBytes = bytes.sublist(i, end); // 将字节数组切割为指定大小的块
      String chunkFilename = '${file.path}_$index'; // 构造块文件名
      File chunkFile = File(chunkFilename);
      chunkFile.writeAsBytesSync(chunkBytes); // 将块写入文件
      chunks.add(chunkFile);
      index++;
    }
    return chunks;
  }
}