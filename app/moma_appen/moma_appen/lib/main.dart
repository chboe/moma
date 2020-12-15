import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'aboutDialog.dart';
import 'secondRoute.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'login.dart';
import 'movie.dart';
import 'profile.dart';
import 'myLikedMovies.dart';
import 'UserInfoAlert.dart';
//////////////////////////////

class ExampleHomePage extends StatefulWidget {
  @override
  _ExampleHomePageState createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage>
    with TickerProviderStateMixin {
  List<Movie> welcomeImages = [
    new Movie(0,"Blade Runner","EN","This is a movie",["Future", "Action"],"10/10/22",120,"pics/download.jpg"),
    new Movie(0,"Parasite","EN","This is a movie",["Future", "Action"],"10/10/22",120,"pics/movie2.jpg"),
    new Movie(0,"Aladdin","EN","This is a movie",["Future", "Action"],"10/10/22",120,"pics/movie3.jpg"),
    new Movie(0,"Batman","EN","This is a movie",["Future", "Action"],"10/10/22",120,"pics/download2.jpg"),
    //new Movie(0,"EARN FREE MONEY","EN","This is a movie",["Future", "Action"],"10/10/22",120,"pics/money.jpg")

  ];

  int _selectedIndex = 1;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    CardController controller; //Use this to trigger swap.
    //final int currentIndex =1;

      List<Movie> liked = [new Movie(0,"Blade Runner","EN","This is a movie",["Future", "Action"],"10/10/22",120,"pics/download.jpg") ];
      List<Profile> friends = [
        new Profile("Hr Ost", [], liked, "pics/profil.jpg"),
        new Profile("Hr Toast", [], [], "pics/profil.jpg"),
        new Profile("Hr Dope", [], [], "pics/profil.jpg"),
        new Profile("Graham", [], [], "pics/graham.jpg"),
      ];
      //int n = 0;

      List<Widget> _widgetOptions = <Widget>[
        new ListView(
          children: <Widget>[
            CircularProfileAvatar(
              'pics/profil.jpg',
              //'pics/profile.jpg',
              //'https://ih1.redbubble.net/image.1148904245.6671/flat,750x,075,f-pad,750x1000,f8f8f8.u2.jpg',
              //'data:image/jpeg;base64,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',
              radius: 100, // sets radius, default 50.0
              backgroundColor: Colors.transparent, // sets background color, default Colors.white
              borderWidth: 10,  // sets border, default 0.0
              initialsText: Text(
                "User",
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),  // sets initials text, set your own style, default Text('')
              borderColor: Colors.transparent, // sets border color, default Colors.white
              elevation: 5.0, // sets elevation (shadow of the profile picture), default value is 0.0
              //foregroundColor: Colors.brown.withOpacity(0.5), //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('My Info'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => userInfo(context),
            ),
            ListTile(
              leading: Icon(Icons.thumb_up),
              title: Text('Liked'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MyLikedMovies(
                    likedMovies: liked
                    )
                  )
                );},
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: () => alertDialog(context),
            ),
          ],
        ),
       Container(
         height: MediaQuery.of(context).size.height * 0.6,
         child: new TinderSwapCard(
           swipeUp: false,
           swipeDown: false,
           orientation: AmassOrientation.BOTTOM,
           totalNum: welcomeImages.length,
           stackNum: 3,
           swipeEdge: 4.0,
           maxWidth: MediaQuery.of(context).size.width * 0.7,
           maxHeight: MediaQuery.of(context).size.width *1.0,
           minWidth: MediaQuery.of(context).size.width * 0.6,
           minHeight: MediaQuery.of(context).size.width *0.9,
           cardBuilder: (context, index) => Card(

               child: Stack(
                 fit: StackFit.expand,
                 children: <Widget>[
                   Container(
                       alignment: Alignment.center,
                       child: Image.asset('${welcomeImages[index].poster}',
                           fit: BoxFit.fill)
                       ),
                   Container(
                       alignment: Alignment.bottomLeft,

                       child: Text(
                         '${welcomeImages[index].name}',
                         textAlign: TextAlign.center,
                         overflow: TextOverflow.ellipsis,
                         style: TextStyle(color: Colors.white, decorationColor: Colors.red ,fontSize: 30),
                       )
                   ),
                   Container(
                       alignment: Alignment.topRight,
                       child: IconButton(
                         icon: Icon(Icons.info),
                         color: Colors.white,
                         onPressed: () => movieBioDialog(context, welcomeImages[index]),
                       )
                   )
                 ],
               )
           ),
           cardController: controller = CardController(),
           swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
             /// Get swiping card's alignment
             if (align.x < 0) {
               //Card is LEFT swiping
             } else if (align.x > 0) {
               //Card is RIGHT swiping
               //liked.add(welcomeImages[n]);
               //print("hej :");
               //print(n);
             }
             //n++;
           },
           swipeCompleteCallback:
               (CardSwipeOrientation orientation, int index) {
             /// Get orientation & index of swiped card!


                 liked.add(welcomeImages[index]);
                 print(liked[index].name);
           },
         ),
       ),
        Stack(

          children: <Widget> [
            ListView.builder(
            itemCount:  friends.length,
            itemBuilder: (context, index){
                return ListTile(leading: Image.asset(friends[index].picture), title: Text(friends[index].name), onTap: () {
                Navigator.push(context, MaterialPageRoute(
                builder: (context) => SecondRoute(
                    inCommon: friends[index].myMovies
                  )
                )
              );},);
            },
          ),
            Center(
              child: Align(
                alignment: Alignment.bottomCenter,
                child:
                  FloatingActionButton(

                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      // Respond to button press
                    },
                    child: Icon(Icons.add),
                  ),
                      ))])
                          ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }
    return new Scaffold(
      appBar: AppBar(
        title: const Text('MoMa'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),


      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            title: Text("Profile"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            title: Text("Swipe"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text("Friends"),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,

      ),
    );
  }
}


