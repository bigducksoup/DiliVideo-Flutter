


import 'package:get/get.dart';

void routeToUserPage(id){
       Get.toNamed('/user_info',parameters: {
       "userId":id
     });
}