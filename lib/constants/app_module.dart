import 'package:warranty_appp/utilities/timer_service.dart';
import '../main.dart';
import '../utilities/ad_service.dart';
import '../utilities/progress_dialog_utils.dart';

void setUp() {
  getIt.registerSingleton<CustomDialogs>(CustomDialogs());
  getIt.registerSingleton<TimerService>(TimerService());
  getIt.registerSingleton<AdService>(AdService());
}
