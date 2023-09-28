
import 'package:get/get.dart';

/// AuthState store runtime user auth state
class AuthState{



  final islogin = false.obs;
  final id = ''.obs;
  final nickname = ''.obs;
  final email = ''.obs;
  final avatarUrl = ''.obs;
  final summary = ''.obs;
  final followerCount = 0.obs;
  final followedCount = 0.obs;
  final publishCount = 0.obs;
  final isBaned = false.obs;
  final level = 0.obs;
  final exp = 0.obs;
  final phoneNumber = ''.obs;
  final birthday = ''.obs;
  final gender = ''.obs;
  final createTime = ''.obs;
  final updateTime = ''.obs;
  final loginIp = ''.obs;
  final wechatId = ''.obs;
  final authToken = ''.obs;

   void init(Map<String,dynamic> infomap){
    
    id.value = infomap['id'];
    
    nickname.value = infomap['nickname'];
    email.value = infomap['email'];
    avatarUrl.value = infomap['avatarUrl'];
    summary.value = infomap['summary'];
    followerCount.value = infomap['followerCount'];
    followedCount.value = infomap['followedCount'];
    publishCount.value = infomap['publishCount'];
    isBaned.value = infomap['isBaned']==1? true:false;
    level.value = infomap['level'];
    exp.value = infomap['exp'];
    phoneNumber.value = infomap['phoneNumber'];
    birthday.value = infomap['birthday'];
    gender.value = infomap['gender']==1? '男':'女';
    createTime.value = infomap['createTime'];
    updateTime.value = infomap['updateTime'];
    loginIp.value = infomap['loginIp'];
    wechatId.value = infomap['wechatId'];
    authToken.value = infomap['authToken'];
    islogin.value = true;

    
  }



  

}



AuthState auth_state =  AuthState();