import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class playSelectedVideo extends StatefulWidget {
  const playSelectedVideo(
      {super.key,
      required this.document,
      required this.id,
      required this.profilePic,
      required this.profileName,
      required this.views});

  final document;
  final id;
  final views;
  final profilePic;
  final profileName;

  @override
  State<playSelectedVideo> createState() => _playSelectedVideoState();
}

class _playSelectedVideoState extends State<playSelectedVideo> {
  VideoPlayerController? playerController;
  ChewieController? chewieController;

  final videoRef = FirebaseFirestore.instance.collection('Videos');

  @override
  void initState()  {
    // TODO: implement initState

    log("---------------------------------------------->videoURL :- ${widget.document['Video']}");
    super.initState();
    setState(() {
      playerController =  VideoPlayerController.networkUrl(Uri.parse(widget.document['Video']));
      chewieController = ChewieController(
        videoPlayerController: playerController!,
        aspectRatio: 9 / 16,
      );
    });
    playerController!.initialize();
    playerController!.play();
    playerController!.setVolume(1);
    playerController!.setLooping(true);
  }


  @override
  void dispose() {
    chewieController!.dispose();
    playerController?.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "BlackCoffer",
              style: TextStyle(color: Colors.grey[400],
                fontFamily: 'Satoshi',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const Icon(
              Icons.notifications_active_outlined,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 500, child: Chewie(controller: chewieController!)),
            const VerticalDivider(color: Colors.green,),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.document['Title'],
                          style: const TextStyle(
                              fontFamily: 'Satoshi',
                              fontSize: 20,
                              color: Colors.white)),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.views,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 12,
                                color: Colors.white60),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text(":", style: TextStyle(color: Colors.white60)),
                          const SizedBox(
                            width: 4,
                          ),
                          // DateTime.parse(snapshot.data!.docs[index]['Date']).toString(),
                          Text(
                            getDate(widget.document['Date']),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 12,
                                color: Colors.white60),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          const Text(
                            ":",
                            style: TextStyle(color: Colors.white60),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            getTime(widget.document['Date']),
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 12,
                                color: Colors.white60),
                          ),
                          const Text(
                            ":",
                            style: TextStyle(color: Colors.white60),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            widget.document['Category'],
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontFamily: 'Satoshi',
                                fontSize: 12,
                                color: Colors.white60),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                     Container(

                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(widget.profilePic),
                            ),
                            SizedBox(width: 12,),
                            Text(widget.profileName,
                                style: const TextStyle(
                                    fontFamily: 'Satoshi',
                                    fontSize: 12,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                  width: 140,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black54),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.thumb_up_off_alt),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Like",
                                          style: TextStyle(
                                              fontFamily: 'Satoshi',
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        VerticalDivider(
                                          thickness: 2,
                                          color: Colors.greenAccent,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(Icons.thumb_down_outlined),
                                      ],
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black54),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share_outlined),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Share",
                                          style: TextStyle(
                                              fontFamily: 'Satoshi',
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Container(
                                  width: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black54),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.download_for_offline_outlined),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          "Download",
                                          style: TextStyle(
                                              fontFamily: 'Satoshi',
                                              fontSize: 10,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Container(
                        height: 112,                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 12),
                              child: Text("Comments", style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 16,
                                  color: Colors.white)),
                            ),
                        const SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0,left: 12.0),
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextFormField(
                            enabled: false,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              hintText: "Add a comment..",
                              contentPadding:
                              EdgeInsets.fromLTRB(24, 4, 12, 12),
                            ),
                            style: const TextStyle(
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w200,
                                fontSize: 16,
                                color: Colors.grey),
                      ),
                          ),
                        ),
                          ],
                        )

                      ),
                    ],
                  ),
                )
              ],
            )

          ],
        ),
      ),
    ));
  }

  String getDate(Timestamp docTime) {
    DateTime docVideoTime = DateTime.parse(docTime.toDate().toString());
    print(
        "------------------------>difference in date :- ${docVideoTime.toString()}.");
    return docVideoTime.toString().substring(0, 10);
  }

  String getTime(Timestamp docTime) {
    DateTime docVideoTime = DateTime.parse(docTime.toDate().toString());
    print(
        "------------------------>difference in date :- ${docVideoTime.toString()}.");
    return docVideoTime.toString().substring(11, 16);
  }
}
