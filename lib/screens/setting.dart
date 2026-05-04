import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:targetapp/main.dart';

class Setting extends StatefulWidget {
  @Preview()
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  int? _selectedGrade = AppState().grade;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text('학년:'),
            SizedBox(width: 5),
            DropdownButton<int>(
              value: _selectedGrade,
              items: [1, 2, 3]
                  .map((e) => DropdownMenuItem<int>(value: e, child: Text('$e학년')))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedGrade = value);
                
              },
            ),
          ],
        ),
      ],
    );
  }
}
