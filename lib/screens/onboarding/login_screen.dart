import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:propertycp_customer/screens/home_container/home_container.dart';
import 'package:propertycp_customer/screens/onboarding/register_screen.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/widgets/responsive.dart';

import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../main.dart';
import '../../models/user_model.dart';
import '../../services/api_service.dart';
import '../../services/snakbar_service.dart';
import '../../utils/enum.dart';
import '../../utils/helper_method.dart';
import '../../utils/preference_key.dart';
import '../../utils/theme.dart';
import '../../widgets/gaps.dart';
import '../../widgets/loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routePath = '/loginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneCtrl = TextEditingController();
  final TextEditingController _otpCtrl = TextEditingController();

  String otpCode = '';
  late ApiProvider _api;

  Timer? _timer;
  static const int otpResendThreshold = 10;
  int _secondsRemaining = otpResendThreshold;
  bool _timerActive = false;

  @override
  void dispose() {
    if (_timer != null) _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    _secondsRemaining = otpResendThreshold;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _timerActive = true;
        } else {
          _timer?.cancel();
          _timerActive = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    SnackBarService.instance.buildContext = context;
    _api = Provider.of<ApiProvider>(context);
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Login',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: hintColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView(
      padding: EdgeInsets.symmetric(
        vertical: defaultPadding,
        horizontal: Responsive.isDesktop(context)
            ? width * .35
            : Responsive.isTablet(context)
                ? width * .15
                : defaultPadding,
      ),
      children: [
        Text(
          'Lets start with your mobile number',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontWeight: FontWeight.w900, fontSize: 30),
        ),
        verticalGap(defaultPadding),
        Text(
          'A 6 digit OTP (One Time Password) will be sent as sms to the number provided below',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              // fontWeight: FontWeight.w900,
              ),
        ),
        verticalGap(defaultPadding),
        TextField(
          controller: _phoneCtrl,
          maxLength: 10,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: 'Phone Number',
            label: Text('Phone Number'),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: TextButton(
            onPressed: _timerActive
                ? null
                : () async {
                    if (_phoneCtrl.text.length != 10 ||
                        !isNumeric(_phoneCtrl.text)) {
                      SnackBarService.instance.showSnackBarError(
                          'Enter valid 10 digit mobil number');
                      return;
                    }

                    UserModel? user =
                        await _api.getUserByPhone(_phoneCtrl.text);
                    if (user == null) {
                      SnackBarService.instance.showSnackBarError(
                          'This phone number is not registered');
                      return;
                    }
                    startTimer();
                    otpCode = getOTPCode();
                    log(otpCode);
                    _api.sendOtp(_phoneCtrl.text, otpCode);
                  },
            child: Text(
              _timerActive
                  ? 'Resend in $_secondsRemaining seconds'
                  : 'Send OTP',
            ),
          ),
        ),
        Text(
          'OTP',
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(color: primary, fontWeight: FontWeight.w700),
        ),
        OTPTextField(
          length: 6,
          width: MediaQuery.of(context).size.width - (defaultPadding * 3),
          fieldWidth: 40,
          otpFieldStyle: OtpFieldStyle(
            enabledBorderColor: primary,
            borderColor: Colors.white54,
            focusBorderColor: primary,
          ),
          textFieldAlignment: MainAxisAlignment.spaceAround,
          fieldStyle: FieldStyle.underline,
          onCompleted: (pin) {},
          onChanged: (pin) {
            _otpCtrl.text = pin;
          },
        ),
        verticalGap(defaultPadding * 2),
        ElevatedButton(
          onPressed: _api.status == ApiStatus.loading
              ? null
              : () async {
                  if (_phoneCtrl.text.length != 10 ||
                      !isNumeric(_phoneCtrl.text)) {
                    SnackBarService.instance.showSnackBarError(
                        'Enter valid 10 digit mobile number');
                    return;
                  }

                  if (isTestUser(_phoneCtrl.text, _otpCtrl.text)) {
                  } else if (_otpCtrl.text != otpCode) {
                    SnackBarService.instance.showSnackBarError('Invalid OTP');
                    return;
                  }

                  UserModel? user = await _api.getUserByPhone(_phoneCtrl.text);
                  // UserModel? user = await _api.getUserById(2);
                  if (user == null) {
                    SnackBarService.instance.showSnackBarError(
                        'User not registered with this phone number');
                    return;
                  }

                  if (user.status == UserStatus.SUSPENDED.name ||
                      user.status == UserStatus.BLOCKED.name) {
                    SnackBarService.instance
                        .showSnackBarError('User status is ${user.status}');
                    return;
                  }
                  await prefs.setInt(SharedpreferenceKey.userId, user.id ?? -1);
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomeContainer.routePath, (route) => false);
                },
          child: _api.status == ApiStatus.loading
              ? const LoadingWidget()
              : const Text('Login'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pushReplacementNamed(RegisterScreen.routePath);
          },
          child: const Text('New user? Register'),
        )
      ],
    );
  }

  bool isTestUser(String phone, String otp) {
    if (phone == '9804945122' && otp == '123456') {
      return true;
    }
    return false;
  }
}
