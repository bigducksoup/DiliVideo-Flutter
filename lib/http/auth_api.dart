import 'dio_manager.dart';

Future loginbyemail(String email, String password, int timestamp, String ip) async {
  var response = dio.post('/auth/login/login_by_email', data: {
    "email": email,
    "password": password,
    "ip": ip,
    "timestamp": timestamp
  });
  return response;
}


Future checklogin() async {
  var response = dio.get('/auth/login/check_login');
  return response;
}




