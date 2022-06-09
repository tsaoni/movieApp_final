import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RevisePage extends StatefulWidget {

  RevisePage({Key? key}) : super(key: key){
  }

  @override
  State<RevisePage> createState() => _RevisePageState();
}

class _RevisePageState extends State<RevisePage> {

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  bool revise = false;

  @override
  Widget build(BuildContext context) {
        if(!revise) {
          return Scaffold(
              body: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 30.h,),
                      SizedBox(
                        width: 300.w,
                        // height: 30.h,
                        child: const Text(
                          'name',
                          style: TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontSize: 18,),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: 300.w,
                        height: 50.h,
                        child:  const Text(
                          'tsaoni',
                          style: TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontSize: 14,),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: 300.w,
                        // height: 30.h,
                        child: const Text(
                          'password',
                          style: TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontSize: 18,),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: 300.w,
                        height: 50.h,
                        child:  const Text(
                          'iamverycute',
                          style: TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontSize: 14,),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: 300.w,
                        // height: 30.h,
                        child: const Text(
                          'email',
                          style: TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontSize: 18,),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: 300.w,
                        height: 50.h,
                        child:  const Text(
                          'tsaoni@gmail.com',
                          style: TextStyle(
                            color: Color.fromRGBO(100, 100, 100, 1),
                            fontSize: 14,),
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => revise = true);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(116, 196, 199, 1)),
                          ),
                          child: const Text('revise'),
                        ),
                      ),
                    ],
                  )
              )
          );
        }

        return Scaffold(
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 30.h,),
                SizedBox(
                  width: 300.w,
                  // height: 30.h,
                  child: const Text(
                    'name',
                    style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      fontSize: 18,),
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  width: 300.w,
                  height: 50.h,
                  child: TextFormField(
                      controller: nameController,
                      style: const TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(100, 100, 100, 1), width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(116, 196, 199, 1), width: 2.0),
                          ),
                          hintText: 'please enter name',
                          hintStyle: TextStyle(color: Color.fromRGBO(100, 100, 100, 1))
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'name cannot be empty';
                        }
                        return null;
                      },
                      cursorColor: const Color.fromRGBO(116, 196, 199, 1)
                  ),
                ),
                SizedBox(
                  width: 300.w,
                  // height: 30.h,
                  child: const Text(
                    'password',
                    style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      fontSize: 18,),
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  width: 300.w,
                  height: 50.h,
                  child: TextFormField(
                      controller: passwordController,
                      style: const TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(100, 100, 100, 1), width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(116, 196, 199, 1), width: 2.0),
                          ),
                          hintText: 'please enter password',
                          hintStyle: TextStyle(color: Color.fromRGBO(100, 100, 100, 1))
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'password cannot be empty';
                        }
                        return null;
                      },
                      cursorColor: const Color.fromRGBO(116, 196, 199, 1)
                  ),
                ),
                SizedBox(
                  width: 300.w,
                  // height: 30.h,
                  child: const Text(
                    'email',
                    style: TextStyle(
                      color: Color.fromRGBO(100, 100, 100, 1),
                      fontSize: 18,),
                    maxLines: 2,
                  ),
                ),
                SizedBox(
                  width: 300.w,
                  height: 50.h,
                  child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Color.fromRGBO(100, 100, 100, 1)),
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(100, 100, 100, 1), width: 1.0),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color.fromRGBO(116, 196, 199, 1), width: 2.0),
                          ),
                          hintText: 'please enter email',
                          hintStyle: TextStyle(color: Color.fromRGBO(100, 100, 100, 1))
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'email cannot be empty';
                        }
                        return null;
                      },
                      cursorColor: const Color.fromRGBO(116, 196, 199, 1)
                  ),
                ),
                SizedBox(height: 10.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => revise = false);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(116, 196, 199, 1)),
                    ),
                    child: const Text('change info'),
                  ),
                ),
              ],
            )
          )
      );
  }

}







