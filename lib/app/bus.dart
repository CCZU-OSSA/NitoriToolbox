import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/config.dart';
import 'package:provider/provider.dart';

class ApplicationBus {
  ApplicationConfig config = ApplicationConfig("app.config.json");
  Function? appSetState;
  static ApplicationBus instance(BuildContext context) {
    return Provider.of<ApplicationBus>(context, listen: false);
  }
}
