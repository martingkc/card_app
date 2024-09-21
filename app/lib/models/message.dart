class Message {
  String emitter; 
  String receiver; 
  String body; 
  int sentAt; 

  Message({required this.emitter,required this.receiver,required this.body,required this.sentAt});
}