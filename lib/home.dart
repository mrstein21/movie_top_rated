import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic>list_movies=[];
  String image="https://image.tmdb.org/t/p/w500";

  void callAPI2()async{
    try{
      http.Response value=await http.get(Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=b42f1d2342c381ec25f6180c52e51c00"));
      if(value.statusCode==200){
        Map<String,dynamic> json_decode=json.decode(value.body);
        list_movies=json_decode["results"];
        setState(() {

        });
      }else{
        print("Something Wrong");
      }
    }catch(error,track){
      print("error "+error.toString());
      print("error at "+track.toString());
    }
  }

  void callAPI(){
    http.get(Uri.parse("https://api.themoviedb.org/3/movie/top_rated?api_key=b42f1d2342c381ec25f6180c52e51c00"))
    .then(( http.Response value){
      if(value.statusCode==200){
        Map<String,dynamic> json_decode=json.decode(value.body);
        list_movies=json_decode["results"];
        setState(() {

        });
      }else{
        print("Terjadi kesalahan");
      }
    }).onError((error, stackTrace){

    });
  }

  @override
  void initState() {
    callAPI2();
    // TODO: implement initState
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
        child: ListView.builder(
            itemCount: list_movies.length,
            itemBuilder: (BuildContext context,int index){
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 6),
                      child: Image.network(image+list_movies[index]["poster_path"],
                          width: 80,height: 120,),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(list_movies[index]["title"],style:
                            TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                          SizedBox(height: 5,),
                          Text("Release on "+list_movies[index]["release_date"]),
                          SizedBox(height: 5,),
                          Text(list_movies[index]["overview"],
                              maxLines:4,overflow: TextOverflow.ellipsis,)
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
        ),
      ),
    );
  }
}

