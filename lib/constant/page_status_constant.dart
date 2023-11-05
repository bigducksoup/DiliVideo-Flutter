

import 'package:flutter/material.dart';

const int LOADING = 0;

const int LOADED = 1;

const int ERROR = 2;




class LoadState{


  int status;
  

  LoadState({this.status = LOADING});


  bool get isLoading => status == LOADING;

  bool get isLoaded => status == LOADED;

  bool get isError => status == ERROR;

  int get statusCode => status;

  void setLoading(){
    status = LOADING;
  }


  void setLoaded(){
    status = LOADED;
  }


  void setError(){
    status = ERROR;
  }

  Widget render(Widget loadingWidget, Widget errorWidget ,Widget loadedWidget){
    switch(status){
      case LOADING:
        return loadingWidget;
      case LOADED:
        return loadedWidget;
      case ERROR:
        return errorWidget;
      default:
        return loadingWidget;
    }
  }


}