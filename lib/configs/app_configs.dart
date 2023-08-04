class AppConfig {
  static const String appName = 'Easy-Sell';

  // // STAGING

  // static const baseUrl =

  ///Paging
  static const pageSize = 20;
  static const pageSizeMax = 1000;
  static const vietQRURL = "https://img.vietqr.io/image";
  static const vietQRBanks = "https://api.vietqr.io/v2";
  static const vietQRClientId = "fa7b62a5-3593-420d-b6cb-41862fb7127e";
  static const vietQRApiKey = "9f7b5eab-97f6-4471-9d3c-41a78e4b2413";

  ///Local
  static const appLocal = 'vi_VN';

  ///DateFormat
  static const dateAPIFormat = 'dd/MM/yyyy';
  static const dateAPIFormatStrikethrough = 'dd-MM-yyyy';
  static const dateDisplayFormat = 'yyyy-MM-dd';
  static const dateTimeAPIFormat =
      "MM/dd/yyyy'T'hh:mm:ss.SSSZ"; //Use DateTime.parse(date) instead of ...
  static const timeDisplayFormat = 'hh:mm';
  static const dateTimeDisplayFormat = 'dd/MM/yyyy HH:mm';
  static const dateTimeDisplayFormatCheckIn = 'HH:mm dd/MM/yyyy';
  static const bbqReservationDateFormat = 'EEE, dd MMM yyyy HH:mm:ss';

  ///Date range
  static final identityMinDate = DateTime(1900, 1, 1);
  static final identityMaxDate = DateTime.now();
  static final birthMinDate = DateTime(1900, 1, 1);
  static final birthMaxDate = DateTime.now();

  ///Font
  static const fontFamily = 'Roboto';

  ///Max file
  static const maxAttachFile = 5;
  static const maxImageFileSize = 5242880;
  static const maxDocumentFileSize = 10485760;

  //Page size
  static const pageSizeDefault = 6;

  static const stagesLength = 6;
}
