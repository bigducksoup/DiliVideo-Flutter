
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


  static setStringList(String key,List<String> value)async{
     SharedPreferences localstorge = await SharedPreferences.getInstance();
     localstorge.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key)async{
    SharedPreferences localstorge = await SharedPreferences.getInstance();
    List<String>? value = localstorge.getStringList(key);
    return value;
  }

  static addToStringList(String key,String value)async{
    SharedPreferences localstorge = await SharedPreferences.getInstance();
    List<String>? stringList = localstorge.getStringList(key);
    if(stringList==null){
      List<String> list = [];
      list.add(value);
      await setStringList(key, list);
    }else{
      if(stringList.contains(value)){
        return;
      }
      stringList.add(value);
      await setStringList(key, stringList);
    }
  }

  static clearStringList(String key)async{
    SharedPreferences localstorge = await SharedPreferences.getInstance();
    localstorge.setStringList(key, []);
  }


  static remove(String key)async{
    SharedPreferences localstorge = await SharedPreferences.getInstance();
    return localstorge.remove(key);
  }

}






