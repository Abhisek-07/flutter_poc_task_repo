import 'package:flutter/material.dart';
import 'package:music_app/models/music_data.dart';
import 'package:music_app/providers/theme_notifier.dart';
import 'package:music_app/service/api_service.dart';
import 'package:music_app/widgets/music_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // List<MusicData> musicList = [];
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchMusicData();
  }

  Future<List<MusicData>> fetchMusicData() async {
    final musiclist = await ApiService().getAllMusicData();
    return musiclist;

    // setState(() {
    //   musicList = musiclist;
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // Widget content = const Center(
    //   child: Text('No songs yet...'),
    // );

    // if (isLoading) {
    //   content = const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }

    // if (musicList.isNotEmpty) {
    //   content = MusicList(musicList: musicList);
    // }

    final themeMode = ref.watch(themeProvider);
    bool isChecked = themeMode.isDark;

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
              child: DrawerHeader(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Settings',
                  // style: Theme.of(context)
                  //     .textTheme
                  //     .titleMedium!
                  //     .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SwitchListTile(
              value: isChecked,
              onChanged: (isChecked) {
                themeMode.changeTheme();
              },
              title: Text(isChecked ? 'Dark Mode' : 'Light Mode'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Music Player'),
      ),
      // body: content,
      body: FutureBuilder(
        future: fetchMusicData(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No songs yet...'),
            );
          }
          final musicList = snapshot.data;
          return MusicList(musicList: musicList!);
        }),
      ),
    );
  }
}
