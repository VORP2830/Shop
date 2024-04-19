import 'package:flutter/material.dart';
import 'package:shop/providers/counter.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo contador'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Text(CounterProvider.of(context).state.getValue().toString()),
          IconButton(
            onPressed: () {
              setState(() {
                CounterProvider.of(context).state.inc();
              });
              ;
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                CounterProvider.of(context).state.dec();
              });
            },
            icon: const Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}