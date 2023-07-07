class ChatUserModel {
  ChatUserModel({
    required this.Image,
    required this.About,
    required this.CreatedAt,
    required this.IsOnline,
    required this.LastActive,
    required this.Email,
    required this.PushToken,
    required this.Id,
    required this.Name,
  });
  late String Image;
  late String About;
  late String CreatedAt;
  late bool IsOnline;
  late String LastActive;
  late String Email;
  late String PushToken;
  late String Id;
  late String Name;

  ChatUserModel.fromJson(Map<String, dynamic> json){
    Image = json['Image'];
    About = json['About'];
    CreatedAt = json['Created_at'];
    IsOnline = json['Is_online'];
    LastActive = json['Last_active'];
    Email = json['Email'];
    PushToken = json['Push_token'];
    Id = json['Id'];
    Name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['Image'] = Image;
    data['About'] = About;
    data['Created_at'] = CreatedAt;
    data['Is_online'] = IsOnline;
    data['Last_active'] = LastActive;
    data['Email'] = Email;
    data['Push_token'] = PushToken;
    data['Id'] = Id;
    data['Name'] = Name;
    return data;
  }
}