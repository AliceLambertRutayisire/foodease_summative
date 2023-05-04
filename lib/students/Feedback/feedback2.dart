import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../animation.dart';
import 'received.dart';

class ReviewForm extends StatefulWidget {
  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final TextEditingController _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  String? reviewText;
  double?rating;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance.collection('feedback').add({
        
        'reviewText': reviewText,
        'rating': rating,
        'timestamp': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Review submitted'),
      ));
       Navigator.of(context).pushReplacement(
                      CustomPageRoute(child: VerifiedFeedbackWidget()));
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  } 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Give Feedback', style: TextStyle(
            fontFamily: 'Barlow Semi Condensed',
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: 22,
          ),),
          backgroundColor:  Color.fromRGBO(50, 41, 57, 1),
         // backgroundColor: Color.fromRGBO(201, 199, 126, 1),
          ),
          backgroundColor: Color.fromRGBO(50, 41, 57, 1),
      body: Form(
        key: _formKey,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
             Title(
                  color: Color.fromRGBO(50, 41, 57, 1),
                  child: Text(
                    'Please Rate Our service',
                    style: TextStyle(
                        color: Color.fromRGBO(201, 199, 126, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Barlow Semi Condensed'),
                  )),
               //   Text('Rating'),
                SizedBox(height: 60),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    rating = rating;
                  },
                ),
                SizedBox(height: 16),
                 Text(
                'Care to share more about it',
                style: TextStyle(
                    fontFamily: 'Barlow Semi Condensed',
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.white),
              ),
              SizedBox(height: 16),

                Padding(
                   padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _feedbackController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Review',
                      filled: true,
                      fillColor: Color.fromRGBO(217, 217, 217, 1),
                      border: InputBorder.none,
                       contentPadding:
                            EdgeInsets.symmetric(vertical: 120, horizontal: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        )
                    ),
                      
                    
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Tell Us More...';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      reviewText = value;
                    },
                  ),
                ),
              
            
            SizedBox(height: 16),
            ElevatedButton(style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(187, 144, 45, 1)),
              onPressed: _submitForm,
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
