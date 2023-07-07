class MessageModel {
  MessageModel({
    required this.fromId,
    required this.msg,
    required this.type,
    required this.toId,
    required this.sent,
    required this.read,
  });
  late final String fromId;
  late final String msg;
  late final Type type;
  late final String toId;
  late final String sent;
  late final String read;

  MessageModel.fromJson(Map<String, dynamic> json){
    fromId = json['formId'].toString();
    msg = json['msg'].toString();
    type = json['type'].toString() == Type.image.name ? Type.image : Type.text;
    toId = json['told'].toString();
    sent = json['sent'].toString();
    read = json['read'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formId'] = fromId;
    data['msg'] = msg;
    data['type'] = type;
    data['told'] = toId;
    data['sent'] = sent;
    data['read'] = read;
    return data;
  }
}
enum Type{text,image}