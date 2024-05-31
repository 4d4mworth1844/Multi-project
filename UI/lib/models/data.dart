class Data {
  int? id;
  String? time;
  int? value;
  String? feedKey;

  Data({this.id, this.time, this.value, this.feedKey});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time_'];
    value = json['value'];
    feedKey = json['feedKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time_'] = this.time;
    data['value'] = this.value;
    data['feedKey'] = this.feedKey;
    return data;
  }
}
