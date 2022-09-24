import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import 'package:namoz_vaqtlari/Model/hive_data.dart';
import 'package:namoz_vaqtlari/Model/regions.dart';

Future<void> createNotification(String name, String time, int id) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: id,
      channelKey: 'Namoz_times_key',
      title: '$name vaqti bo\'ldi',
      body: 'Namoz musilmonlar uchun farzdir',
    ),
    schedule: NotificationCalendar(
      repeats: true,
      hour: int.parse(time[0] + time[1]),
      minute: int.parse(time[3] + time[4]),
      second: 00,
    ),
  );
}

//class
class NotificationForNamoz {
  String name;
  bool isNotify;
  int id;

  NotificationForNamoz(this.name, this.isNotify, this.id);

  void acivateNotification() async {
    if (isNotify) {
      String fileLocation = await getData('${name}Time');
      await createNotification(name, fileLocation, id);
      print(fileLocation);
    }
  }

  void changeNotificationEnabled(bool willNotify, BuildContext context) async {
    isNotify = willNotify;
    isNotificationEnabled[id] = willNotify;
    putData('isNotificationEnabled', isNotificationEnabled);
    if (isNotify) {
      String fileLocation = await getData('${name}Time');
      await createNotification(name, fileLocation, id).then(
        (_) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$name namozi uchun bildirishnoma yoqildi'),
                  Icon(
                    Icons.event_available,
                    color: (currentTheme == ThemeMode.light)
                        ? Colors.white
                        : Colors.black,
                  )
                ]),
            duration: const Duration(milliseconds: 1000),
          ),
        ),
      );
    } else {
      await AwesomeNotifications().cancel(id).then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('$name namozi uchun bildirishnoma o\'chirildi'),
                      Icon(
                        Icons.event_busy,
                        color: (currentTheme == ThemeMode.light)
                            ? Colors.white
                            : Colors.black,
                      )
                    ]),
                duration: const Duration(milliseconds: 1000),
              ),
            ),
          );
    }
  }
}