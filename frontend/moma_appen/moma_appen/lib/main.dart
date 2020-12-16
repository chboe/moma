import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'aboutDialog.dart';
import 'friendMatches.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'movie.dart';
import 'profile.dart';
import 'myLikedMovies.dart';
import 'UserInfoAlert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  Profile loggedInAs;

  MainPage({Key key, @required this.loggedInAs}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState(loggedInAs);
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  Profile loggedInAs;
  TextEditingController _addFriendController = new TextEditingController();

  _MainPageState(this.loggedInAs) {
    _initState(loggedInAs);
  }

  List<Movie> _movies = [];
  List<Profile> _friends = [];
  int _selectedIndex = 1; //Starts on swiping page

  Widget _widgetOptions(int index) {
    switch (index) {
      case 0:
        return _profileWidget();
      case 1:
        return _cardWidget();
      case 2:
        return _friendsWidget();
    }
    return null; //does not happen
  }

  //This will show movies once they are loaded in.
  _initState(Profile loggedInAs) {
    _loadMovies(loggedInAs).then((m) => setState(() {
          _movies = m.toList();
        }));
    _loadFriends(loggedInAs).then((f) => setState(() {
          _friends = f.toList();
        }));
  }

  //Is called when an icon on the bottomnavigationbar is clicked
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _initState(loggedInAs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('MoMa'),
      ),
      body: _widgetOptions(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Friends'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped, //Calls the function with the right index
      ),
    );
  }

  Future<List<Movie>> _loadMovies(Profile loggedInAs) async {
    var url =
        'http://10.0.2.2:8080/getSwipeableMovies/' + loggedInAs.id.toString();
    var response = await http.get(url);
    if (response.statusCode == 200)
      return (json.decode(response.body) as List)
          .map((i) => Movie.fromJson(i))
          .toList();
    return List.empty();
  }

  Future<List<Profile>> _loadFriends(Profile loggedInAs) async {
    var url = 'http://10.0.2.2:8080/getFriendsList/' + loggedInAs.id.toString();
    var response = await http.get(url);
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((i) => Profile.fromJson(i))
          .toList();
    } else {
      return List.empty();
    }
  }

  Widget _cardWidget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      child: new TinderSwapCard(
        swipeUp: false,
        swipeDown: false,
        orientation: AmassOrientation.BOTTOM,
        totalNum: _movies.length,
        stackNum: 3,
        swipeEdge: 4.0,
        maxWidth: MediaQuery.of(context).size.width * 0.7,
        maxHeight: MediaQuery.of(context).size.width * 1.0,
        minWidth: MediaQuery.of(context).size.width * 0.6,
        minHeight: MediaQuery.of(context).size.width * 0.9,
        cardBuilder: (context, index) => Card(
            child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                child: Image.network('${_movies[index].poster}',
                    fit: BoxFit.fill)),
            Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  '${_movies[index].name}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white,
                      decorationColor: Colors.red,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.info),
                  color: Colors.white,
                  onPressed: () => movieBioDialog(context, _movies[index]),
                ))
          ],
        )),
        swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
          // Get swiping card's alignment
          if (align.x < 0) {
            //Card is LEFT swiping
          } else if (align.x > 0) {
            //Card is RIGHT swiping
          }
        },
        swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
          if(orientation == CardSwipeOrientation.RIGHT){
            _likeMovie(loggedInAs, _movies[index]);
          } else if(orientation == CardSwipeOrientation.LEFT) {
            _dislikeMovie(loggedInAs, _movies[index]);
          }
          if(_movies.length-index < 5){
            _loadMovies(loggedInAs).then((m) => setState(() {
              _movies = m.toList();
            }));
          }
        },
      ),
    );
  }

  void _likeMovie(Profile loggedInAs, Movie likedMovie) async {
    var url = 'http://10.0.2.2:8080/likeMovie/' +
        loggedInAs.id.toString() +
        "/" +
        likedMovie.id.toString();
    var response = await http.get(url);
  }

  void _dislikeMovie(Profile loggedInAs, Movie likedMovie) async {
    var url = 'http://10.0.2.2:8080/dislikeMovie/' +
        loggedInAs.id.toString() +
        "/" +
        likedMovie.id.toString();
    var response = await http.get(url);
  }

  Widget _profileWidget() {
    return new ListView(
      children: <Widget>[
        CircularProfileAvatar(
          '',
          radius: 100,
          backgroundColor: Colors.transparent,
          borderWidth: 10,
          initialsText: Text(
            "User",
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
          borderColor: Colors.transparent,
          elevation: 5.0,
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('My Info'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => userInfo(context, loggedInAs),
        ),
        ListTile(
          leading: Icon(Icons.thumb_up),
          title: Text('Liked'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MyLikedMovies(me: loggedInAs)));
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('About'),
          trailing: Icon(Icons.keyboard_arrow_right),
          onTap: () => alertDialog(context),
        ),
      ],
    );
  }
  void _addFriend() async {
    var url = 'http://10.0.2.2:8080/addFriend/' +
        loggedInAs.id.toString() +
        "/" +
        _addFriendController.text;
    var response = await http.get(url);
    _initState(loggedInAs);
  }

  Widget _friendsWidget() {
    return new Column(children: <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20, right: 20),
              child: TextField(
                      controller: _addFriendController,
                      decoration: new InputDecoration(
                        labelText: 'Friend username',
                      ),
                    )
            )
          ),
          FlatButton(
            child: Text(
              'Add',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueGrey[800],
              ),
            ),
            onPressed: _addFriend,
          ),
        ],
      ),
      Expanded(
        child: SizedBox(
          height: 150,
          child: ListView.builder(
            itemCount: _friends.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: Image.asset('pics/profil.jpg'),
                  title: Text(_friends[index].name),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) =>
                                FriendMatches(
                                    me: loggedInAs,
                                    friend: _friends[index]
                                )
                        )
                    );
                  }
              );
            },
          ),
        )
      )
    ]);
  }

  FlatButton iconColumnHelper(IconData icon, String text, Function function) {
    return new FlatButton(
        onPressed: function,
        child: Column(children: <Widget>[
          Icon(
            icon,
            color: Colors.grey,
            size: 24.0,
          ),
          Text(text),
        ]));
  }
}
