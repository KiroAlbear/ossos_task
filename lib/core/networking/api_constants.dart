/// [ApiConstants] class
///
/// Contains API constants [BaseURL, EndPoints, Headers] to easily access and modify Test
///
class ApiConstants {
  static String baseUrl = 'https://quraanradiopublic.azurewebsites.net/api/';
  static String getNames({required int page}) =>
      '${baseUrl}HolyNamesOfAllah/GetAll?PageNumber=${page}&SortItem=NumberOfOrder&PageSize=15';
  static String getEvents({required String date}) =>
      '${baseUrl}Events/GetAllByYear?First=${date}';

}
