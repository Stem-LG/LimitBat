import 'dart:io';

final tempLimitFile =
    File('/sys/class/power_supply/BAT0/charge_control_end_threshold');
final permLimitFile = File('/etc/systemd/system/bat-boot.service');

int getCurrentLimit() {
  final limit = tempLimitFile.readAsStringSync();
  return int.parse(limit);
}

void setTempLimit(int value) {
  tempLimitFile.writeAsStringSync(value.toString());
}

void setPermLimit(int value) {
  setTempLimit(value);
  permLimitFile.writeAsStringSync(
      "[Unit]\nDescription=Persist the battery charging threshold after boot \nAfter=multi-user.target\nStartLimitBurst=0\n\n[Service]\nType=oneshot\nRestart=on-failure\nExecStart=/usr/bin/bash -c 'echo $value > /sys/class/power_supply/BAT?/charge_control_end_threshold'\n\n[Install]\nWantedBy=multi-user.target");
  Process.run('systemctl', ['enable', 'bat-boot.service']);
}

void resetEverything() {
  Process.run('systemctl', ['disable', 'bat-boot.service']);
  tempLimitFile.writeAsStringSync('100');
  permLimitFile.deleteSync();
}
