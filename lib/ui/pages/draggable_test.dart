import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp_app/ui/base/base_page.dart';
import 'package:temp_app/utils/logger.dart';

class DraggableTestPage extends BasePage {
  static route() {
    return MaterialPageRoute(builder: (context) => DraggableTestPage());
  }

  DraggableTestPage({Key key})
      : super(
          key: key,
          state: _DraggableTestPageState(),
        );
}

class _DraggableTestPageState extends State<BaseStatefulWidget> {
  List<List<Cell>> total = [];
  var maxX = 5;
  var maxY = 5;
  var counter = 0;
  var isDragStarted = false;
  var isMoveStarted = false;
  var dragStartedId = -2;

  bool _setData(
    int x,
    int y,
    Cell value,
  ) {
    setState(() {
      if (value.direction == null || value.direction == Axis.vertical) {
        var anchor = 0;
        if (_checkVertical(x, y, value.data, value.anchor)) {
          //todo collapse same
          counter++;
          value.direction = Axis.vertical;
          _setDataVertical(x, y, value, value.anchor);
          return true;
        }
        while (anchor <= maxX) {
          if (_checkVertical(x, y, value.data, anchor)) {
            counter++;
            value.direction = Axis.vertical;
            value.anchor = anchor;
            _setDataVertical(x, y, value, anchor);
            return true;
          } else {
            anchor++;
          }
        }
      }
      if (value.direction == null || value.direction == Axis.horizontal) {
        var anchor = 0;
        if (_checkHorizontal(x, y, value.data, value.anchor)) {
          counter++;
          value.direction = Axis.horizontal;
          _setDataHorizontal(x, y, value, value.anchor);
          return true;
        }
        while (anchor <= maxY) {
          if (_checkHorizontal(x, y, value.data, anchor)) {
            counter++;
            value.direction = Axis.horizontal;
            value.anchor = anchor;
            _setDataHorizontal(x, y, value, anchor);
            return true;
          } else {
            anchor++;
          }
        }
      }
    });
    return false;
  }

  bool _checkVertical(int x, int y, int lenght, int anchor) {
    return _checkAllEmptyLeft(x, y, anchor + 1) &&
        _checkAllEmptyRight(x, y, lenght - anchor);
  }

  bool _checkHorizontal(int x, int y, int lenght, int anchor) {
    return _checkAllEmptyTop(x, y, anchor + 1) &&
        _checkAllEmptyBottom(x, y, lenght - anchor);
  }

  _setDataVertical(int x, int y, Cell value, int anchor) {
    _setDataRight(x, y - anchor, value);
  }

  _setDataHorizontal(int x, int y, Cell value, int anchor) {
    _setDataBottom(x - anchor, y, value);
  }

  _setDataRight(int x, int y, Cell value) {
    for (var i = 0; i < value.data; i++) {
      var posY = y + i;
      if (posY < maxY) {
        total[x][posY] = value.copyWith(x: x, y: posY, id: counter, subId: i);
      }
    }
  }

  _setDataLeft(int x, int y, Cell value) {
    for (var i = 0; i < value.data; i++) {
      var posY = y - i;
      if (posY >= 0) {
        total[x][posY] = value.copyWith(x: x, y: posY, id: counter, subId: i);
      }
    }
  }

  _setDataTop(int x, int y, Cell value) {
    for (var i = 0; i < value.data; i++) {
      var posX = x - i;
      if (posX >= 0) {
        total[posX][y] = value.copyWith(x: posX, y: y, id: counter, subId: i);
      }
    }
  }

  _setDataBottom(int x, int y, Cell value) {
    for (var i = 0; i < value.data; i++) {
      var posX = x + i;
      if (posX < maxX) {
        total[posX][y] = value.copyWith(x: posX, y: y, id: counter, subId: i);
      }
    }
  }

