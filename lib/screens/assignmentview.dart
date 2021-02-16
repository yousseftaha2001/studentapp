import 'dart:ffi';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';

// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:stduent_app/colos,fonts.dart';
import 'package:stduent_app/models/assignmentModel.dart';
import 'package:stduent_app/providers/databaseProvider.dart';
import 'package:stduent_app/providers/handels.dart';
import 'package:stduent_app/widgets/dialog.dart';
import 'package:stduent_app/widgets/textformwidget.dart';

class AssignmentView extends StatefulWidget {
  final Assignment assignment;
  final String roomId;
  AssignmentView({@required this.assignment,this.roomId});
  @override
  _AssignmentViewState createState() => _AssignmentViewState();
}

class _AssignmentViewState extends State<AssignmentView> {
  PDFDocument docs;
  bool _isloading = true;

  TextEditingController controller = TextEditingController();
  FilePickerResult solution;

  @override
  void initState() {
    widget.assignment.fileType == "Pdf" ? getDocs() : null;
    super.initState();
  }

  getDocs() async {
    print(widget.assignment.fileUrls.first);
    docs = await PDFDocument.fromURL(widget.assignment.fileUrls.first);
    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print(widget.assignment.fileType);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignment.title),
        centerTitle: true,
        backgroundColor: Ui.mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(8),
              height: size.height / 1.8,
              color: Colors.white,
              child: widget.assignment.fileType == "Pdf"
                  ? _isloading
                      ? Center(child: CircularProgressIndicator())
                      : PDFViewer(
                          document: docs,
                          showIndicator: true,
                          indicatorText: Colors.yellow,
                        )
                  : Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        PhotoViewGallery.builder(
                          itemCount: widget.assignment.fileUrls.length,
                          builder: (context, index) {
                            return PhotoViewGalleryPageOptions(
                              imageProvider: NetworkImage(
                                widget.assignment.fileUrls[index],
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
                            child: Text("${widget.assignment.fileUrls.length}"),
                          ),
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                "Description",
                style: Ui.main.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: RichText(
                text: TextSpan(
                  text: widget.assignment.description,
                  style: Ui.main.copyWith(color: Colors.black, fontSize: 17),
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     "comment to your teacher",
            //     style: Ui.main
            //         .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // TextInput(
            //   controller: controller,
            //   color: Ui.mainColor,
            //   lable: "your privite comment",
            //   icon: Icon(Icons.comment),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ButtonTheme(
                    height: size.height / 15,
                    minWidth: size.width / 2.5,
                    child: RaisedButton(
                      onPressed: () async {
                        print("upload");
                        FilePickerResult re =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'pdf', 'doc'],
                        );
                        if (re == null) {
                          print("we do not have sol");
                          setState(() {
                            if (solution.count != 0) {
                              print("we already have files");
                            } else {
                              solution = null;
                            }
                          });
                        } else {
                          setState(() {
                            solution = re;
                          });
                        }
                      },
                      child: Text(
                        "Upload Solution",
                        style: Ui.main.copyWith(fontSize: 16),
                      ),
                      color: Ui.mainColor,
                      splashColor: Ui.secColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  ButtonTheme(
                    height: size.height / 15,
                    minWidth: size.width / 2.5,
                    buttonColor: Ui.secColor,
                    child: RaisedButton(
                      onPressed: solution == null
                          ? null
                          : () async {
                              await showDialog(
                                context: context,
                                builder: (context) => CustomDialog(
                                  title: "Upload",
                                  description: controller.text,
                                  icon: Icon(Icons.add_moderator),
                                  mode: false,
                                  okayFun: () async {
                                    print("done");
                                    await Provider.of<Helper>(context,listen: false).uploadsolution(
                                      roomId: widget.roomId,
                                      files: solution.files,
                                      comment: controller.text,
                                    );
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  cancelFun: ()async{
                                    setState(() {
                                      solution=null;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              );
                            },
                      child: Text(
                        "Hend it",
                        style: Ui.main.copyWith(fontSize: 18),
                      ),
                      splashColor: Ui.secColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
