import 'package:flutter/material.dart';

import 'jokes.dart';

class JokesListPage extends StatelessWidget {
  final List<Joke> jokes;
  JokesListPage({required this.jokes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stored Jokes'),
      ),
      body: ListView.builder(
        itemCount: jokes.length,
        itemBuilder: (context, index) {
          final joke = jokes[index];
          return ListTile(
            title: Text(joke.value),
            subtitle: Text(joke.dateTime.toString()),
          );
        },
      ),
    );
  }
}
