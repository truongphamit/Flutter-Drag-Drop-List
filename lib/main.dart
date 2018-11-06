import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  List<String> rows = new List<String>()
    ..add('Task 1')
    ..add('Task 2')
    ..add('Task 3')
    ..add('Task 4');

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Drag Drop ListView',
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Drag Drop ListView'),
        ),
        body: new DragDropPageListView(
          items: rows,
          itemBuilder: (_, int index) => new Card(
                elevation: 0.0,
                shape: BorderDirectional(
                    bottom: BorderSide(color: Colors.black12)),
                margin: EdgeInsets.all(0.0),
                child: new ListTile(
                    leading: new Icon(Icons.radio_button_unchecked),
                    title: new Text(rows[index])),
              ),
        ),
      ),
    );
  }
}

class DragDropPageListView extends StatefulWidget {
  final List items;
  final IndexedWidgetBuilder itemBuilder;

  DragDropPageListView({this.items, this.itemBuilder})
      : assert(items != null),
        assert(itemBuilder != null);

  @override
  State createState() => new DragDropPageListViewState();
}

class DragDropPageListViewState extends State<DragDropPageListView> {
  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: (context, constraint) {
        return new ListView.builder(
          shrinkWrap: true,
          itemCount: widget.items.length + 1,
          addRepaintBoundaries: true,
          itemBuilder: (context, index) {
            return new LongPressDraggable<int>(
              axis: Axis.vertical,
              data: index,
              child: new DragTarget<int>(
                onAccept: (int data) {
                  handleAccept(data, index);
                },
                builder: (BuildContext context, List<int> data,
                    List<dynamic> rejects) {
                  List<Widget> children = [];
                  if (data.isNotEmpty) {
                    children.add(
                      Opacity(
                        opacity: 0.0,
                        child: getItem(context, data[0]),
                      ),
                    );
                  }
                  children.add(getItem(context, index));

                  return new Column(
                    children: children,
                  );
                },
              ),
              onDragStarted: () {},
              feedback: SizedBox(
                width: constraint.maxWidth,
                child: getItem(context, index, true),
              ),
              childWhenDragging: new Container(),
            );
          },
        );
      },
    );
  }

  void handleAccept(int data, int index) {
    setState(() {
      if (index > data) {
        index--;
      }
      dynamic imageToMove = widget.items[data];
      widget.items.removeAt(data);
      widget.items.insert(index, imageToMove);
    });
  }

  Widget getItem(BuildContext context, int index, [bool dragged = false]) {
    if (index == widget.items.length) {
      if (widget.items.isEmpty) {
        return new Container();
      }
      return new Opacity(
        opacity: 0.0,
        child: getItem(context, index - 1),
      );
    }

    return new Material(
      elevation: dragged ? 4.0 : 0.0,
      child: widget.itemBuilder(context, index),
    );
  }
}
