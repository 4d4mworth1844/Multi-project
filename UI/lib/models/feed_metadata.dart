class FeedMetadata {
  String? feedKey;
  String? feedName;
  int? status;
  String? type;

  FeedMetadata({this.feedKey, this.feedName, this.status, this.type});

  FeedMetadata.fromJson(Map<String, dynamic> json) {
    feedKey = json['feedKey'];
    feedName = json['feedName'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['feedKey'] = this.feedKey;
    data['feedName'] = this.feedName;
    data['status'] = this.status;
    data['type'] = this.type;
    return data;
  }
}
