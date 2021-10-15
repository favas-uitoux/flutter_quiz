import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';



void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> list = new List<String>.empty();
  int index = -1;
  String logo_name = "", suggest_name = "",selected_letters="",display_letters="";
  var listSuggest;
  final logger = new Logger();


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await AddToDatabase();

      if (list.length > 0) {
        startGame();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Study2 Quiz' + logo_name),
          actions: [
            IconButton(onPressed: () => null, icon: Icon(Icons.refresh)),
            IconButton(onPressed: null, icon: Icon(Icons.help)),
          ],
        ),
        body:
        list.length > 0
            ? Padding(
                padding: EdgeInsets.all(16),
                child: (Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(child: Image.asset(list[index])),
                    logo_name.length > 0
                        ? Expanded(
                            flex: 1,
                            child: GridView.builder(
                                itemCount: logo_name.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 8),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == logo_name.length - 1) {
                                    return Card(
                                      color: Colors.green,
                                      child: Center(
                                        child:Text(display_letters.length>0?display_letters.substring(index):'')

                                           // display_letters.substring(index)),
                                      ),
                                    );
                                  }
                                  else
                                    {
                                      return Card(
                                        color: Colors.green,
                                        child: Center(
                                            child:Text(display_letters.length>0?display_letters.substring(index,index+1):'')

                                          //    display_letters.substring(index,index+1)),
                                        ),
                                      );
                                    }

                                }))
                        : Text(''),
                    suggest_name.length > 0
                        ? Expanded(
                            flex: 1,
                            child: GridView.builder(
                                itemCount: suggest_name.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 8),
                                itemBuilder: (BuildContext context, int index) {
                                  if (index == suggest_name.length - 1) {
                                    return InkWell(
                                      onTap: () {


                                         // logger.e("Pressed here"+suggest_name.substring(index));
                                        selected_letters=selected_letters+suggest_name.substring(index);
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        //   content: Text( selected_letters),
                                        // ));
                                        ProcessData() ;

                                      },
                                      child: Card(
                                          color: Colors.grey,
                                          child: Center(
                                            child: Text(
                                                suggest_name.substring(index)),

                                          )),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: (){
                                      //  logger.e("Pressed here"+suggest_name.substring(index,index+1));

                                        selected_letters=selected_letters+suggest_name.substring(index,index+1);
                                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        //   content: Text( selected_letters),
                                        // ));
                                        ProcessData();
                                      },
                                      child: Card(
                                          color: Colors.grey,
                                          child: Center(
                                            child: Text(suggest_name.substring(
                                                index, index + 1)),
                                          )),
                                    );
                                  }
                                },),

                    )
                        : Text(''),
                  ],
                )),
              )
            : Center(
                child: Text('${list.length}'),
              ));
  }

  Future AddToDatabase() async {
    final manifest_content =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> map = json.decode(manifest_content);
    final path = map.keys
        .where((element) => element.contains("images/"))
        .where((element) => element.contains(".png"))
        .toList();

    setState(() {
      list = path;
    });
  }

  void startGame() {
    int last_index = index;

    do {
      index = Random().nextInt(list.length - 1);
    } while (index == last_index);

    logo_name = list[index].substring(13);

    var list_split = logo_name.split(".png");

    logo_name = list_split[0].toString().toUpperCase();

    suggest_name = generateSuggestName(logo_name).toUpperCase();

    listSuggest = suggest_name.runes.toList();
  }

  String generateSuggestName(String s) {
    String result = "universal" + s;
     List<String> list = List<String>.generate(result.length, (index) => "");
   // var list =new  List(5);

     // try
     // {
 //      list.add("a");


    //  }
    //  on Exception catch (exception) {
    //
    // } catch (error) {
    //    logger.e("test123");
    // }

    for (int j = 0; j < result.length; j++) {
      if (j == result.length - 1) {
        list.add(result.substring(j));
      } else {
        list.add(result.substring(j, j + 1));
      }
    }

    list.shuffle();
    //
    result = "";
    for (String row in list) {
      result = result + row;
    }

    return result;
  }
  
  
  
 void ProcessData()
  {
    String result="";
    
    for(int i=0;i<logo_name.length;i++)
      {
         String letter="";
         
         if(i==logo_name.length-1)
           {
             letter=logo_name.substring(i);
           }
         else{
           letter=logo_name.substring(i,i+1);
         }
         
         
         if (selected_letters.contains(letter)  )
           {
             result=result+letter;
           }
         else{
           result=result+" ";

         }
        
      }


    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text( result),
    // ));

    setState(() {
      display_letters = result;
    });

  }
  
  
}
