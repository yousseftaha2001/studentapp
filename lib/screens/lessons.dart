import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/colos,fonts.dart';
import 'package:stduent_app/models/comment.dart';
import 'package:stduent_app/models/lesson.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/screens/lessonsList.dart';
import 'package:stduent_app/widgets/textformwidget.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class LessonView extends StatefulWidget {
  Lesson lesson;
  final title;
  final rid;
  LessonView({this.lesson, this.title, this.rid});

  @override
  _LessonViewState createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  VideoPlayerController _controller;

  ChewieController chewieController;
  Chewie playerWidget;
  PDFDocument docs;
  bool _isloading = true;
  DateFormat dateFormat = DateFormat.yMEd().add_jm();
  TextEditingController commentCont=TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.lesson.fileType == "video") {
      _controller = VideoPlayerController.network(
          'https://firebasestorage.googleapis.com/v0/b/chat-b1734.appspot.com/o/FjfKik5vd9P5SsoE7bRSmuaaNA93%2FLessons%2Fthird%2Freceived_810519109769389.mp4?alt=media&token=2ad94a2e-d039-4fb6-bce0-b2fd76041c37')
        ..initialize().then((_) {
          setState(() {});
        });
      chewieController = ChewieController(
        videoPlayerController: _controller,
        autoPlay: true,
        looping: true,
      );
      Chewie(
        controller: chewieController,
      );
    } else if (widget.lesson.fileType == "Pdf") {
      getDocs();
    }
  }

  getDocs() async {
    print(widget.lesson.fileUrls.first);
    docs = await PDFDocument.fromURL(widget.lesson.fileUrls.first);
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Ui.mainColor,
        title: Text("Lesson"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              child: defineType(),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2.87,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Text(
                            "-Comments-",
                            style: Ui.main.copyWith(
                              color: Colors.grey,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: Provider.of<DataBase>(context, listen: false)
                            .lessonComments(
                          rid: widget.rid,
                          lid: widget.lesson.lId,
                        ),
                        builder: (context, data) {
                          if (data.connectionState == ConnectionState.active) {
                            if (data.data.docs.isNotEmpty) {
                              print(data.data.docs.length);
                              List<Comment> lessonCom = [];
                              data.data.docs.forEach((comment) {
                                lessonCom.add(Comment.fromJson(
                                  json: comment.data(),
                                ));
                              });
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: lessonCom.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            child: Icon(Icons.person),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(lessonCom[index].name),
                                              Wrap(
                                                children: [
                                                  Text(
                                                    lessonCom[index].comment,
                                                    style: Ui.main.copyWith(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                dateFormat.format(
                                                    lessonCom[index].time),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Center(
                                child:Text("no comments yet!"),
                              );
                            }
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0),
                      padding: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: commentCont,
                              cursorColor: Ui.mainColor,
                              cursorHeight: 25,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.comment_rounded),
                                labelText: "your comment",
                                labelStyle: Ui.main.copyWith(
                                  color: Ui.thirdColor,
                                  fontSize: 15,
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Ui.mainColor),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            color: Ui.mainColor,
                            icon: Icon(Icons.send_outlined),
                            onPressed: () async {
                              if(commentCont.text.isNotEmpty){
                               
                                 Provider.of<Helper>(context,listen: false).addingComments(
                                  rid: widget.rid,
                                  way: "Lessons",
                                  docId: widget.lesson.lId,
                                  body: commentCont.text,
                                );
                                commentCont.clear();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.lesson.fileType == "video") {
      _controller.dispose();
      chewieController.dispose();
    }
  }

  Widget defineType() {
    if (widget.lesson.fileType == "video") {
      return chewieController != null &&
              chewieController.videoPlayerController.value.initialized
          ? Chewie(
              controller: chewieController,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 0),
                Text('Loading'),
              ],
            );
    } else if (widget.lesson.fileType == "photo") {
      return Stack(
        alignment: AlignmentDirectional.topEnd,
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.lesson.fileUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                  widget.lesson.fileUrls[index],
                ),
                maxScale: PhotoViewComputedScale.covered * 2,
                minScale: PhotoViewComputedScale.contained * 0.8,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            loadFailedChild: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Transform.translate(
            offset: Offset(-20, 10),
            child: CircleAvatar(
              child: Text("${widget.lesson.fileUrls.length}"),
            ),
          ),
        ],
      );
    } else {
      if (_isloading) {
        return CircularProgressIndicator();
      } else {
        return PDFViewer(
          document: docs,
          showIndicator: true,
          indicatorText: Colors.yellow,
        );
      }
    }
  }
}
