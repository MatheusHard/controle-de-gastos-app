
class UserDTO {
  int? id;
  String? createdAt;
  String? updatedAt;
  String? username;
  String? email;

  UserDTO(
      {this.id,
        this.createdAt,
        this.updatedAt,
        this.username,
        this.email
        });

  UserDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    createdAt = json['createdAt'] ?? "";
    updatedAt = json['updatedAt'] ?? "";
    username = json['username'] ?? "";
    email = json['email'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['username'] = username;
    data['email'] = email;
    return data;
  }
}
