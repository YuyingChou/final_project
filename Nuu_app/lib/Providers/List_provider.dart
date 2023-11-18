import 'package:flutter/material.dart';

class ListProvider extends ChangeNotifier{
  String listId = '';
  String userId = '';
  String anotherUserId = '';
  bool reserved = false;
  String startingLocation = '';
  String destination = '';
  DateTime selectedDateTime = DateTime.now();
  bool wantToFindRide = false;
  bool wantToOfferRide = false;

  //點擊卡片時使用
  void setList(String newListId, String newUserId, String newAnotherUserId, bool newReserved, String newStartingLocation,String newDestination, DateTime newSelectedDateTime, bool newWantToFindRide, bool newWantToOfferRide) {
    listId = newListId;
    userId = newUserId;
    anotherUserId = newAnotherUserId;
    reserved = newReserved;
    startingLocation = newStartingLocation;
    destination = newDestination;
    selectedDateTime = newSelectedDateTime;
    wantToFindRide = newWantToFindRide;
    wantToOfferRide = newWantToOfferRide;

    //notifyListeners();
  }

  //預約行程
  void setReserved(String newAnotherUserId, bool newReserved){
    anotherUserId = newAnotherUserId;
    reserved = newReserved;
    notifyListeners();
  }
}