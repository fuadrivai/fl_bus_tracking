class Pickup {
  String? childName;
  String? childID;
  String? childDivision;
  String? childDriver;
  String? mode;

  Pickup(
      {this.childName,
      this.childID,
      this.childDivision,
      this.childDriver,
      this.mode});

  Pickup.fromJson(Map<String, dynamic> json) {
    childName = json['childName'];
    childID = json['childID'];
    childDivision = json['childDivision'];
    childDriver = json['childDriver'];
    mode = json['mode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['childName'] = childName;
    data['childID'] = childID;
    data['childDivision'] = childDivision;
    data['childDriver'] = childDriver;
    data['mode'] = mode;
    return data;
  }
}
