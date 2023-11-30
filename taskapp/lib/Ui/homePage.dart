import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: appBar(),
      
      body: Column(
        children: [
          Text("TaskApp")
        ],
      ),
      
    );
  }
}


appBar(){
  return AppBar(
    leading: GestureDetector(
      onTap: (){
        
      },
      
      child: Icon(Icons.nightlight_round, size: 20,),
    ),
    actions: [
      Icon(Icons.person)
    ],
    
  );
}
