import 'package:flutter/material.dart';

class MySimpleDialog extends StatefulWidget {
    _MySimpleDialog createState() => _MySimpleDialog();
}

class _MySimpleDialog extends State<MySimpleDialog> {

    void showAlertDialog(BuildContext context) {
        showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
                return  SimpleDialog(
                    title:  Text('选择'),
                    children: <Widget>[
                        SimpleDialogOption(
                            child:  Text('选项 1'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                        SimpleDialogOption(
                            child:  Text('选项 2'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
    }
    Widget build(BuildContext context) {
        return  RaisedButton(
            padding:  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            //padding
            child:  Text(
                'show SimpleDialog',
                style:  TextStyle(
                    fontSize: 18.0, //textsize
                    color: Colors.white, // textcolor
                ),
            ),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            //shadow
            splashColor: Colors.blueGrey,
            onPressed: () {
                showAlertDialog(context);
            });
    }

}