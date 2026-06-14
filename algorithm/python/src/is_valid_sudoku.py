from typing import List

# https://leetcode.com/problems/valid-sudoku/description/
def isValidSudoku(board: List[List[str]]) -> bool:
    rows = [[] for _ in range(9)]
    columns = [[] for _ in range(9)] 
    rectangles = [[] for _ in range(9)]

    for row_index, row in enumerate(board):
        for column_index, cell in enumerate(row):
            if cell == '.':
                continue
            if cell in columns[column_index]:
                return False
            columns[column_index].append(cell)

            if cell in rows[row_index]:
                return False 
            rows[row_index].append(cell)
            
            rectangleIndex = (row_index // 3) * 3 + (column_index // 3)
            if cell in rectangles[rectangleIndex]:
                return False
            rectangles[rectangleIndex].append(cell)
    return True