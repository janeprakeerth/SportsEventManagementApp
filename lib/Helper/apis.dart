//server base url
const String baseUrl =
    'http://ec2-52-66-209-218.ap-south-1.compute.amazonaws.com:3000/';

// all post request API's declaration

final Uri getUserLoginApi = Uri.parse('${baseUrl}userLogin');
final Uri searchDoublesPartnerApi = Uri.parse('${baseUrl}searchDoublesPartner');
final Uri baseTournamentsApi = Uri.parse('${baseUrl}baseTournaments');
final Uri createUserApi = Uri.parse('${baseUrl}createUser');
final Uri rzpPaymentApi = Uri.parse('${baseUrl}rzp_payment');
final Uri tourneyExistsApi = Uri.parse('${baseUrl}tourney_exists');
final Uri createMultipleTournamentApi =
    Uri.parse('${baseUrl}createMultipleTournament');
final Uri updatePerMatchEstimatedTimeApi =
    Uri.parse('${baseUrl}updatePerMatchEstimatedTime');
final Uri walkoverApi = Uri.parse('${baseUrl}walkover');
final Uri rulesApi = Uri.parse('${baseUrl}rules');
final Uri addDoublesPartnerApi = Uri.parse('${baseUrl}addDoublesPartner');
final Uri findUserByIDApi = Uri.parse('${baseUrl}findUserByID');
final Uri removeUserApi = Uri.parse('${baseUrl}removeUser');
final Uri resetpwdOtpgenApi = Uri.parse('${baseUrl}resetpwdOtpgen');
final Uri updatePwdApi = Uri.parse('${baseUrl}updatePwd');

// all get request API's declaration

const String testAPI = '';
