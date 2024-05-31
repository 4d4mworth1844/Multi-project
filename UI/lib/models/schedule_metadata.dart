class ScheduleMetadata {
  int? id;
  String? timeOn;
  String? timeOff;
  String? createdAt;
  String? changedAt;
  String? feedKey;
  String? feedName;
  int? status;
  String? type;

  ScheduleMetadata(
      {this.id,
      this.timeOn,
      this.timeOff,
      this.createdAt,
      this.changedAt,
      this.feedKey,
      this.feedName,
      this.status,
      this.type});

  ScheduleMetadata.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timeOn = json['time_on'];
    timeOff = json['time_off'];
    createdAt = json['created_at'];
    changedAt = json['changed_at'];
    feedKey = json['feedKey'];
    feedName = json['feedName'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['time_on'] = this.timeOn;
    data['time_off'] = this.timeOff;
    data['created_at'] = this.createdAt;
    data['changed_at'] = this.changedAt;
    data['feedKey'] = this.feedKey;
    data['feedName'] = this.feedName;
    data['status'] = this.status;
    data['type'] = this.type;
    return data;
  }
}
