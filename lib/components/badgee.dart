import 'package:flutter/material.dart';

class Badgee extends StatelessWidget {
  final Widget child;
  final int value;
  final Color? color;
  Badgee({
    required this.child,
    required this.value,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    //Aqui estamos utilizando o widget Stack para empilhar os widgets
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? Theme.of(context).colorScheme.secondary),
            constraints: const BoxConstraints(
              minHeight: 16,
              minWidth: 16,
            ),
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10),
            ),
          ),
        )
      ],
    );
  }
}
