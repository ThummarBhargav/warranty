import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../../../../constants/api_constants.dart';
import '../../../../main.dart';
import '../../../models/categoriesModels.dart';
import '../../../routes/app_pages.dart';
import '../../add_item_listscreen/controllers/add_item_listscreen_controller.dart';
import '../../home/controllers/home_controller.dart';

class AddItemController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Rx<TextEditingController> itemnamecontroller = TextEditingController().obs;
  Rx<TextEditingController> durationcontroller = TextEditingController().obs;
  Rx<TextEditingController> detailscontroller = TextEditingController().obs;
  Rx<TextEditingController> dateController = TextEditingController(
          text: DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()))
      .obs;
  Rx<TextEditingController> selectDateController = TextEditingController(
          text: DateFormat('dd/MM/yyyy').format(DateTime.now()))
      .obs;
  RxString Date = "".obs;
  SingleValueDropDownController? dropDownController;
  SingleValueDropDownController? notificationController;
  HomeController? homeController;
  RxInt expireDay = 0.obs;
  RxInt days = 0.obs;
  RxInt selectedExpireDay = 0.obs;
  RxString selectedExpireName = "".obs;
  RxInt selectedExpireSec = 0.obs;
  RxInt id = 0.obs;
  AddItemListscreenController? addItemListscreenController;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<TimeOfDay> selectedTime = TimeOfDay.now().obs;
  bool isFromHome = false;
  RxBool isDurationEmpty = false.obs;
  RxBool isNameEmpty = false.obs;
  bool isFromEdit = false;
  bool isFromInnerScreen = false;
  RxList<NotificationDataModel> notificationList =
      RxList<NotificationDataModel>([
    NotificationDataModel(value: 0, title: "SameDays Ago"),
    NotificationDataModel(value: 1, title: "1 Days Ago"),
    NotificationDataModel(value: 2, title: "2 Days Ago"),
    NotificationDataModel(value: 3, title: "3 Days Ago"),
    NotificationDataModel(value: 4, title: "4 Days Ago"),
    NotificationDataModel(value: 5, title: "5 Days Ago"),
    NotificationDataModel(value: 6, title: "6 Days Ago"),
    NotificationDataModel(value: 7, title: "Week Ago"),
  ]);
  RxString formattedTime = "".obs;
  String categoryName = "";
  dataModels? additemListview;
  RxList<String>? files = RxList<String>([]);
  RxList<String>? files1 = RxList<String>([]);
  RxString notificationDays = "".obs;
  late final LocalNotificationService service;

  @override
  void onInit() {
    service = LocalNotificationService(controller: AddItemController());
    service.intialize();
    durationcontroller.value.text = "0";
    notificationController = SingleValueDropDownController(
      data: DropDownValueModel(
          name: notificationList[0].title, value: notificationList[0].value),
    );

    // listenToNotification();
    Get.lazyPut(() => AddItemListscreenController());
    addItemListscreenController = Get.find<AddItemListscreenController>();
    Get.lazyPut(() => HomeController());
    homeController = Get.find<HomeController>();
    if (Get.arguments != null) {
      isFromHome = Get.arguments[ArgumentConstant.isFromHome];
      isFromEdit = Get.arguments[ArgumentConstant.isFromEdit];
      isFromInnerScreen = Get.arguments[ArgumentConstant.isFromInnerScreen];

      if (isFromEdit) {
        additemListview = Get.arguments[ArgumentConstant.additemListview];
        itemnamecontroller.value.text = additemListview!.ItemName.toString();
        durationcontroller.value.text = additemListview!.Duration.toString();
        detailscontroller.value.text = additemListview!.Ditails.toString();
        dateController.value.text = additemListview!.Date.toString();
        files!.value = additemListview!.Image.toString().split(" ");
        files1!.value = additemListview!.Bill.toString().split(" ");
        formattedTime.value = additemListview!.pickedTime.toString();
        id.value = additemListview!.id!;
        days.value = int.parse(additemListview!.Duration.toString());
        selectedExpireName.value =
            additemListview!.selectedExpireName.toString();
        selectedExpireDay.value =
            int.parse(additemListview!.selectedExpireDay.toString());
        formattedTime.value = additemListview!.pickedTime.toString();
        notificationController = SingleValueDropDownController(
          data: DropDownValueModel(
              name: additemListview!.selectedExpireName.toString(),
              value: additemListview!.selectedExpireDay.toString()),
        );
      }
      if (isFromHome) {
        dropDownController = SingleValueDropDownController(
            data: DropDownValueModel(
                name: homeController!.categoryDataList
                    .map((element) => DropDownValueModel(
                        name: element.categoriesName.toString(),
                        value: element.categoriesName.toString()))
                    .toList()
                    .first
                    .name,
                value: homeController!.categoryDataList
                    .map((element) => DropDownValueModel(
                        name: element.categoriesName.toString(),
                        value: element.categoriesName.toString()))
                    .toList()
                    .first
                    .value));
      } else {
        categoryName = Get.arguments[ArgumentConstant.Categoriename];
        dropDownController = SingleValueDropDownController(
          data: DropDownValueModel(
            name: categoryName,
            value: categoryName,
          ),
        );
      }
    }

    super.onInit();
  }

  EditItem(dataModels c) {
    addItemListscreenController!.addDataList.asMap().forEach((index, value) {
      if (addItemListscreenController!.addDataList[index].id ==
          additemListview!.id) {
        addItemListscreenController!.addDataList[index] = c;
      }
    });
    Get.offAllNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
      ArgumentConstant.Categoriename: categoryName,
    });
    box.write(ArgumentConstant.additemList,
        jsonEncode(addItemListscreenController!.addDataList));
  }

  addItem(dataModels c) {
    addItemListscreenController!.addDataList.add(
      c,
    );
    box.write(ArgumentConstant.additemList,
        jsonEncode(addItemListscreenController!.addDataList));
    (isFromHome)
        ? Get.offAndToNamed(Routes.HOME)
        : Get.offAndToNamed(Routes.ADD_ITEM_LISTSCREEN, arguments: {
            ArgumentConstant.Categoriename: categoryName,
          });
  }

  String getExpiryDateString() {
    DateTime n = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
      selectedDate.value.second,
    ).add(Duration(days: int.parse(durationcontroller.value.text)));
    DateTime finalDate =
        DateTime(n.year, n.month, n.day, n.hour, n.minute, n.second);
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(finalDate);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class LocalNotificationService {
  LocalNotificationService({required this.controller});

  AddItemController controller;
  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> intialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/appicon');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(
      settings,
      onSelectNotification: onSelectNotification,
    );

    Get.lazyPut(() => AddItemController());
    controller = Get.find<AddItemController>();
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details);
  }

  Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      String? payload,
      required int seconds}) async {
    final details = await _notificationDetails();
    await _localNotificationService.zonedSchedule(
      id,
      title,
      body,
      payload: payload,
      tz.TZDateTime.from(
        DateTime.now().add(Duration(seconds: seconds)),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showNotificationWithPayload(
      {required int id,
      required String title,
      required String body,
      required String payload}) async {
    final details = await _notificationDetails();
    await _localNotificationService.show(id, title, body, details,
        payload: payload);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {
    print('id $id');
  }

  void onSelectNotification(String? payload) {
    print('payload====================== $payload');
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
      print("heloo ${payload}");
      controller.addItemListscreenController!.addDataList.forEach((element) {
        if (payload == element.id.toString()) {
          Get.offAndToNamed(
            Routes.SPLASH_SCREN,
            arguments: {
              ArgumentConstant.Payload: payload,
              ArgumentConstant.isFromPayload: true,
            },
          );
        }
      });
    }
  }
}

class NotificationDataModel {
  String title;
  int value;
  NotificationDataModel({required this.value, required this.title});
}
