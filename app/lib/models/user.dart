import 'package:brachitek/models/card_elements.dart';

class User{
  String Name; 
  String Surname; 
  String Email; 
  String Company; 
  String Role; 
  String Username; 
  String PhoneNumber; 
  String? Description; 
  String? ProfilePicture;
  List<CardElements>? links = []; 

  User({required this.Username, required this.Name, required this.Surname, required this.Email, required this.Company, required this.Role, required this.PhoneNumber, this.links, this.ProfilePicture});

  setCompanyAndRole(String Company, String Role){
    this.Company = Company; 
    this.Role = Role;
  }

  setDescription(String Description){
    this.Description = Description; 
  }

  setRole(String Role){
    this.Role = Role; 
  }

  setEmail(String Email){
    this.Email =Email;
  }
}