import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'Post.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
      key: _formKey,
      child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                width: 100.w,
                height: 50.h,
                child: Text('title', style: TextStyle(fontSize: 28.sp)),
              ),
              SizedBox(
                width: 200.w,
                height: 50.h,
                child: TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'please enter title',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'title necessary';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 50.h,),
              Container(
                width: 300.w,
                height: 300.h,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                child: Center(
                    child: TextField(
                      controller: contentController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textAlign: TextAlign.start,
                      decoration: const InputDecoration(
                        hintText: 'please enter your comment',
                        border: InputBorder.none,

                      ),
                    )
                ),
              ),
              SizedBox(height: 50.h,),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                        posts.add(Post(titleController.text, contentController.text));
                        titleController.clear();
                        contentController.clear();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
