class UserData {
  late String _id;
  late String TOURNAMENT_ID;
  late String TOURNAMENT_NAME;
  late bool STATUS;
  late String LOCATION;
  late String CITY;
  late String TYPE;
  late String START_DATE;
  late String COLOR;
  late String END_DATE;
  late String START_TIME;
  late String END_TIME;
  late String SPORT;
  late bool CANCELLATION_STATUS;
  late String CATEGORY;
  late List PARTICIPANTS;
  late int NO_OF_KNOCKOUT_ROUNDS;
  late List SPOT_STATUS_ARRAY;
  late int PRIZE_POOL;
  late int ENTRY_FEE;
  late String IMG_URL;
  late String ORGANIZER_NAME;
  late String ORGANIZER_ID;
  late List MATCHES;
  late int __v;
  late List spotStatusArray;
  UserData(
    this._id,
    this.TOURNAMENT_ID,
    this.TOURNAMENT_NAME,
    this.STATUS,
    this.LOCATION,
    this.CITY,
    this.TYPE,
    this.START_DATE,
    this.COLOR,
    this.END_DATE,
    this.START_TIME,
    this.END_TIME,
    this.SPORT,
    this.CANCELLATION_STATUS,
    this.CATEGORY,
    this.PARTICIPANTS,
    this.NO_OF_KNOCKOUT_ROUNDS,
    this.SPOT_STATUS_ARRAY,
    this.PRIZE_POOL,
    this.ENTRY_FEE,
    this.IMG_URL,
    this.ORGANIZER_NAME,
    this.ORGANIZER_ID,
    this.MATCHES,
    this.__v,
    this.spotStatusArray,
  );

  UserData.fromJson(Map<String, dynamic> json) {
    _id = json['_id'];
    TOURNAMENT_ID = json['TOURNAMENT_ID'];
    TOURNAMENT_NAME = json['TOURNAMENT_NAME'];
    STATUS = json['STATUS'];
    LOCATION = json['LOCATION'];
    CITY = json['CITY'];
    TYPE = json['TYPE'];
    START_DATE = json['START_DATE'];
    COLOR = json['COLOR'];
    END_DATE = json['END_DATE'];
    START_TIME = json['START_TIME'];
    END_TIME = json['END_TIME'];
    SPORT = json['SPORT'];
    CANCELLATION_STATUS = json['CANCELLATION_STATUS'];
    CATEGORY = json['CATEGORY'];
    PARTICIPANTS = ['PARTICIPANTS'];
    NO_OF_KNOCKOUT_ROUNDS = json['NO_OF_KNOCKOUT_ROUNDS'];
    SPOT_STATUS_ARRAY = json['SPOT_STATUS_ARRAY'];
    PRIZE_POOL = json['PRIZE_POOL'];
    ENTRY_FEE = json['ENTRY_FEE'];
    IMG_URL = json['IMG_URL'];
    ORGANIZER_NAME = json['ORGANIZER_NAME'];
    ORGANIZER_ID = json['ORGANIZER_ID'];
    MATCHES = json['MATCHES'];
    __v = json['__v'];
    spotStatusArray = json['spotStatusArrays'] ?? [];
  }
}