  bool _checkAllEmptyRight(int x, int y, int lenght) {
    if (y + lenght > maxY) {
      return false;
    }
    for (var i = y; i < y + lenght; i++) {
      if (total[x][i].id >= 0) {
        return false;
      }
    }
    return true;
  }

  bool _checkAllEmptyLeft(int x, int y, int lenght) {
    if (y - lenght + 1 < 0) {
      return false;
    }
    for (var i = y; i > y - lenght; i--) {
      if (total[x][i].id >= 0) {
        return false;
      }
    }
    return true;
  }

  bool _checkAllEmptyTop(int x, int y, int lenght) {
    if (x - lenght + 1 < 0) {
      return false;
    }
    for (var i = x; i > x - lenght; i--) {
      if (total[i][y].id >= 0) {
        return false;
      }
    }
    return true;
  }

  bool _checkAllEmptyBottom(int x, int y, int lenght) {
    if (x + lenght > maxY) {
      return false;
    }
    for (var i = x; i < x + lenght; i++) {
      if (total[i][y].id >= 0) {
        return false;
      }
    }
    return true;
  }

  _removeData(Cell value) {
    setState(() {
      if (value.x >= 0 && value.y >= 0) {
        total.forEach((row) {
          row.forEach((cell) {
            if (cell.id == value.id) {
              total[cell.x][cell.y] = Cell();
            }
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < maxX; i++) {
      List<Cell> row = [];
      for (var j = 0; j < maxY; j++) {
        row.add(new Cell(x: i, y: j));
      }
      total.add(row);
    }
    logD("Total: $total");
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Draggable test"),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDraggableBox(
                  Cell(data: 0),
                  isMainBox: true,
                ),
                SizedBox(width: 8),
                _buildDraggableBox(
                  Cell(data: 1),
                  isMainBox: true,
                ),
                SizedBox(width: 8),
                _buildDraggableBox(
                  Cell(data: 2),
                  isMainBox: true,
                ),
                SizedBox(width: 8),
                _buildDraggableBox(
                  Cell(data: 3),
                  isMainBox: true,
                ),
                SizedBox(width: 8),
                _buildDraggableBox(
                  Cell(data: 4),
                  isMainBox: true,
                ),
              ],
            ),
            SizedBox(height: 24),
            _buildCells(),
          ],
        ),
      ),
    );
  }

  Widget _buildCells() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < maxX; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var j = 0; j < maxY; j++) _buildDragTarget(i, j),
            ],
          )
      ],
    );
  }

  Widget _buildDraggableBox(
    Cell data, {
    isMainBox = false,
  }) {
    return GestureDetector(
      onTap: () {
        logD("TAP ${data.id}");
      },
      onDoubleTap: () {
        logD("DOUBLE_TAP ${data.id}");
        if (data != null) {
          _removeData(data);
          data.switchDirection();
          data.anchor = data.subId;
          if (!_setData(data.x, data.y, data)) {
            data.switchDirection();
            _setData(data.x, data.y, data);
          }
        }
      },
      child: Draggable<Cell>(
        data: data,
        child: (isDragStarted && dragStartedId == data.id && !isMainBox)
            ? SizedBox.shrink()
            : Container(
                color: Colors.amber,
                width: 50,
                height: 50,
                child: Center(
                  child: Text(
                    "${data.data}(${data.id})[${data.anchor}]",
                  ),
                ),
              ),
        dragAnchorStrategy: (Draggable<Object> draggable, BuildContext context,
            Offset position) {
          final RenderBox renderObject =
              context.findRenderObject() as RenderBox;
          var pos = renderObject.globalToLocal(position);
          return Offset(
            data.direction == Axis.vertical
                ? pos.dx + 66.0 * data.subId
                : pos.dx, //todo size + padding
            data.direction == Axis.horizontal
                ? pos.dy + 66.0 * data.subId
                : pos.dy,
          );
        },
        feedback: _buildDraggableFeedback(data),
        // feedbackOffset:
        onDragStarted: () {
          logD("onDragStarted");
          setState(() {
            isDragStarted = true;
            isMoveStarted = !isMainBox;
            dragStartedId = data.id;
            if (!isMainBox) {
              total.forEach((row) {
                row.forEach((cell) {
                  if (cell.id == data.id) {
                    total[cell.x][cell.y].anchor = data.subId;
                  }
                });
              });
            }
          });
        },
        onDragEnd: (DraggableDetails details) {
          logD("onDragEnd: $details");
          setState(() {
            isDragStarted = false;
            isMoveStarted = false;
            dragStartedId = -2;
          });
        },
        onDragCompleted: () {
          logD("onDragCompleted");
          setState(() {
            isDragStarted = false;
            isMoveStarted = false;
            dragStartedId = -2;
          });
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          logD("onDraggableCanceled: $velocity $offset");
          _removeData(data);
          setState(() {
            isDragStarted = false;
            isMoveStarted = false;
            dragStartedId = -2;
          });
        },
        onDragUpdate: (DragUpdateDetails details) {
          //logD("onDragUpdate: $details");
        },
      ),
    );
  }

  Widget _buildDraggableFeedback(Cell data) {
    List<Widget> items = [];
    for (var i = 0; i < data.data; i++) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.grey,
            width: 50,
            height: 50,
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: Text(
                  data.data.toString(),
                ),
              ),
            ),
          ),
        ),
      );
    }
    logD("|  ${data}");
    var root = (data.direction != null && data.direction == Axis.horizontal)
        ? Column(
            children: items,
          )
        : (data.direction != null && data.direction == Axis.vertical)
            ? Row(
                children: items,
              )
            : Row(
                children: items,
              );

    return root;
  }

  Widget _buildDragTarget(int x, int y) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          DragTarget<Cell>(
            builder: (c, candidateData, rejectedData) {
              // logD("candidateData: $candidateData");
              // logD("rejectedData: $rejectedData");
              return Container(
                color: Colors.green,
                width: 50,
                height: 50,
                child: Center(
                  child: Text(
                    total[x][y].data.toString(),
                  ),
                ),
              );
            },
            onAccept: (data) {
              logD("onAccept: $data");
              if (isMoveStarted) {
                _removeData(data);
              }
              if (!_setData(x, y, data)) {
                data.switchDirection();
                _setData(x, y, data);
              }
            },
            onLeave: (data) {
              logD("onLeave: $data");
            },
            onMove: (details) {
              logD("onMove: $details");
            },
            onWillAccept: (data) {
              logD("onWillAccept: $data");
              return data.data > 0;
            },
            onAcceptWithDetails: (details) {
              logD("onAcceptWithDetails: ${details.toString()}");
            },
          ),
          (total[x][y].data > 0)
              ? _buildDraggableBox(total[x][y])
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class Cell {
  int x;
  int y;
  int data;
  int id;
  Axis direction;
  int anchor;
  int subId;

  Cell({
    this.x = -1,
    this.y = -1,
    this.data = 0,
    this.id = -1,
    this.direction,
    this.anchor = 0,
    this.subId = 0,
  });

  switchDirection() {
    if (direction != null) {
      direction = direction == Axis.vertical ? Axis.horizontal : Axis.vertical;
    }
  }

  Cell copyWith({
    int x,
    int y,
    int data,
    int id,
    int direction,
    int anchor,
    int subId,
  }) {
    return Cell(
      x: x ?? this.x,
      y: y ?? this.y,
      data: data ?? this.data,
      id: id ?? this.id,
      direction: direction ?? this.direction,
      anchor: anchor ?? this.anchor,
      subId: subId ?? this.subId,
    );
  }

  @override
  String toString() {
    return 'Cell{x: $x, y: $y, data: $data, id: $id, direction: $direction, anchor: $anchor, subId: $subId}';
  }
}
