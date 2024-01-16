import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SudokuSolver(),
    );
  }
}

class SudokuSolver extends StatefulWidget {
  @override
  _SudokuSolverState createState() => _SudokuSolverState();
}

class _SudokuSolverState extends State<SudokuSolver> {
  late List<List<int>> sudokuGrid;

  @override
  void initState() {
    super.initState();
    sudokuGrid = List.generate(9, (index) => List.filled(9, 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sudoku Solver'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 9; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < 9; j++)
                    SizedBox(
                      width: 30,
                      height: 30,
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          setState(() {
                            sudokuGrid[i][j] = int.tryParse(value) ?? 0;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  solveSudoku();
                });
              },
              child: Text('Solve Sudoku'),
            ),
          ],
        ),
      ),
    );
  }

  bool isSafe(int row, int col, int num) {
    // Check if the number is already in the row or column
    for (int i = 0; i < 9; i++) {
      if (sudokuGrid[row][i] == num || sudokuGrid[i][col] == num) {
        return false;
      }
    }

    // Check if the number is already in the 3x3 box
    int startRow = row - row % 3;
    int startCol = col - col % 3;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (sudokuGrid[startRow + i][startCol + j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  bool solveSudoku() {
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        if (sudokuGrid[row][col] == 0) {
          for (int num = 1; num <= 9; num++) {
            if (isSafe(row, col, num)) {
              sudokuGrid[row][col] = num;

              if (solveSudoku()) {
                return true;
              }

              sudokuGrid[row][col] = 0; // backtrack
            }
          }
          return false; // no valid number found, backtrack
        }
      }
    }
    return true; // puzzle solved
  }
}
