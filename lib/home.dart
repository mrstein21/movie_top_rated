import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>data=[];
  bool isEnough=false;
  int page=1;
  bool isLoading=true;
  String image="https://image.tmdb.org/t/p/w500";


  void callAPI(){
    isLoading=true;
    http.get(Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=b42f1d2342c381ec25f6180c52e51c00&page=$page"))
    .then(( http.Response value){
      if(value.statusCode==200){
        isLoading=false;
        Map<String,dynamic> response=json.decode(value.body);
        if(response["results"].isEmpty){
          isEnough=true;
        }
        data=[...data,...response["results"]];
      }else{
        print("Something wrong");
      }
    }).onError((error, stackTrace){
       print("Something wrong");
    });
  }

  @override
  void initState() {
    callAPI();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Top Rated Movies",),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child:  data.isNotEmpty?_buildList():_buildCircular()
      ),
    );
  }

  Widget _buildList(){
   return NotificationListener<ScrollNotification>(
     child: ListView.builder(
          itemCount: isEnough==true?data.length:data.length+1 ,
          itemBuilder: (BuildContext context,int index) {
            if (index < data.length) {
              return _buildRow(data[index]);
            } else {
              return _buildCircular();
            }
          }
      ),
      onNotification: (ScrollNotification scrollInfo){
       if(scrollInfo.metrics.pixels==scrollInfo.metrics.maxScrollExtent){
         if(isEnough==false){
           if(isLoading==false){
             page=page+1;
             callAPI();
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
          Image.network(image+data["poster_path"],
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

