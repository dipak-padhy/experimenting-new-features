import 'dart:math';

import 'package:assignment_internshala/authentication_repo/authentication_repo.dart';
import 'package:assignment_internshala/play_selected_video.dart';
import 'package:assignment_internshala/upload/take_video.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final profilePicList = ["https://randomuser.me/api/portraits/men/84.jpg",
                          "https://randomuser.me/api/portraits/men/44.jpg"   ,
                                "https://randomuser.me/api/portraits/women/9.jpg",
  "https://randomuser.me/api/portraits/lego/6.jpg",
  "https://randomuser.me/api/portraits/men/3.jpg",
    "https://randomuser.me/api/portraits/women/39.jpg"
  ];

  final profileNameList = ["John Adventures",
    "Discover Truth with Ram"   ,
    "Science Experiments",
    "Productivity Channel",
    "Yoga Exercise",
    "Fashion & Lifestyle",
  ];

  final viewList = ["75k views",
    "500 views"   ,
    "2k views",
    "29 views",
    "10k views",
    "7k views",
  ];


  final videoList = FirebaseFirestore.instance
      .collection("Videos")
      .orderBy('Date',descending: true)
      .snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "BlackCoffer",
                style: TextStyle(color: Colors.grey[400],fontSize: 16,
                  fontFamily: 'Satoshi',
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () => AuthenticationRepo.instance.logout(),
                child: const Icon(
                  Icons.notifications_active_outlined,
                ),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                   decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
                color: Colors.black,
                //spreadRadius: 2,
                offset: Offset(2.5, 4)),
        ]),
                  child: TextField(
                     style:  const TextStyle(
                       fontFamily: 'Satoshi',
                       fontSize:16,color: Colors.white,
        ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor:  Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none
                      ),
                      hintText: "Search For a Video",
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.purple.shade900,
                      hintStyle:  const TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize:12,color: Colors.white30
                    ),
                      suffixIcon: TextButton(onPressed:() {

                      },
                        child: Text("Filter",style:  const TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize:12,color: Colors.white30
                        ),),
                      )
                  ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: videoList,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("Some Error Occurred,Try again Later");
                  } else {
                    print("${snapshot.data!.docs.length}");
                    return Expanded(
                        child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> document =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        var id = snapshot.data!.docs[index].id;

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return playSelectedVideo(document: document, id: id, profilePic: profilePicList[index], profileName: profileNameList[index],views: viewList[index]);
                            },));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        //spreadRadius: 2,
                                        offset: Offset(1.0, 1.8)),
                                  ]),
                              child: Card(
                                color: Colors.grey[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                //  borderOnForeground: false,
                                // elevation: 20.0,
                                shadowColor: Colors.black,
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        8.0, 24, 0, 4),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        8.0, 8, 8, 16),
                                                child: SizedBox(
                                                  height: 200,
                                                  child: Image.network(
                                                      snapshot.data!.docs[index]
                                                          ['Thumbnail']),
                                                ),
                                              ),
                                            ),
                                            const Align(
                                              alignment: Alignment.bottomRight,
                                              child: Icon(Icons.more_vert_sharp,color: Colors.white60,),
                                            ),
                                            Positioned(
                                              top: 192,
                                              left: 280,
                                              bottom: 4,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(8),
                                                  color: Colors.white60.withOpacity(0.2),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Text("0:0${snapshot.data!.docs[index]['videoLength']}",  style: const TextStyle(
                                                      fontFamily: 'Satoshi',
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              ),
                                            ),

                                          ],
                                        ),
                                        const Divider(
                                          color: Colors.white,
                                          thickness: 1.2,
                                        ),

                                      ],
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      SizedBox(width: 6,),
                                      CircleAvatar(
                                       backgroundImage: NetworkImage(profilePicList[index]),
                                      ),
                                      SizedBox(width: 16,),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]['Title']
                                                .toString(),
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(
                                                fontFamily: 'Satoshi',
                                                fontSize:16,color: Colors.white),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                profileNameList[index],
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontFamily: 'Satoshi',
                                                    fontSize: 10,
                                                    color: Colors.white60),
                                              ),
                                              const SizedBox(width: 4,),
                                              const Text(":",style: TextStyle(color: Colors.white60,fontFamily: "satoshi")),
                                              const SizedBox(width: 4,),
                                              // DateTime.parse(snapshot.data!.docs[index]['Date']).toString(),
                                              Text(
                                                getDate(snapshot.data!.docs[index]['Date']),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontFamily: 'Satoshi',
                                                    fontSize: 10, color: Colors.white60),
                                              ),
                                              const SizedBox(width: 4,),
                                              const Text(":",style: TextStyle(color: Colors.white60,fontFamily: 'satoshi'),),
                                              const SizedBox(width: 4,),
                                              Text(
                                                getTime(snapshot.data!.docs[index]['Date']),
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                    fontFamily: 'Satoshi',
                                                    fontSize: 10, color: Colors.white60),
                                              ),

                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ));
                  }
                },
              ),
              SizedBox(height: 80,)
            ],
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white38.withOpacity(0.66666),
                      borderRadius: BorderRadius.circular(100),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton.icon(onPressed:  () {
                          Get.offAll(()=> const ExplorePage());
                        },
                          icon:  Icon(Icons.explore_outlined,color: Theme.of(context).colorScheme.background,),
                          label: const Text("Explore", style: TextStyle(
                              fontFamily: 'Satoshi',
                              fontSize: 16,
                              color: Colors.black54),
                        ),
                        ),
                  TextButton.icon(onPressed:  () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>const TakeVideo() ,));
                  },
                    icon: Icon(Icons.add_circle_outline_sharp,color: Theme.of(context).colorScheme.background,),
                    label: const Text("Post", style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 16,
                        color: Colors.black54),

                    ),
                  )],
                    ),
                  ),
                ),
              ),
            ),
      ]
        ),

    );
  }

  String getDate(Timestamp docTime) {
    DateTime docVideoTime = DateTime.parse(docTime.toDate().toString());
    //print("------------------------>difference in date :- ${docVideoTime.toString()}.");
    return docVideoTime.toString().substring(0,10) ;
  }
  String getTime(Timestamp docTime) {
    DateTime docVideoTime = DateTime.parse(docTime.toDate().toString());
   // print("------------------------>difference in date :- ${docVideoTime.toString()}.");
    return docVideoTime.toString().substring(11,16) ;
  }

  getIndex() {
    int randomIndex = Random().nextInt(profilePicList.length);
    return randomIndex;
  }
}

