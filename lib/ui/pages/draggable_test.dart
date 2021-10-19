import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:temp_app/ui/base/base_page.dart';
import 'package:temp_app/utils/extensions.dart';
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
  static const List<int> CELLS_AROUND_X = [-1, -1, -1, 0, 0, 0, 1, 1, 1];
  static const List<int> CELLS_AROUND_Y = [-1, 0, 1, -1, 0, 1, -1, 0, 1];
  static const double CELL_SIZE = 50;
  static const double CELL_PADDING = 8;
  static const int DEFAULT_DRAG_ID = -2;
  List<List<Cell>> total = [];
  var maxX = 5;
  var maxY = 5;
  var counter = 0;
  var isDragStarted = false;
  var isMoveStarted = false;
  var dragStartedId = DEFAULT_DRAG_ID;

  bool _setData(
    int x,
    int y,
    Cell value,
  ) {
    setState(() {
      if (value.direction == null || value.direction == Axis.vertical) {
        var anchor = 0;
        if (_checkVertical(x, y, value.cellType, value.anchor)) {
          counter++;
          value.direction = Axis.vertical;
          _setDataVertical(x, y, value, value.anchor);
          return true;
        }
        while (anchor <= maxX) {
          if (_checkVertical(x, y, value.cellType, anchor)) {
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
        if (_checkHorizontal(x, y, value.cellType, value.anchor)) {
          counter++;
          value.direction = Axis.horizontal;
          _setDataHorizontal(x, y, value, value.anchor);
          return true;
        }
        while (anchor <= maxY) {
          if (_checkHorizontal(x, y, value.cellType, anchor)) {
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

  bool _checkVertical(
    int x,
    int y,
    CellType cellType,
    int anchor,
  ) {
    return _checkAllEmptyLeft(x, y, anchor + 1, cellType) &&
        _checkAllEmptyRight(x, y, cellType.getSize() - anchor, cellType);
  }

  bool _checkHorizontal(int x, int y, CellType cellType, int anchor) {
    return _checkAllEmptyTop(x, y, anchor + 1, cellType) &&
        _checkAllEmptyBottom(x, y, cellType.getSize() - anchor, cellType);
  }

  _setDataVertical(int x, int y, Cell value, int anchor) {
    _setDataRight(x, y - anchor, value);
  }

  _setDataHorizontal(int x, int y, Cell value, int anchor) {
    _setDataBottom(x - anchor, y, value);
  }

  _setDataAround(int x, int y) {
    CELLS_AROUND_X.forEachIndexed((px, i) {
      var posX = x + px;
      var posY = y + CELLS_AROUND_Y[i];
      var isPositionInBounds =
          posX < maxX && posY < maxY && posX >= 0 && posY >= 0;
      if (isPositionInBounds) {
        total[posX][posY].unitsAround++;
        logD("qq $posX $posY = ${total[posX][posY].unitsAround}");
      }
    });
  }

  _removeDataAround(int x, int y) {
    CELLS_AROUND_X.forEachIndexed((px, i) {
      var posX = x + px;
      var posY = y + CELLS_AROUND_Y[i];
      var isPositionInBounds =
          posX < maxX && posY < maxY && posX >= 0 && posY >= 0;
      if (isPositionInBounds) {
        if (total[posX][posY].unitsAround > 0) {
          total[posX][posY].unitsAround--;
          logD("dd $posX $posY = ${total[posX][posY].unitsAround}");
        }
      }
    });
  }

  _setDataRight(int x, int y, Cell value) {
    for (var i = 0; i < value.cellType.getSize(); i++) {
      var posY = y + i;
      if (posY < maxY) {
        total[x][posY] = value.copyWith(
          x: x,
          y: posY,
          id: counter,
          subId: i,
          unitsAround: total[x][posY].unitsAround,
        );
        _setDataAround(x, posY);
      }
    }
  }

  _setDataLeft(int x, int y, Cell value) {
    for (var i = 0; i < value.cellType.getSize(); i++) {
      var posY = y - i;
      if (posY >= 0) {
        total[x][posY] = value.copyWith(
          x: x,
          y: posY,
          id: counter,
          subId: i,
          unitsAround: total[x][posY].unitsAround,
        );
        _setDataAround(x, posY);
      }
    }
  }

  _setDataTop(int x, int y, Cell value) {
    for (var i = 0; i < value.cellType.getSize(); i++) {
      var posX = x - i;
      if (posX >= 0) {
        total[posX][y] = value.copyWith(
          x: posX,
          y: y,
          id: counter,
          subId: i,
          unitsAround: total[posX][y].unitsAround,
        );
        _setDataAround(posX, y);
      }
    }
  }

  _setDataBottom(int x, int y, Cell value) {
    for (var i = 0; i < value.cellType.getSize(); i++) {
      var posX = x + i;
      if (posX < maxX) {
        total[posX][y] = value.copyWith(
          x: posX,
          y: y,
          id: counter,
          subId: i,
          unitsAround: total[posX][y].unitsAround,
        );
        _setDataAround(posX, y);
      }
    }
  }

  bool _checkAllEmptyAround(int x, int y, int id, CellType cellType) {
    logD("CC $cellType");
    if (cellType == CellType.FILL_M) {
      return true;
    }
    var result = true;
    CELLS_AROUND_X.forEachIndexed((px, i) {
      var posX = x + px;
      var posY = y + CELLS_AROUND_Y[i];
      var isPositionInBounds =
          posX < maxX && posY < maxY && posX >= 0 && posY >= 0;
      if (isPositionInBounds) {
        var isClearCell = total[posX][posY].cellType == CellType.EMPTY ||
            total[posX][posY].cellType == CellType.FILL_M ||
            total[posX][posY].id == id;
        if (!isClearCell) {
          result = false;
        }
      }
    });
    return result;
  }

  bool _checkAllEmptyRight(int x, int y, int length, CellType cellType) {
    if (y + length > maxY) {
      return false;
    }
    for (var i = y; i < y + length; i++) {
      if (total[x][i].cellType != CellType.EMPTY ||
          !_checkAllEmptyAround(
            x,
            i,
            total[x][i].id,
            cellType,
          )) {
        logD("FALSE");
        return false;
      }
    }
    logD("TRUE");
    return true;
  }

  bool _checkAllEmptyLeft(int x, int y, int length, CellType cellType) {
    if (y - length + 1 < 0) {
      return false;
    }
    for (var i = y; i > y - length; i--) {
      if (total[x][i].cellType != CellType.EMPTY ||
          !_checkAllEmptyAround(
            x,
            i,
            total[x][i].id,
            cellType,
          )) {
        logD("FALSE");
        return false;
      }
    }
    logD("TRUE");
    return true;
  }

  bool _checkAllEmptyTop(int x, int y, int length, CellType cellType) {
    if (x - length + 1 < 0) {
      return false;
    }
    for (var i = x; i > x - length; i--) {
      if (total[x][i].cellType != CellType.EMPTY ||
          !_checkAllEmptyAround(
            i,
            y,
            total[i][y].id,
            cellType,
          )) {
        return false;
      }
    }
    return true;
  }

  bool _checkAllEmptyBottom(int x, int y, int lenght, CellType cellType) {
    if (x + lenght > maxY) {
      return false;
    }
    for (var i = x; i < x + lenght; i++) {
      if (total[x][i].cellType != CellType.EMPTY ||
          !_checkAllEmptyAround(
            i,
            y,
            total[i][y].id,
            cellType,
          )) {
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
              total[cell.x][cell.y] = Cell(unitsAround: cell.unitsAround);
              _removeDataAround(cell.x, cell.y);
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
                  Cell(cellType: CellType.FILL_1),
                  isMainBox: true,
                ),
                SizedBox(width: CELL_PADDING),
                _buildDraggableBox(
                  Cell(cellType: CellType.FILL_2),
                  isMainBox: true,
                ),
                SizedBox(width: CELL_PADDING),
                _buildDraggableBox(
                  Cell(cellType: CellType.FILL_3),
                  isMainBox: true,
                ),
                SizedBox(width: CELL_PADDING),
                _buildDraggableBox(
                  Cell(cellType: CellType.FILL_4),
                  isMainBox: true,
                ),
                SizedBox(width: CELL_PADDING),
                _buildDraggableBox(
                  Cell(cellType: CellType.FILL_M),
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
                width: CELL_SIZE,
                height: CELL_SIZE,
                child: Center(
                  child: Text(
                    "${data.cellType.getSize()}(${data.id})[${data.anchor}]",
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
                ? pos.dx +
                    (CELL_SIZE + CELL_PADDING + CELL_PADDING) * data.subId
                : pos.dx,
            data.direction == Axis.horizontal
                ? pos.dy +
                    (CELL_SIZE + CELL_PADDING + CELL_PADDING) * data.subId
                : pos.dy,
          );
        },
        feedback: _buildDraggableFeedback(data),
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
            dragStartedId = DEFAULT_DRAG_ID;
          });
        },
        onDragCompleted: () {
          logD("onDragCompleted");
          setState(() {
            isDragStarted = false;
            isMoveStarted = false;
            dragStartedId = DEFAULT_DRAG_ID;
          });
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          logD("onDraggableCanceled: $velocity $offset");
          _removeData(data);
          setState(() {
            isDragStarted = false;
            isMoveStarted = false;
            dragStartedId = DEFAULT_DRAG_ID;
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
    for (var i = 0; i < data.cellType.getSize(); i++) {
      items.add(
        Padding(
          padding: const EdgeInsets.all(CELL_PADDING),
          child: Container(
            color: Colors.grey,
            width: CELL_SIZE,
            height: CELL_SIZE,
            child: Material(
              type: MaterialType.transparency,
              child: Center(
                child: Text(
                  data.cellType.getSize().toString(),
                ),
              ),
            ),
          ),
        ),
      );
    }
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
      padding: const EdgeInsets.all(CELL_PADDING),
      child: Stack(
        children: [
          DragTarget<Cell>(
            builder: (c, candidateData, rejectedData) {
              // logD("candidateData: $candidateData");
              // logD("rejectedData: $rejectedData");
              return Container(
                color: Colors.green,
                width: CELL_SIZE,
                height: CELL_SIZE,
                child: Center(
                  child: Text(
                    total[x][y].unitsAround.toString(),
                  ),
                ),
              );
            },
            onAccept: (data) {
              logD("onAccept: $data");
              if (isMoveStarted) {
                _removeData(data);
              }
              var dataSetupSuccess = _setData(x, y, data);
              if (!dataSetupSuccess) {
                data.switchDirection();
                dataSetupSuccess = _setData(x, y, data);
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
              return data.cellType.getSize() > 0;
            },
            onAcceptWithDetails: (details) {
              logD("onAcceptWithDetails: ${details.toString()}");
            },
          ),
          (total[x][y].id > 0)
              ? _buildDraggableBox(total[x][y])
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

enum CellType {
  EMPTY,
  FILL_1,
  FILL_2,
  FILL_3,
  FILL_4,
  FILL_M,
}

extension CellTypeExtension on CellType {
  int getSize() {
    var size = 0;
    switch (this) {
      case CellType.EMPTY:
        size = 0;
        break;
      case CellType.FILL_1:
        size = 1;
        break;
      case CellType.FILL_2:
        size = 2;
        break;
      case CellType.FILL_3:
        size = 3;
        break;
      case CellType.FILL_4:
        size = 4;
        break;
      case CellType.FILL_M:
        size = 1;
        break;
    }
    return size;
  }
}

class Cell {
  int x;
  int y;
  int unitsAround;
  int id;
  Axis direction;
  int anchor;
  int subId;
  CellType cellType;

  Cell({
    this.x = -1,
    this.y = -1,
    this.unitsAround = 0,
    this.id = -1,
    this.direction,
    this.anchor = 0,
    this.subId = 0,
    this.cellType = CellType.EMPTY,
  });

  switchDirection() {
    if (direction != null) {
      direction = direction == Axis.vertical ? Axis.horizontal : Axis.vertical;
    }
  }

  Cell copyWith({
    int x,
    int y,
    int unitsAround,
    int id,
    int direction,
    int anchor,
    int subId,
    int cellType,
  }) {
    return Cell(
      x: x ?? this.x,
      y: y ?? this.y,
      unitsAround: unitsAround ?? this.unitsAround,
      id: id ?? this.id,
      direction: direction ?? this.direction,
      anchor: anchor ?? this.anchor,
      subId: subId ?? this.subId,
      cellType: cellType ?? this.cellType,
    );
  }

  @override
  String toString() {
    return 'Cell{cellType: $cellType, x: $x, y: $y, data: $unitsAround, id: $id, direction: $direction, anchor: $anchor, subId: $subId}';
  }
}
