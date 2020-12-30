import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker_saver/image_picker_saver.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var jsonbody;

  memeapi(){  
  http.get("https://meme-api.herokuapp.com/gimme").then((value) {
     var res = jsonDecode(value.body);
     setState(() {
       jsonbody = res;
     });
   });
 }
 
 Future<void> share(dynamic, title, link) async {
    await FlutterShare.share(
      text: 'Meme Sharing',
      title: title,
      linkUrl: link,
      chooserTitle: 'Share'
    );
  }

   void _download() async{

     var response = await http.get(jsonbody['url']);
     var filePath = await ImagePickerSaver.saveFile(fileData: response.bodyBytes);
     print(filePath);
   }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Center(child: Text(" Meme Sharing App ", style: TextStyle(fontSize: 24, fontWeight:  FontWeight.w500, letterSpacing: 0.0, color: Colors.white),)),
      ),

      body: SingleChildScrollView(
              child: Column(     
          children: [
            SizedBox(height:20),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: jsonbody == null ? Container() : jsonbody['url'] == "" ? Container():  GestureDetector(
                onTap: _download,
                child: Image.network(jsonbody['url'], loadingBuilder: (context, child, progress) {return progress==null ? child : 
                SpinKitCubeGrid(
                  color: Colors.black,
                  size: 50.0,
                );
                
            },),
              ),
              ),
            SizedBox(height:20), 
           Row(
             mainAxisAlignment : MainAxisAlignment.spaceEvenly,
             children: [ 
               FlatButton(onPressed: (){

                 share(dynamic, jsonbody['title'], jsonbody['url']);

               }, child: Text('Share'),color: Colors.grey[900],textColor: Colors.white,hoverColor: Colors.grey[400],minWidth:150),
               FlatButton(onPressed: memeapi, child: Text('Next Meme'),color: Colors.grey[900],textColor: Colors.white,hoverColor: Colors.grey[400],minWidth: 150,),  
             ],
           ),
         ], 

        ),
      ),
      
    );
  }
}