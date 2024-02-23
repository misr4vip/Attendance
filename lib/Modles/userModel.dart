class UserModel {
  String id = " ";
  String name = " ";
  String email = " ";
  String password = " ";
  String userType = " ";

  UserModel.m();
  UserModel.n(this.id, this.name, this.email, this.password, this.userType);
  toDictionary() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "userType": userType
    };
  }

  String getuserName() {
    return name;
  }

  String getuserType() {
    return userType;
  }

  String getEmail() {
    return email;
  }

  String getPassword() {
    return password;
  }

  String getId() {
    return id;
  }

  UserModel.z(Map value) {
    id = value['id'] as String;
    name = value['name'] as String;
    email = value['email'] as String;
    password = value['password'] as String;
    userType = value['userType'] as String;
  }
}
