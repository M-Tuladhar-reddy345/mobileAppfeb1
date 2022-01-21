import 'package:flutter/material.dart';

class Form extends StatelessWidget {
  final List<String> input_labels;
  final String submit_button_text;
  final Map input_controllers;
  final Function on_press;
  Form(List<String> this.input_labels, String this.submit_button_text,
      this.input_controllers, this.on_press);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: input_labels.map((value) {
              return TextField(
                decoration: InputDecoration(labelText: value),
                controller: input_controllers[value],
              );
            }).toList(),
          ),
          FlatButton(
            onPressed: () => on_press(),
            child: Text(submit_button_text),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
