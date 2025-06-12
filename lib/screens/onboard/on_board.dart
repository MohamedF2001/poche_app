import 'package:flutter/material.dart';
import 'package:poche/screens/onboard/on_board_content.dart';
import 'package:poche/screens/onboard/size.dart';
import 'package:poche/screens/splashscreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    //Colors.red,
    Color(0xfff18d77),
    Color(0xfffdb94a),
    Color(0xff61cafa),
    Color(0xfffaf8eb),
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colors[_currentPage],
              colors[_currentPage],
              colors[_currentPage],
              _currentPage == 3
                  ? const Color(0xff43576f).withOpacity(0.7)
                  : Colors.green.withOpacity(0.8),
              _currentPage == 3
                  ? const Color(0xff43576f).withOpacity(0.7)
                  : Colors.green.withOpacity(0.8),
              _currentPage == 3
                  ? const Color(0xff43576f).withOpacity(0.7)
                  : Colors.green.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: _controller,
                  onPageChanged: (value) =>
                      setState(() => _currentPage = value),
                  itemCount: contents.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              contents[i].image,
                              height: SizeConfig.blockV! * 30,
                              //height: 230,
                            ),
                            const SizedBox(
                              height:10,
                            ),
                           /* SizedBox(
                              height: (height >= 840) ? 60 : 20,
                            ),*/
                            Text(
                              contents[i].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                //fontSize: (width <= 550) ? 30 : 35,
                                fontSize:30
                              ),
                            ),
                            //const SizedBox(height: 10),
                            Text(
                              contents[i].desc,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                //fontSize: (width <= 550) ? 17 : 25,
                                fontSize:17
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        contents.length,
                        (int index) => _buildDots(
                          index: index,
                        ),
                      ),
                    ),
                    _currentPage + 1 == contents.length
                        ? Padding(
                            padding: const EdgeInsets.all(30),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SplashScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors[_currentPage],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding:EdgeInsets.all(16),
                                textStyle: const TextStyle(fontSize: 15),
                              ),
                              child: const Text(
                                "COMMENCER",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _controller.jumpToPage(3);
                                  },
                                  style: TextButton.styleFrom(
                                    elevation: 0,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      //fontSize: (width <= 550) ? 13 : 17,
                                      fontSize: 15,
                                    ),
                                  ),
                                  child: const Text(
                                    "PASSER",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colors[_currentPage],
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        //color: Colors.black,
                                        color: colors[_currentPage],
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 0,
                                    padding:  EdgeInsets.all(16),
                                    textStyle: const TextStyle(
                                      //fontSize: (width <= 550) ? 13 : 17
                                      fontSize: 15,
                                    ),
                                  ),
                                  child: const Text(
                                    "NEXT",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
