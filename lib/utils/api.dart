class Api {
  static const String baseUrl = 'https://13.48.104.206:7242';

  static const String user = '$baseUrl/api/users/';
  static const String properties = '$baseUrl/api/properties/';
  static const String leads = '$baseUrl/api/leads/';

  static String buildOtpUrl(String phone, String otp) {
    return 'https://api.textlocal.in/send/?apikey=NmY0ZjM5NTI2NTcxNjE3MTY5NDg1NjQ1NjU0NzUzNjc%3D&message=Your%20OTP%20for%20phone%20verification%20for%20Tech%20Sharp%20is%20$otp&sender=TCHSRP&numbers=91$phone';
  }

  static const String sendEmail = '$baseUrl/enquiry';
}
