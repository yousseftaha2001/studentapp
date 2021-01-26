import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:stduent_app/colos,fonts.dart';
import 'package:stduent_app/widgets/textformwidget.dart';

class AssignmentView extends StatefulWidget {
  @override
  _AssignmentViewState createState() => _AssignmentViewState();
}

class _AssignmentViewState extends State<AssignmentView> {
  PDFDocument doc;
  List<String> photos = [
    "https://images.pexels.com/photos/76969/cold-front-warm-front-hurricane-felix-76969.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/220201/pexels-photo-220201.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
    "https://images.pexels.com/photos/87009/earth-soil-creep-moon-lunar-surface-87009.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
  ];
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    getUrl();
    super.initState();
  }

  getUrl() async {
    doc = await PDFDocument.fromURL(
        'http://www.africau.edu/images/default/sample.pdf');
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      context: context,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          child: SingleChildScrollView(
            // reverse: true,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "-comment to your teacher-",
                    style: Ui.main.copyWith(color: Colors.grey),
                  ),
                ),
                TextInput(
                  controller: controller,
                  color: Ui.mainColor,
                  lable: "your privite comment",
                  icon: Icon(Icons.comment),
                ),
                MaterialButton(
                  onPressed: () async {
                    FilePickerResult result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['jpg', 'pdf', 'doc'],
                    );
                    print(result.files.first.extension);
                  },
                  child: Text("Upload your solution"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
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
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  PhotoViewGallery.builder(
                    itemCount: photos.length,
                    builder: (context, index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(
                          photos[index],
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
                      child: Text("${photos.length}"),
                    ),
                  ),
                ],
              ),
              // child: PDFViewer(
              //   document: doc,
              // ),
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
                  text:
                      'Hello  Hello Hello  Hello  Hello Hello Hello  Hello Hello Hello  Hello Hello Hello  Hello Hello Hello  Hello Hello',
                  style: Ui.main.copyWith(color: Colors.black, fontSize: 17),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: RaisedButton(
                  onPressed: () async {
                    print("hend it");
                    displayBottomSheet(context);
                  },
                  // height: size.height / 15,
                  // minWidth: size.width / 2,
                  child: Text(
                    "Hend it",
                    style: Ui.main,
                  ),
                  color: Ui.mainColor,
                  splashColor: Ui.secColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
