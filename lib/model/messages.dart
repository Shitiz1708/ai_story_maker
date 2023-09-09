class Chat {
  final String msg;
  final int chat;
  Chat({
    required this.msg,
    required this.chat,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        chat: json['chat'],
        msg: json['msg'],
      );
}

class Images {
  final String url;

  Images({
    required this.url,
  });

  factory Images.fromJson(Map<String, dynamic> json) => Images(
        url: json['url'],
      );
}
