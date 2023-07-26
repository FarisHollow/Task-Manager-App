import 'package:flutter/material.dart';

class UserProfileBanner extends StatelessWidget {
  const UserProfileBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      tileColor: Colors.green,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
            'https://img.mensxp.com/media/content/2020/Aug/I-Am-Vengeance-Robert-Pattinsons-Batman-Stands-Out-From-Other-Bruce-Waynes-In-New-Trailer1400_5f420bc32fbdf.jpeg'),
        radius: 15,
      ),
      title: Text(
        'Vengeance',
        style: TextStyle(fontSize: 14, color: Colors.white),
      ),
      subtitle: Text(
        'mirfaris79@gmail.com',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }
}