import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class product{
  String name;
  int number;
  int price;
  String category;
  String time;
  String place;
  String other;
  File image;
  product(this.name,this.category,this.number,this.price,this.time,this.place,this.other,this.image);
}
List<product>newproduct=[];

void addproduct(String name,String category,int number,int price,String time,String place,String other,File image){
  newproduct.add(product(name,category, number, price, time, place, other, image));

}
class book{
  String bookname;
  String isbn;
  int total=0;
  File bookImage;
  book(this.bookImage,this.bookname,this.isbn,this.total);
}
List<book>newbook=[];

void addbook(File bookImage,String bookname,String isbn,int total){
  newbook.add(book(bookImage,bookname, isbn,total));
}

class supply{
  String place;
  int price=0;
  supply(this.price,this.place);
}
List<supply>newsupply=[];

void addsupply(int t,int price,String place){
  newsupply[t].place=place;
  newsupply[t].price=price;
}

class order{
  List<DateTime> Times = [];
  int quantity;
  int sum;
  int productid;
  String notes;
  order(this.Times,this.quantity,this.sum,this.productid,this.notes);
}
List<order>neworder=[];

void addorder(List<DateTime> time,int quantity,int sum,int productid,String notes){
  neworder.add(order(time,quantity, sum,productid,notes));
}
