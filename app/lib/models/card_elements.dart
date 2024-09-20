import 'package:brachitek/models/platforms.dart';

class CardElements {
  Platforms platform; 
  String? url; 

  CardElements({required this.platform, this.url});

  editUrl(String Url){
    this.url = Url;  
  }
  
}