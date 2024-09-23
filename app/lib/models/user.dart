
class User{
  String name; 
  String surname; 
  String email; 
  String company; 
  String role; 
  String username; 
  String phoneNumber; 
  String? description; 
  String? profilePicture;

  User({required this.username, required this.name, required this.surname, required this.email, required this.company, required this.role, required this.phoneNumber, this.profilePicture});

  setCompanyAndRole(String Company, String Role){
    this.company = Company; 
    this.role = Role;
  }

  setDescription(String Description){
    this.description = Description; 
  }

  setRole(String Role){
    this.role = Role; 
  }

  setEmail(String Email){
    this.email =Email;
  }

  Map<String,String> serialize(){
    return {
      'username' : username, 
      'name':name,
      'surname':surname,
      'company':company,
      'role': role,
      'email': email, 
      'phone_number': phoneNumber,
      'profile_picture': profilePicture ?? ''
    };
  }
}