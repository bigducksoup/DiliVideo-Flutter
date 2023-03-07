import 'dio_manager.dart';


Future getAllPartition() async {
  var response = dio.get('/content/partition/getall');
  return response;
}
