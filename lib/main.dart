import 'package:assignment_internshala/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'authentication_repo/authentication_repo.dart';
void main() async{
 // runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    Get.put(AuthenticationRepo());
    runApp(const MyApp());
  } catch (error) {
    // Handle initialization error, e.g., show an error message or exit the app gracefully.
    print("Firebase initialization error: ${error.toString()}");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      title: 'BlackCoffer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: CircularProgressIndicator(strokeWidth: 1,))),
    );
  }
}



/*  try {
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
              SizedBox(
                  height: 750,
                  width: double.infinity,
                  child: CameraPreview(
                    cameraController,
                  )),

              *//* Visibility(
                  child: VideoCaptureControl(),
                    ),*//*
              *//* Visibility(
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
              ),*//*
              *//*   Container(
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
              ),*//*
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Visibility(
                    visible: _isStarted == true ,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(height: 28,width: 88,decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.red,
                      ),
                        child: Center(
                          child: buildTimerWidget(),
                        ),
                      ),
                    ) ),
              ),
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
                                cameraController.value.isInitialized) {
                              await cameraController.prepareForVideoRecording();
                              setState(() {
                                _isStarted = true;
                              });
                              print("------------------starting to record");
                              await cameraController.startVideoRecording();
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
                              await cameraController.stopVideoRecording();
                              setState(() {
                                videoFile != null;
                              });
                              print(
                                  "----------------------------video recording stopped");
                              //await cameraController.dispose();
                              *//* Get.to(
                            UploadForm(
                              videoFile: File(videoFile.path),
                              videoPath: videoFile.path,
                            ),
                          );*//*
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
                  cameraController.pauseVideoRecording();
                  setState(() {
                    direction = direction == 0 ? 1 : 0;
                  });
                  startCamera(direction);
                  cameraController.resumeVideoRecording();
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
    } catch (e) {
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
              Text("$e"),
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
                            if (_isStarted == false &&
                                cameraController.value.isInitialized) {
                              await cameraController.prepareForVideoRecording();
                              setState(() {
                                _isStarted = true;
                              });
                              print("------------------starting to record");
                              await cameraController.startVideoRecording();
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
                            setState(() {
                              _isStarted = false;
                            });
                            //  await cameraController.pauseVideoRecording();
                            if (_isStarted != true) {
                              videoFile =
                              await cameraController.stopVideoRecording();
                              setState(() {
                                videoFile != null;
                              });
                              print(
                                  "----------------------------video recording stopped");
                              //await cameraController.dispose();
                              *//* Get.to(
                            UploadForm(
                              videoFile: File(videoFile.path),
                              videoPath: videoFile.path,
                            ),
                          );*//*
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
                  cameraController.pauseVideoRecording();
                  setState(() {
                    direction = direction == 0 ? 1 : 0;
                  });
                  startCamera(direction);
                  cameraController.resumeVideoRecording();
                },
                child: cameraButton(
                    Icons.flip_camera_ios_outlined, Alignment.bottomLeft,
                    leftMargin: 20, bottomMargin: 20),
              ),
              Visibility(
                visible: videoFile != null,
                child: GestureDetector(
                  onTap: () =>
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return UploadVideo(
                            videoFile: File(videoFile!.path),
                            videoPath: videoFile!.path,
                          );
                        },
                      )),
                  child: cameraButton(
                      Icons.arrow_forward_ios_rounded, Alignment.bottomRight,
                      rightMargin: 20, bottomMargin: 20),
                ),
              ),
            ],
          ));
    }
*//* ElevatedButton(onPressed: (){
          getVideoFile(ImageSource.);
        }, child: Row(
            children:[
              Icon(Icons.add),
            Text("Upload Video"),
        ]))*//*
  }
  IconData? recordingWidget() {
    IconData? recordingIcon;
    if (_isStarted != true) {
      setState(() {
        recordingIcon = Icons.videocam_outlined;
        print("----------------------------------------video start");
      });
    } else {
      setState(() {
        recordingIcon = Icons.pause;
        print("----------------------------------------video pause");
      });
    }
    return recordingIcon;
  }

  buildTimerWidget() {
   // final isRunning = timer == null ? false :timer!.isActive;
    return Text("00:$seconds",style: const TextStyle(color: Colors.white,fontSize: 16),) ;
  }

  void startTimer() {
    *//*   var firsthalf = seconds.toString().substring(0,1) as int;
    var secondhalf = seconds.toString().substring(1) as int;*//*

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_isStarted) {
            seconds++;
          }
          else{
            stopTimer();
          }
          *//*  if(secondhalf < 60) {
          secondhalf++;
        }
        else{
          secondhalf = 00;
          firsthalf++;
        }*//*
        });
      },);
  }

  void stopTimer() {
    setState(() {
      timer?.cancel();
      resetTimer();
    });

  }

  void resetTimer() => seconds = minseconds;*/
