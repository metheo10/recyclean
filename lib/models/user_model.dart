class User {
  late final int id;
  late final String name;
  late final String phone;
  late final String email;
  late final String password;
  // late final String? profile_photo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    // required this.profile_photo,
  });

factory User.fromjson(Map<String, dynamic> json){
    return switch(json){
      {
      "id" : int id,
      "name" : String name,
      "email" : String email,
      "phone" :String phone,
      "password" :String password,
      // "profile_photo" :String? profile_photo,
      } =>
          User(
              id: id,
              name: name,
              email : email,
              phone: phone,
              password: password,
              // profile_photo: profile_photo,
              ),
      _ => throw const FormatException("Failed")
  };
  }

}
