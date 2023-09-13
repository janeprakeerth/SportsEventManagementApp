class ModelOrderID {
  ModelOrderID({required this.orderID, required this.status});
  late final String orderID;
  late final int status;

  ModelOrderID.fromJson(Map<String, dynamic> json) {
    orderID = json['orderID'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['orderID'] = orderID;
    _data['status'] = status;
    return _data;
  }
}
