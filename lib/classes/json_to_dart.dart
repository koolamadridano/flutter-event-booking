class UserGoogleAccount {
  String? id;
  String? name;
  String? email;
  String? avatar;

  UserGoogleAccount({this.id, this.name, this.email, this.avatar});

  UserGoogleAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['avatar'] = avatar;
    return data;
  }
}
