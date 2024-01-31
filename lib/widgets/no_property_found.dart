import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/colors.dart';
import '../utils/theme.dart';
import 'gaps.dart';

class NoPropertyFound extends StatelessWidget {
  const NoPropertyFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/svgs/not_found.svg',
            width: 300,
          ),
          verticalGap(defaultPadding),
          Text(
            'No property found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: hintColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
