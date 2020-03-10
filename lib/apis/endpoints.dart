

class Endpoints {

  static const String ZENITH_API_BASE_URL = "https://webservicestest.zenithbank.com:8443/ZenithAccountService/api/";

  static const String GATEWAY_BASE_API_URL = "https://41.203.113.10:8443/api/";

//  static const String GATEWAY_BASE_API_URL = "http://41.138.171.45:8444/api/"; //Staging Environment
  static String getOccupationUrl() {
    return '$ZENITH_API_BASE_URL'
        'accounts/Occupations';
  }


  static String getAccountClassesUrl() {
    return '$ZENITH_API_BASE_URL'
        'accounts/AccountClass';
  }

  static String getTitlesUrl() {
    return '$ZENITH_API_BASE_URL'
        'accounts/Titles';
  }

  static String getStatesUrl() {
    return '$ZENITH_API_BASE_URL'
        'accounts/States';
  }


  static String getCountriesUrl() {
    return '$ZENITH_API_BASE_URL'
        'accounts/Countries';
  }

  static String getCitiesUrl() {
    return '$ZENITH_API_BASE_URL'
        'accounts/Cities';
  }


  static String getLoginUrl() {
    return '$GATEWAY_BASE_API_URL'
        'Security/authUser';
  }

  static String getAccountsByRsmIdUrl() {
    return '$GATEWAY_BASE_API_URL'
        'accounts/GetAccountsByRsmID/';
  }

  static String getVerifyAccountsByRefIdUrl() {
    return '$GATEWAY_BASE_API_URL'
        'accounts/VerifyReferenceID/';
  }

  static String getSaveAccountsUrl() {
    return '$GATEWAY_BASE_API_URL'
        'accounts/SaveAccount/';
  }

  static String getBvnUrl() {
    return '$GATEWAY_BASE_API_URL'
        'accounts/VerifySingleBVN/';
  }

  static String getAccountDetailsUrl() {
    return '$GATEWAY_BASE_API_URL'
        'accounts/GetAccountByRefID/';
  }


}