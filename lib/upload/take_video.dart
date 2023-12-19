import 'package:assignment_internshala/authentication_repo/authentication_repo.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:assignment_internshala/upload/upload_video.dart';
import 'package:camera/camera.dart';

class TakeVideo extends StatefulWidget {
 const  TakeVideo({super.key});

  @override
  State<TakeVideo> createState() => _TakeVideoState();
}

class _TakeVideoState extends State<TakeVideo> {

 List<CameraDescription>? cameras =[];
  CameraController? cameraController;
  int direction = 0;
  bool _isStarted = false;
  XFile? videoFile;
  Timer? timer;
  var seconds = minseconds;

  static const minseconds = 0;

  @override
  void initState() {
    // TODO: implement initState
    startCamera(0);
    super.initState();
  }

 @override
 void dispose() {
   cameraController!.dispose();
   super.dispose();

 }

  Widget cameraButton(IconData? icon, Alignment alignment,
      {double bottomMargin = 0,
        Color colors = Colors.black,
        double topMargin = 0,
        double leftMargin = 0,
        double rightMargin = 0}) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.only(
            left: leftMargin,
            bottom: bottomMargin,
            right: rightMargin,
            top: topMargin),
        height: 68,
        width: 68,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[400],
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2.5, 0.95),
                blurRadius: 4,
              )
            ]),
        child: Center(
          child: Icon(
            icon,
            color: colors,
          ),
        ),
      ),
    );
  }

  void startCamera(int direction) async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras![direction],
      ResolutionPreset.max,
    );
   cameraController?.initialize().then((value) {
      if (!mounted) {
        return;
      }
       setState(() {});
    }).catchError((e) {
      print("------------------------------------------------>$e------->");
    });
  }

  buildTimerWidget() {
    // final isRunning = timer == null ? false :timer!.isActive;
    return "00:$seconds";
  }

  void startTimer() {
    /*   var firsthalf = seconds.toString().substring(0,1) as int;
    var secondhalf = seconds.toString().substring(1) as int;*/

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_isStarted) {
          seconds++;
        }
        else {
          stopTimer();
        }
        /*  if(secondhalf < 60) {
          secondhalf++;
        }
        else{
          secondhalf = 00;
          firsthalf++;
        }*/
      });
    },);
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
      resetTimer();
    });
  }

  void resetTimer() => seconds = minseconds;


  @override
  Widget build(BuildContext context) {
    // try {
    if (cameras!.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .background,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "BlackCoffer",
                  style: TextStyle(color: Colors.grey[400],
                      fontFamily: 'Satoshi',
                      fontSize: 16,),
                ),
                const Icon(
                  Icons.notifications_active_outlined,
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              Container(height: 750,
                  color: Colors.black,
                  child: const Center(child: CircularProgressIndicator())),
              //Text("${e.toString()}"),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(100),
                      shape: BoxShape.rectangle,
                      color: Colors.grey[400],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(2.5, 0.95),
                          blurRadius: 4,
                        )
                      ]),
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 148,
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.videocam_outlined,
                        size: 28,
                        color:
                        _isStarted != true ? Colors.green : Colors.grey,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: VerticalDivider(
                          color: Colors.black,
                        ),
                      ),
                      Icon(Icons.pause,
                          size: 28,
                          color: _isStarted == true
                              ? Colors.red
                              : Colors.grey),
                    ],
                  ),
                ),
              ),
              cameraButton(
                  Icons.flip_camera_ios_outlined, Alignment.bottomLeft,
                  leftMargin: 20, bottomMargin: 20),
              Visibility(
                visible: videoFile != null,
                child: cameraButton(
                    Icons.arrow_forward_ios_rounded, Alignment.bottomRight,
                    rightMargin: 20, bottomMargin: 20),
              ),
            ],
          ));
    }

      // return const Center(child: CircularProgressIndicator(),);

    else {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .background,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text(
                  "BlackCoffer",
                  style:TextStyle(color: Colors.grey[400],
              fontFamily: 'Satoshi',
              fontSize: 16,),
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
              SizedBox(
                  height: 750,
                  width: double.infinity,
                  child: CameraPreview(
                    cameraController!,
                  )),

              /* Visibility(
                  child: VideoCaptureControl(),
                    ),*/
              /* Visibility(
                visible: _isStarted == false,
                child: GestureDetector(
                  onTap: () async {
                        _isStarted = true;
                        print("------1st");
                    print("----------------------------video recording started");
                    await cameraController.startVideoRecording();
                    print("-----------------------------check 1st");
                  },
                  child: cameraButton( Icons.videocam_outlined,colors: Colors.black,Alignment.center,
                      bottomMargin: 20),
                ),
              ),
              Visibility(
                visible: _isStarted == true,
                child: GestureDetector(
                  onTap: () async {
                      _isStarted = false;
                      // getVideoFile(videoFile);
                    videoFile =  await cameraController.stopVideoRecording();
                    print("----------------------------video recording stopped");
                    await cameraController.dispose();
                    Get.to(
                      UploadForm(
                        videoFile: File(videoFile.path),
                        videoPath: videoFile.path,
                      ),
                    );
                  },
                  child:  cameraButton( Icons.pause,colors: Colors.red,Alignment.bottomCenter,
                      bottomMargin: 20),
                ),
              ),*/
              /*   Container(
                alignment: Alignment.topRight,
                  height: 68,
                  width: 160,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.grey[400],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(2.5, 0.95),
                          blurRadius: 4,
                        )
                      ]),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Divider(height: 4,thickness: 2,color: Colors.orange,),

                  ],
                ),
              ),*/
              /*Align(
                  alignment: Alignment.bottomRight,
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
                  )
              )*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Visibility(
                    visible: _isStarted == true,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.red.withOpacity(0.8),
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text( buildTimerWidget(), style: const TextStyle(
    fontFamily: 'Satoshi',
    fontSize: 12,
    color: Colors.white)
                      ),
                        ),
                    )),
                ) ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(100),
                      shape: BoxShape.rectangle,
                      color: Colors.grey[400],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(2.5, 0.95),
                          blurRadius: 4,
                        )
                      ]),
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 148,
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            startTimer();
                            if (_isStarted == false &&
                                cameraController!.value.isInitialized) {
                              await cameraController!
                                  .prepareForVideoRecording();
                              setState(() {
                                _isStarted = true;
                              });
                              print("------------------starting to record");
                              await cameraController!.startVideoRecording();
                            }
                          },
                          child: Icon(
                            Icons.videocam_outlined,
                            size: 28,
                            color:
                            _isStarted != true ? Colors.green : Colors.grey,
                          )),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: VerticalDivider(
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                          onTap: () async {
                            stopTimer();
                            setState(() {
                              _isStarted = false;
                            });
                            //  await cameraController.pauseVideoRecording();
                            if (_isStarted != true) {
                              videoFile =
                              await cameraController!.stopVideoRecording();
                              setState(() {
                                videoFile != null;
                              });
                              print(
                                  "----------------------------video recording stopped");
                              //await cameraController.dispose();
                              /* Get.to(
                            UploadForm(
                              videoFile: File(videoFile.path),
                              videoPath: videoFile.path,
                            ),
                          );*/
                            }
                          },
                          child: Icon(Icons.pause,
                              size: 28,
                              color: _isStarted == true
                                  ? Colors.red
                                  : Colors.grey)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  cameraController!.pauseVideoRecording();
                  setState(() {
                    direction = direction == 0 ? 1 : 0;
                  });
                  startCamera(direction);
                  cameraController!.resumeVideoRecording();
                },
                child: cameraButton(
                    Icons.flip_camera_ios_outlined, Alignment.bottomLeft,
                    leftMargin: 20, bottomMargin: 20),
              ),
              Visibility(
                visible: videoFile != null,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return UploadVideo(
                          videoFile: File(videoFile!.path),
                          videoPath: videoFile!.path,
                        );
                      },

                    ));
                  },
                  child: cameraButton(
                      Icons.arrow_forward_ios_rounded, Alignment.bottomRight,
                      rightMargin: 20, bottomMargin: 20),
                ),
              ),
              ],
          ));

    }


    /* } catch (e) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .background,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "BlackCoffer",
                  style: TextStyle(color: Colors.grey[400]),
                ),
                const Icon(
                  Icons.notifications_active_outlined,
                )
              ],
            ),
          ),
          body: Stack(
            children: [
              Container(height: 750,
                  color: Colors.black,
                  child: const Center(child: CircularProgressIndicator())),
              //Text("${e.toString()}"),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(100),
                      shape: BoxShape.rectangle,
                      color: Colors.grey[400],
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(2.5, 0.95),
                          blurRadius: 4,
                        )
                      ]),
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 148,
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.videocam_outlined,
                        size: 28,
                        color:
                        _isStarted != true ? Colors.green : Colors.grey,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: VerticalDivider(
                          color: Colors.black,
                        ),
                      ),
                      Icon(Icons.pause,
                          size: 28,
                          color: _isStarted == true
                              ? Colors.red
                              : Colors.grey),
                    ],
                  ),
                ),
              ),
              cameraButton(
                  Icons.flip_camera_ios_outlined, Alignment.bottomLeft,
                  leftMargin: 20, bottomMargin: 20),
              Visibility(
                visible: videoFile != null,
                child: cameraButton(
                    Icons.arrow_forward_ios_rounded, Alignment.bottomRight,
                    rightMargin: 20, bottomMargin: 20),
              ),
            ],
          ));
    }*/

     }
}


