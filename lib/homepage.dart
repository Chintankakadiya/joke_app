import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:joke_app/jokelistPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'jokes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences _prefs;
  List<Joke> _storedJokes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadStoredJokes();
  }

  @override
  Future<void> _loadStoredJokes() async {
    _prefs = await SharedPreferences.getInstance();
    final jokesJson = _prefs.getStringList('jokes');
    if (jokesJson != null) {
      setState(() {
        _storedJokes =
            jokesJson.map((json) => Joke.fromJson(jsonDecode(json))).toList();
      });
    }
  }

  Future<Joke> _fetchRandomJoke() async {
    final response =
        await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));
    if (response.statusCode == 200) {
      final jokeJson = jsonDecode(response.body);
      final joke = Joke.fromJson(jokeJson);
      await _storeJoke(joke);
      return joke;
    } else {
      throw Exception('Failed to fetch joke');
    }
  }

  Future<void> _storeJoke(Joke joke) async {
    setState(() {
      _storedJokes.add(joke);
    });
    final jokesJson =
        _storedJokes.map((joke) => jsonEncode(joke.toJson())).toList();
    await _prefs.setStringList('jokes', jokesJson);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chuck Norris Jokes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            JokesListPage(jokes: _storedJokes)));
              },
              icon: Icon(Icons.list))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  _fetchRandomJoke().then((joke) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Random Joke'),
                            content: Text(joke.value),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'))
                            ],
                          );
                        });
                  });
                },
                child: Text("Fetch My Laugh")),
          ],
        ),
      ),
    );
  }
}
