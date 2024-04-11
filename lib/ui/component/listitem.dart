import 'package:audio_play/service/filetouri.dart';

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class Musicitemcard extends StatelessWidget {
  const Musicitemcard(
      {required this.title,
      required this.artiste,
      required this.artd,
      required this.isplaying,
      required this.ontap,
      super.key});

  final String title;
  final String artiste;
  final Uri? artd;
  final bool isplaying;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    print(' bool:${isplaying}');
    return ListTile(
      onTap: ontap,
      leading: FutureBuilder(
          future: filetouri(artd),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              var apl = snapshot.data!;
              return FadeInImage(
                  width: 45,
                  height: 45,
                  placeholder: MemoryImage(kTransparentImage),
                  image: FileImage(apl));
            } else {
              return const SizedBox(
                  height: 45,
                  width: 45,
                  child: Center(
                    child: Icon(Icons.music_note),
                  ));
            }
            // return Container(
            //     decoration:
            //         BoxDecoration(borderRadius: BorderRadius.circular(8)),
            //     width: 45,
            //     height: 45,
            //     child: snapshot.data == null
            //         ? const Center(
            //             child: Icon(Icons.music_note),
            //           )
            //         : ClipRRect(
            //             borderRadius: BorderRadius.circular(8),
            //             child: FadeInImage(
            //                 width: 45,
            //                 height: 45,
            //                 fadeInDuration: const Duration(milliseconds: 7),
            //                 fadeInCurve: Easing.legacy,
            //                 placeholder: MemoryImage(kTransparentImage),
            //                 image: FileImage(snapshot.data!)),
            //           ));
          }),
      title: Text(title),
      subtitle: Text(artiste),
    );
  }
}
