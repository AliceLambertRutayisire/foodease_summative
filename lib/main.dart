import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'animation.dart';
import 'firebase_options.dart';
import 'models/studentmodel.dart';
import 'students/Sign up and login/studentlogin.dart';
//import 'vendors/Sign up & Login/vendorsignup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(201, 199, 126, 1),
      ),
      home: Logo(),
    );
  }
}

class StudentSignup extends StatefulWidget {
  const StudentSignup({super.key});

  @override
  State<StudentSignup> createState() => _StudentSignupState();
}

class _StudentSignupState extends State<StudentSignup> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
   
  String? errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color.fromRGBO(50, 41, 57, 1)
        //backgroundColor: Color.fromRGBO(201, 199, 126, 1),
      ),
      //backgroundColor: Color.fromRGBO(201, 199, 126, 1),
      backgroundColor: Color.fromRGBO(50, 41, 57, 1),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisSize: Ma'inAxisSize.max,

            children: [
              Expanded(child: Image.asset("assets/images/login2.png", width: 346, height: 376)),
              // const Spacer(flex: 1),
              SizedBox(
                width: 300,
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: false,
                    controller: _emailController,
                    onSaved: (value) {
                                  _emailController.text = value!;
                                },
                    decoration: const InputDecoration(
                        filled: true,
                        fillColor: Color.fromRGBO(217, 217, 217, 1),
                        prefixIcon: const Icon(
                          Icons.person,
                           color: Color(0xFFBB902D),
                          //color: Color.fromRGBO(50, 41, 57, 1),
                        ),
                        hintText: 'Enter Email',
                        labelText: 'Email',
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.fromLTRB(20, 15, 20, 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              SizedBox(
                width: 300,
                child: Form(
                  child: TextFormField(
                    autofocus: false,
                    autovalidateMode:
                               AutovalidateMode.onUserInteraction,
                                validator: (value) =>
                                    value != null && value.length < 6
                                        ? 'Enter min 6 characters'
                                        : null,
                                controller: _passwordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                 onSaved: (value) {
                                  _passwordController.text = value!;
                                },
                                decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color.fromRGBO(217, 217, 217, 1),
                                    prefixIcon: const Icon(
                                      Icons.key,
                                       color: Color(0xFFBB902D),
                                      //color: Color.fromRGBO(50, 41, 57, 1),
                                    ),
                                    hintText: 'Enter password',
                                    labelText: 'Password',
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(20, 15, 20,15),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      
                                    
                                    )
                                    
                                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),
            
              SizedBox(
                width: 100,
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(20),
                  child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      color: Color(0xFFBB902D),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                          signUp(_emailController.text, _passwordController.text);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontFamily: 'Barlow Semi Condensed',
                            color: Color.fromRGBO(240, 236, 207, 1)),
                      ))),
              ),

             SizedBox(height: 15,),
            
            TextButton(onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StudentLogin()));
            },  
            child: RichText(text: TextSpan(
              children: [
                TextSpan(
                  text: 'Already have an Account? Sign In',
                  style: TextStyle(fontSize: 10,
                   color:  Color.fromRGBO(201, 199, 126, 1),)
                )
                
              ]
              
             ))
              ),
             
            SizedBox(height:15)
            ]),
      ),
    );
  }


   // sign Up function
  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
          Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => StudentLogin()));

        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address is invalid.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
 
  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values
 
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
 
    StudentModel studentModel = StudentModel(password: '');
 
    // writing all the values
    studentModel.email = user!.email;
    studentModel.uid = user.uid;
    
 
    await firebaseFirestore
        .collection("user")
        .doc(user.uid)
        .set(studentModel.toMap());
    Fluttertoast.showToast(msg: "Account created successfully :) ");
 
    Navigator.pushAndRemoveUntil(
        (context),
        CustomPageRoute(child: StudentLogin()),
        (route) => false);
  }

}






