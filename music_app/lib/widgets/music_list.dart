import 'package:flutter/material.dart';
import 'package:music_app/models/music_data.dart';
import 'package:music_app/screens/music_details.dart';

class MusicList extends StatelessWidget {
  const MusicList({super.key, required this.musicList});

  final List<MusicData> musicList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        //padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        itemCount: musicList.length,
        itemBuilder: (context, index) => ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      MusicDetailsScreen(musicData: musicList[index]),
                ),
              );
            },
            //titleAlignment: ListTileTitleAlignment.bottom,
            //contentPadding: //const EdgeInsets.only(bottom: 12),
            leading: FadeInImage.assetNetwork(
              placeholder: "lib/assets/images/play-g4436afdfe_1280.png",
              image: musicList[index].image.toString(),
              height: 60,
              width: 60,
              fit: BoxFit.fill,
            ),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(musicList[index].title),
            ),
            subtitle: Row(
              children: [
                Text(
                  musicList[index].artist.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
                const Spacer(),
                Text(
                  musicList[index].convertedDuration(),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            )),
      ),
    );
  }
}
