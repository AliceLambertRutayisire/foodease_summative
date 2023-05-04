
class StudentModel {
   String? uid;
   String? email;
  

  StudentModel({this.uid, this.email, required String password});

  // receiving data from the server
  factory StudentModel.fromMap(map) {
    return StudentModel(
      uid: map['uid'],
      email: map['email'], 
      password: map['password'],
      
    );
  }
 
  // sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    
    };
  }

  
}