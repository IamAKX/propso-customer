import 'package:flutter/material.dart';
import 'package:propertycp_customer/screens/enquiry/enquiry_screen.dart';
import 'package:propertycp_customer/screens/onboarding/login_screen.dart';
import 'package:propertycp_customer/screens/onboarding/register_screen.dart';

import '../models/property_media.dart';
import '../models/property_model.dart';
import '../models/property_short_model.dart';
import '../screens/adminlead/lead_list.dart';
import '../screens/adminlead/lead_users.dart';
import '../screens/edit_property.dart/edit_property_image.dart';
import '../screens/edit_property.dart/edit_property_text.dart';
import '../screens/edit_property.dart/edit_property_video.dart';
import '../screens/home_container/home_container.dart';
import '../screens/leads/create_lead.dart';
import '../screens/leads/lead_comment.dart';
import '../screens/profile/kyc/kyc.dart';
import '../screens/profile/post_property/pick_propert_images.dart';
import '../screens/profile/post_property/pick_propert_video.dart';
import '../screens/profile/post_property/post_property_screen.dart';
import '../screens/profile/users/user_detail.dart';
import '../screens/profile/users/user_list.dart';
import '../screens/property_listing/property_detail.dart';
import '../screens/property_listing/property_listing_screen.dart';
import '../widgets/custom_image_viewer.dart';
import '../widgets/custom_video_player.dart';
import '../widgets/video_gallery.dart';

class NavRoute {
  static MaterialPageRoute<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routePath:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RegisterScreen.routePath:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case HomeContainer.routePath:
        return MaterialPageRoute(builder: (_) => const HomeContainer());
      case LeadCommentScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => LeadCommentScreen(
                  leadId: settings.arguments as int,
                ));
      case PropertyListingScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => PropertyListingScreen(
            params: settings.arguments as List<String?>,
          ),
        );
      case PropertyDetailScreen.routePath:
        return MaterialPageRoute(
          builder: (_) => PropertyDetailScreen(
            propertyId: settings.arguments as int,
          ),
        );
      case CreateLead.routePath:
        return MaterialPageRoute(
          builder: (_) => CreateLead(
            propertyShortModel: settings.arguments as PropertyShortModel,
          ),
        );
      case KycScreen.routePath:
        return MaterialPageRoute(builder: (_) => const KycScreen());
      case AllLeadUserScreen.routePath:
        return MaterialPageRoute(builder: (_) => const AllLeadUserScreen());
      case AdminLeadList.routePath:
        return MaterialPageRoute(
            builder: (_) => AdminLeadList(
                  userId: settings.arguments as int,
                ));
      case PostProperty.routePath:
        return MaterialPageRoute(builder: (_) => const PostProperty());
      case CustomVideoPlayer.routePath:
        return MaterialPageRoute(
            builder: (_) => CustomVideoPlayer(
                  videoUrl: settings.arguments as String,
                ));
      case CustomImageViewer.routePath:
        return MaterialPageRoute(
            builder: (_) => CustomImageViewer(
                  link: settings.arguments as List<String>,
                ));
      case VideoGallery.routePath:
        return MaterialPageRoute(
            builder: (_) => VideoGallery(
                  link: settings.arguments as List<PropertyMedia>,
                ));
      case PickPropertyImages.routePath:
        return MaterialPageRoute(
            builder: (_) => PickPropertyImages(
                  model: settings.arguments as PropertyModel,
                ));
      case PickPropertyVideos.routePath:
        return MaterialPageRoute(
            builder: (_) => PickPropertyVideos(
                  model: settings.arguments as PropertyModel,
                ));
      case UserListScreen.routePath:
        return MaterialPageRoute(builder: (_) => const UserListScreen());
      case EditPropertyText.routePath:
        return MaterialPageRoute(
          builder: (_) => EditPropertyText(
            propertyId: settings.arguments as int,
          ),
        );
      case EditPropertyImage.routePath:
        return MaterialPageRoute(
          builder: (_) => EditPropertyImage(
            propertyId: settings.arguments as int,
          ),
        );
      case EditPropertyVideo.routePath:
        return MaterialPageRoute(
          builder: (_) => EditPropertyVideo(
            propertyId: settings.arguments as int,
          ),
        );
      case UserDetail.routePath:
        return MaterialPageRoute(
            builder: (_) => UserDetail(
                  userId: settings.arguments as int,
                ));
      case EnquiryScreen.routePath:
        return MaterialPageRoute(
            builder: (_) => EnquiryScreen(
                  propertyId: settings.arguments as int,
                ));
      default:
        return errorRoute();
    }
  }
}

errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return const Scaffold(
      body: Center(
        child: Text('Undefined route'),
      ),
    );
  });
}
