import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class SimpleTodo extends StatelessWidget {
  String? todo;
  Function removeTodo;
  SimpleTodo({super.key, this.todo, required this.removeTodo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.2,
            color: const Color(0xFFFFFFFF),
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Text(todo ?? "Fuck", style: TextStyle(fontSize: 18)),
          FlatButton(onPressed: () => {removeTodo(todo)}, child: Text("X"))
        ],
      ),
    );
  }
}
