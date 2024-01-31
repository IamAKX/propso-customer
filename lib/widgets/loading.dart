import 'package:flutter/material.dart';
import 'package:propertycp_customer/widgets/gaps.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          child: CircularProgressIndicator(),
          height: 10,
          width: 10,
        ),
        horizontalGap(10),
        const Text('Please wait ...')
      ],
    );
  }
}
