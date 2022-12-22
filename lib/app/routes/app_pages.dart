import 'package:get/get.dart';
import '../../constants/api_constants.dart';
import '../../constants/sizeConstant.dart';
import '../../main.dart';
import '../modules/add_item/bindings/add_item_binding.dart';
import '../modules/add_item/views/add_item_view.dart';
import '../modules/add_item_listscreen/bindings/add_item_listscreen_binding.dart';
import '../modules/add_item_listscreen/views/add_item_listscreen_view.dart';
import '../modules/add_item_listscreen_view/bindings/add_item_listscreen_view_binding.dart';
import '../modules/add_item_listscreen_view/views/add_item_listscreen_view_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/image_view/bindings/image_view_binding.dart';
import '../modules/image_view/views/image_view_view.dart';
import '../modules/lock_screen/bindings/lock_screen_binding.dart';
import '../modules/lock_screen/views/lock_screen_view.dart';
import '../modules/permission/bindings/permission_binding.dart';
import '../modules/permission/views/permission_view.dart';
import '../modules/splash_scren/bindings/splash_scren_binding.dart';
import '../modules/splash_scren/views/splash_scren_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String INITIAL = Routes.SPLASH_SCREN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.LOCK_SCREEN,
      page: () => const LockScreenView(),
      binding: LockScreenBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.ADD_ITEM,
      page: () => const AddItemView(),
      binding: AddItemBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.ADD_ITEM_LISTSCREEN,
      page: () => const AddItemListscreenView(),
      binding: AddItemListscreenBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.ADD_ITEM_LISTSCREEN_VIEW,
      page: () => const AddItemListscreenViewView(),
      binding: AddItemListscreenViewBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.IMAGE_VIEW,
      page: () => const ImageViewView(),
      binding: ImageViewBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.PERMISSION,
      page: () => const PermissionView(),
      binding: PermissionBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: _Paths.SPLASH_SCREN,
      page: () => const SplashScrenView(),
      binding: SplashScrenBinding(),
      transition: Transition.cupertino,
    ),
  ];
}
