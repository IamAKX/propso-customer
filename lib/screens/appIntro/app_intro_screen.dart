import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:propertycp_customer/utils/colors.dart';

import '../onboarding/login_screen.dart';

class AppIntroScreen extends StatefulWidget {
  const AppIntroScreen({super.key});
  static const String routePath = '/appIntroScreen';

  @override
  State<AppIntroScreen> createState() => _AppIntroScreenState();
}

void _onIntroEnd(BuildContext context) {
  Navigator.of(context)
      .pushNamedAndRemoveUntil(LoginScreen.routePath, (route) => false);
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    PageDecoration pageDecoration = const PageDecoration(
      pageColor: Colors.white,
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        allowImplicitScrolling: true,
        autoScrollDuration: 3000,
        pages: [
          PageViewModel(
            titleWidget: _buildTitle('Search various types of properties'),
            bodyWidget: _buildBody(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            image: SvgPicture.asset('assets/svgs/house_search.svg', width: 300),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: _buildTitle('Choose among large numbe of options'),
            bodyWidget: _buildBody(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            image:
                SvgPicture.asset('assets/svgs/choosing_house.svg', width: 300),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: _buildTitle('Buy the house of your dreams'),
            bodyWidget: _buildBody(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            image: SvgPicture.asset('assets/svgs/buy_house.svg', width: 300),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: _buildTitle('Create leads with ease'),
            bodyWidget: _buildBody(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.'),
            image: SvgPicture.asset('assets/svgs/create_leads.svg', width: 300),
            decoration: pageDecoration,
          ),
        ],
        initialPage: 0,
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context), // You can override onSkip callback
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: false,
        // rtl: true, // Display as right-to-left
        back: const Icon(Icons.arrow_back),
        skip: Text('Skip', style: Theme.of(context).textTheme.labelLarge),
        next: const Icon(Icons.arrow_forward),
        done: Text('Start', style: Theme.of(context).textTheme.labelLarge),
        curve: Curves.fastLinearToSlowEaseIn,
        // controlsMargin: const EdgeInsets.all(16),
        controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        dotsContainerDecorator: const ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: textColorDark,
          ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildBody(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelLarge!,
      textAlign: TextAlign.left,
    );
  }
}
