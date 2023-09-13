class CreateChallengeDetails {
  late String ORGANIZER_NAME;
  late String ORGANIZER_ID;
  late String USERID;
  late String TOURNAMENT_ID;
  late String? CATEGORY;
  late String NO_OF_KNOCKOUT_ROUNDS;
  late String ENTRY_FEE;
  late String? GOLD;
  late String? SILVER;
  late String? BRONZE;
  late String? OTHER;
  late String? PRIZE_POOL;
  late String TOURNAMENT_NAME;
  late String CITY;
  late String? TYPE;
  late String LOCATION;
  late String START_DATE;
  late String END_DATE;
  late String START_TIME;
  late String END_TIME;
  late int REGISTRATION_CLOSES_BEFORE;
  late String AGE_CATEGORY;
  late String NO_OF_COURTS;
  late String BREAK_TIME;
  late String? SPORT;
  late String? TEAM_SIZE;
  late String? SUBSTITUTES;
  late String? BALL_TYPE;
  late String? OVERS;

  CreateChallengeDetails({
    required this.ORGANIZER_NAME,
    required this.ORGANIZER_ID,
    required this.USERID,
    required this.TOURNAMENT_ID,
    required this.CATEGORY,
    required this.NO_OF_KNOCKOUT_ROUNDS,
    required this.ENTRY_FEE,
    required this.GOLD,
    required this.SILVER,
    required this.BRONZE,
    required this.OTHER,
    required this.PRIZE_POOL,
    required this.TOURNAMENT_NAME,
    required this.CITY,
    required this.TYPE,
    required this.LOCATION,
    required this.START_DATE,
    required this.END_DATE,
    required this.START_TIME,
    required this.END_TIME,
    required this.REGISTRATION_CLOSES_BEFORE,
    required this.AGE_CATEGORY,
    required this.NO_OF_COURTS,
    required this.BREAK_TIME,
    required this.SPORT,
    required this.TEAM_SIZE,
    required this.SUBSTITUTES,
    required this.BALL_TYPE,
    required this.OVERS,
  });
  Map<String, dynamic> toMap() {
    return {
      "ORGANIZER_NAME": ORGANIZER_NAME,
      "ORGANIZER_ID": ORGANIZER_ID,
      "USERID": USERID,
      "TOURNAMENT_ID": TOURNAMENT_ID,
      "CATEGORY": CATEGORY,
      "NO_OF_KNOCKOUT_ROUNDS": NO_OF_KNOCKOUT_ROUNDS,
      "ENTRY_FEE": ENTRY_FEE,
      "GOLD": GOLD,
      "SILVER": SILVER,
      "BRONZE": BRONZE,
      "OTHER": OTHER,
      "PRIZE_POOL": PRIZE_POOL,
      "TOURNAMENT_NAME": TOURNAMENT_NAME,
      "CITY": CITY,
      "TYPE": TYPE,
      "LOCATION": LOCATION,
      "START_DATE": START_DATE,
      "END_DATE": END_DATE,
      "START_TIME": START_TIME,
      "END_TIME": END_TIME,
      "REGISTRATION_CLOSES_BEFORE": REGISTRATION_CLOSES_BEFORE,
      "AGE_CATEGORY": AGE_CATEGORY,
      "NO_OF_COURTS": NO_OF_COURTS,
      "BREAK_TIME": BREAK_TIME,
      "SPORT": SPORT,
      "TEAM_SIZE": TEAM_SIZE,
      "SUBSTITUTE": SUBSTITUTES,
      "BALL_TYPE": BALL_TYPE,
      "OVERS": OVERS
    };
  }
}



class details {
  late String PoolSize;
  late String TeamSize;
  late String Substitute;
  late String EntryFee;
  late String BallType;
  late String Overs;

  details({
    required this.PoolSize,
    required this.TeamSize,
    required this.Substitute,
    required this.EntryFee,
    required this.BallType,
    required this.Overs,
  });
}
