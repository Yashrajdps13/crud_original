import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
  ),
  home: MyApp(),
));
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? studentName,studentID,studyProgram;
  double? studentCGPA;

  getStudentName(name){
    this.studentName=name;
  }
  getStudentID(ID){
    this.studentID=ID;
  }
  getStudyProgram(studyProgram){
    this.studyProgram=studyProgram;
  }
  getStudentCGPA(gpa){
    this.studentCGPA=double.tryParse(gpa);
  }
  createData(){
    DocumentReference documentReference=FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students= {
      "studentName": studentName,
      "studentID": studentID,
      "studentCGPA": studentCGPA,
      "studyProgram": studyProgram
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName created");
    });
  }
  readData(){
    DocumentReference documentReference=FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    documentReference.get().then((snapshot){
      print(snapshot.data());
    });
  }
  updateData(){
    DocumentReference documentReference=FirebaseFirestore.instance.collection("MyStudents").doc(studentName);

    Map<String, dynamic> students= {
      "studentName": studentName,
      "studentID": studentID,
      "studentCGPA": studentCGPA,
      "studyProgram": studyProgram
    };

    documentReference.set(students).whenComplete(() {
      print("$studentName updated");
    });
  }
  deleteData(){
    DocumentReference documentReference=FirebaseFirestore.instance.collection("MyStudents").doc(studentName);
    documentReference.delete().whenComplete(() {
      print("$studentName deleted");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Flutter College')
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,width: 2.0),
                    )
                  ),
                  onChanged: (String name){
                    getStudentName(name);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Student ID",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,width: 2.0),
                    )
                  ),
                  onChanged: (String ID){
                    getStudentID(ID);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Study Program",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,width: 2.0),
                    )
                  ),
                  onChanged: (String studyProgram){
                    getStudyProgram(studyProgram);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "CGPA",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,width: 2.0),
                    )
                  ),
                  onChanged: (String cgpa){
                      getStudentCGPA(cgpa);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                        createData();
                    },
                    child: Text('Create'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)
                      )
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        readData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                      ),
                      child: Text('Read')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        updateData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                      ),
                      child: Text('Update')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        deleteData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                        ),
                      ),
                      child: Text('Delete')
                  ),

                ],
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection("MyStudents").snapshots(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index){
                        DocumentSnapshot documentSnapshot=snapshot.data?.docs[index];
                        return Row(
                          children: [
                            Expanded(
                                child: Text(documentSnapshot["studentName"])
                            ),
                            Expanded(
                                child: Text(documentSnapshot["studentID"])
                            ),
                            Expanded(
                                child: Text(documentSnapshot["studyProgram"])
                            ),
                            Expanded(
                                child: Text(documentSnapshot["studentCGPA"].toString())
                            ),

                          ],
                        );
                      },
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index){
                      return Row(
                        children: [
                          Text("No Data")
                        ],
                      );
                    },
                  );
                }
              )
            ],
          ),
      ),
    );
  }
}



