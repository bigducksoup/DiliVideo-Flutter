
import 'package:shared_preferences/shared_preferences.dart';



class LocalStorge{




  static getValue(String key,type)async{

    SharedPreferences localstorge = await SharedPreferences.getInstance();

    type = type.toString().toLowerCase();
    switch(type){
      case 'bool':
        return localstorge.getBool(key);
      
      case 'int' :
        return localstorge.getInt(key);

      case 'double':
        return localstorge.getDouble(key);

      case 'string':
        return localstorge.getString(key);

    }

  }



   static setValue(String key,val)async{

      SharedPreferences localstorge = await SharedPreferences.getInstance();
    
    dynamic type = val.runtimeType;

    type = type.toString().toLowerCase();

    
    switch(type){
      case 'bool':
        return localstorge.setDouble(key, val);
      
      case 'int' :
        return localstorge.setInt(key,val);

      case 'double':
        return localstorge.setDouble(key,val);

      case 'string':
        return localstorge.setString(key,val);

    }

  }

}






