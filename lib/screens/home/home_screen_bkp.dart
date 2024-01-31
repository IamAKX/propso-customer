import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:propertycp_customer/utils/colors.dart';
import 'package:propertycp_customer/utils/constants.dart';
import 'package:propertycp_customer/widgets/gaps.dart';

import '../../utils/theme.dart';

class HomeScreenBkp extends StatefulWidget {
  const HomeScreenBkp({super.key, required this.switchTabs});
  final Function(int index) switchTabs;

  @override
  State<HomeScreenBkp> createState() => _HomeScreenBkpState();
}

class _HomeScreenBkpState extends State<HomeScreenBkp> {
  String selectedOption = 'Bengaluru Urban';
  int selectedPropertyId = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'PropertyC',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {},
              child: ClipRRect(
                borderRadius: BorderRadius.circular(homePageProfilePic),
                child: (false)
                    // ignore: dead_code
                    ? Image.asset(
                        'assets/images/profile_image_placeholder.png',
                        height: homePageProfilePic,
                        width: homePageProfilePic,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: '',
                        fit: BoxFit.cover,
                        width: homePageProfilePic,
                        height: homePageProfilePic,
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/profile_image_placeholder.png',
                          width: homePageProfilePic,
                          height: homePageProfilePic,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
      body: getBody(context),
    );
  }

  getBody(BuildContext context) {
    return Column(
      children: [
        header(context),
        Row(
          children: [
            horizontalGap(defaultPadding),
            Text(
              propertyType
                      .firstWhere((element) => element.id == selectedPropertyId)
                      .name ??
                  '',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
              ),
            ),
            horizontalGap(defaultPadding),
          ],
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Container();
            },
          ),
        ),
      ],
    );
  }

  header(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalGap(80),
              // Padding(
              //   padding: const EdgeInsets.all(defaultPadding),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'PropertyCP',
              //         style:
              //             Theme.of(context).textTheme.headlineLarge?.copyWith(
              //                   fontWeight: FontWeight.bold,
              //                 ),
              //       ),
              //       InkWell(
              //         onTap: () {},
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(homePageProfilePic),
              //           child: (false)
              //               ? Image.asset(
              //                   'assets/images/profile_image_placeholder.png',
              //                   height: homePageProfilePic,
              //                   width: homePageProfilePic,
              //                   fit: BoxFit.cover,
              //                 )
              //               : CachedNetworkImage(
              //                   imageUrl: userProfilePic,
              //                   fit: BoxFit.cover,
              //                   width: homePageProfilePic,
              //                   height: homePageProfilePic,
              //                   placeholder: (context, url) =>
              //                       const CircularProgressIndicator(),
              //                   errorWidget: (context, url, error) =>
              //                       Image.asset(
              //                     'assets/images/profile_image_placeholder.png',
              //                     width: homePageProfilePic,
              //                     height: homePageProfilePic,
              //                   ),
              //                 ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(
              //       horizontal: defaultPadding, vertical: defaultPadding / 2),
              //   child: RichText(
              //     text: TextSpan(
              //       text: 'Hey, ',
              //       style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              //           fontWeight: FontWeight.bold, letterSpacing: 0.8),
              //       children: <TextSpan>[
              //         TextSpan(
              //           text: 'John Doe!\n',
              //           style: Theme.of(context)
              //               .textTheme
              //               .headlineSmall
              //               ?.copyWith(
              //                   color: primary,
              //                   fontWeight: FontWeight.bold),
              //         ),
              //         const TextSpan(text: 'Let\'s start exploring'),
              //       ],
              //     ),
              //   ),
              // ),
              Card(
                elevation: defaultPadding / 2,
                margin: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding / 2,
                ),
                child: Container(
                  padding: const EdgeInsets.all(defaultPadding / 2),
                  margin: const EdgeInsets.fromLTRB(
                    defaultPadding,
                    defaultPadding * 3,
                    defaultPadding,
                    defaultPadding,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: dividerColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LineAwesomeIcons.search,
                        color: hintColor,
                      ),
                      horizontalGap(defaultPadding / 2),
                      Text(
                        'Search by Appartment name',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: hintColor),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  horizontalGap(defaultPadding),
                  const Icon(
                    LineAwesomeIcons.map_pin,
                    size: 18,
                    color: textColorDark,
                  ),
                  Text(
                    'Area',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: textColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  horizontalGap(defaultPadding),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                      items: karnatakaDistricts
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  )
                ],
              )
            ],
          ),
          Card(
            elevation: defaultPadding / 2,
            margin: const EdgeInsets.fromLTRB(
              defaultPadding * 2,
              defaultPadding,
              defaultPadding * 2,
              defaultPadding,
            ),
            child: Container(
              height: 110,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: propertyType.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedPropertyId =
                            propertyType.elementAt(index).id ?? 1;
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.all(defaultPadding / 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            propertyType.elementAt(index).iconPath!,
                            width: 40,
                            color: propertyType.elementAt(index).id ==
                                    selectedPropertyId
                                ? primary
                                : hintColor,
                          ),
                          verticalGap(defaultPadding / 2),
                          Flexible(
                            child: Text(
                              propertyType.elementAt(index).name!,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: propertyType.elementAt(index).id ==
                                            selectedPropertyId
                                        ? primary
                                        : hintColor,
                                    fontWeight:
                                        propertyType.elementAt(index).id ==
                                                selectedPropertyId
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
