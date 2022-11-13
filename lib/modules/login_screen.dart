import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../models/animation_enum.dart';

class AnimatedLoginScreen extends StatefulWidget {
  const AnimatedLoginScreen({Key? key}) : super(key: key);

  @override
  State<AnimatedLoginScreen> createState() => _AnimatedLoginScreenState();
}

class _AnimatedLoginScreenState extends State<AnimatedLoginScreen> {
  Artboard? riveArtBoard;

  late RiveAnimationController controllerIdle;
  late RiveAnimationController controllerHandsUp;
  late RiveAnimationController controllerHandsDown;
  late RiveAnimationController controllerSuccess;
  late RiveAnimationController controllerFail;
  late RiveAnimationController controllerLookDownRight;
  late RiveAnimationController controllerLookDownLeft;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String testEmail = 'mostafa447@hotmail.com';
  String testPassword = '12345678';
  final passwordFocusNode = FocusNode();

  bool isLookLeft = false;

  bool isLookRight = false;


  void removeAllControllers()
  {
    riveArtBoard?.artboard.removeController(controllerIdle);
    riveArtBoard?.artboard.removeController(controllerHandsUp);
    riveArtBoard?.artboard.removeController(controllerHandsDown);
    riveArtBoard?.artboard.removeController(controllerSuccess);
    riveArtBoard?.artboard.removeController(controllerFail);
    riveArtBoard?.artboard.removeController(controllerLookDownRight);
    riveArtBoard?.artboard.removeController(controllerLookDownLeft);
    isLookLeft = false;
    isLookRight = false;
  }

  void addIdleController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.removeController(controllerIdle);
    debugPrint('Idle');
  }

  void addHandsUpController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsUp);
    debugPrint('HandsUp');
  }

  void addHandsDownController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerHandsDown);
    debugPrint('HandsDown');
  }

  void addSuccessController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerSuccess);
    debugPrint('Success');
  }

  void addFailController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerFail);
    debugPrint('Fail');
  }

  void addLookDownRightController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerLookDownRight);
    isLookRight = true;
    debugPrint('LookDownRight');
  }

  void addLookDownLeftController()
  {
    removeAllControllers();
    riveArtBoard?.artboard.addController(controllerLookDownLeft);
    isLookLeft = true;
    debugPrint('LookDownLeft');
  }

  void checkForPasswordFocusNodeToChangeAnimationState()
  {
    passwordFocusNode.addListener(()
    {
      if(passwordFocusNode.hasFocus)
      {
        addHandsUpController();
      }else if(!passwordFocusNode.hasFocus){
        addHandsDownController();
      }
    });

  }

  @override
  void initState() {
    super.initState();
    controllerIdle = SimpleAnimation(AnimationEnum.idle.name);
    controllerHandsUp = SimpleAnimation(AnimationEnum.Hands_up.name);
    controllerHandsDown = SimpleAnimation(AnimationEnum.hands_down.name);
    controllerSuccess = SimpleAnimation(AnimationEnum.success.name);
    controllerFail = SimpleAnimation(AnimationEnum.fail.name);
    controllerLookDownRight = SimpleAnimation(AnimationEnum.Look_down_right.name);
    controllerLookDownLeft = SimpleAnimation(AnimationEnum.Look_down_left.name);

    rootBundle.load('assets/animated_login_screen.riv').then((data) 
    {
      final file = RiveFile.import(data);
      
      final artboard = file.mainArtboard;
      
      artboard.addController(controllerIdle);

      setState(() {
        riveArtBoard = artboard;
      });
    });

    checkForPasswordFocusNodeToChangeAnimationState();
  }

  void validateEmailAndPassword()
  {
    Future.delayed(const Duration(seconds: 1), (){
      if(formKey.currentState!.validate())
      {
        addSuccessController();
      }else
      {
        addFailController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Animated LoginScreen'
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
        child: Column(
          children:
          [
            SizedBox(
                height: MediaQuery.of(context).size.width / 1.5,
                child:
                    riveArtBoard == null ? const SizedBox.shrink()
                    : Rive(artboard: riveArtBoard!)),
            Form(
              key: formKey,
              child: Column(
                children:
                [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) => value != testEmail ? 'Wrong Email' : null,
                    onChanged: (value)
                    {
                      if(value.isNotEmpty && value.length < 16 && !isLookLeft)
                      {
                        addLookDownLeftController();
                      }else if(value.isNotEmpty && value.length > 16 && !isLookRight)
                      {
                        addLookDownRightController();
                      }
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 25,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) => value != testPassword ? 'Wrong Password' : null,
                    focusNode: passwordFocusNode,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 18,
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width / 8,
                    ),
                    child: TextButton(
                        style: TextButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: ()
                        {
                          passwordFocusNode.unfocus();
                          validateEmailAndPassword();
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
