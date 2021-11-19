import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<dynamic>data=[];
  bool isEnough=false;
  int page=1;
  bool isLoading=true;

  void getData(){
     isLoading=true;
     http.get(Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=b42f1d2342c381ec25f6180c52e51c00&page=$page"))
         .then((http.Response value){
       isEnough=true;
       isLoading=false;
       Map<String,dynamic> response=json.decode(value.body);
       print(response);
       data=[...data,...response["results"]];

       setState(() {

       });
     }).onError((error, stackTrace){
       print("terjadi kesalahan "+error.toString());
     });
  }

  @override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Rated Movies"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: data.isNotEmpty?_buildList():_buildCircular()
      ),
    );
  }

  Widget _buildList(){
    return NotificationListener<ScrollNotification>(
      child: ListView.builder(
          itemCount: isEnough==true?data.length:data.length+1 ,
          itemBuilder: (BuildContext context,int index){
            if(index<data.length){
              return _buildRow(data[index]);
            }else{
              return _buildCircular();
            }
          }
      ),
      onNotification: (ScrollNotification scrollInfo){
        if(scrollInfo.metrics.pixels==scrollInfo.metrics.maxScrollExtent){
          if(isEnough==false){
            print("hasil is enough "+isEnough.toString());
            if(isLoading==false){
              page=page+1;
              getData();
              return true;
            }
          }
        }
        return false;
      },
    );
  }

  Widget _buildCircular(){
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  
  Widget _buildRow(Map<String,dynamic> data){
     return Container(
       margin: EdgeInsets.all(3),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Image.network("https://image.tmdb.org/t/p/w500"+data["poster_path"],
             height: 120,width: 80,fit: BoxFit.fill,),
           SizedBox(width: 6,),
           Expanded(
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(data["title"],style: TextStyle(
                     fontSize: 15,
                     fontWeight: FontWeight.bold
                 ),maxLines: 2,overflow: TextOverflow.ellipsis),
                 SizedBox(height: 4,),
                 Text("Release on : "+data["release_date"],),
                 SizedBox(height: 4,),
                 Text(data["overview"],style: TextStyle(),maxLines: 4,overflow: TextOverflow.ellipsis,)
               ],
             ),
           ),
         ],
       ),
     );
  }
}
