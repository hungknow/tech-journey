# https://leetcode.com/problems/search-a-2d-matrix/description/
from typing import List

def searchFor2DMatrix(matrix: List[List[int]], target: int) -> bool:
    lrow = 0
    rrow = len(matrix) - 1
    lcol = 0
    rcol = len(matrix[0]) - 1

    while lrow <= rrow and lcol <= rcol:
        mid_row = (rrow + lrow) // 2
        if matrix[mid_row][lcol] <= target and matrix[mid_row][rcol] >= target:
            while lcol <= rcol:
                mid_col = (rcol + lcol) // 2
                if matrix[mid_row][mid_col] == target:
                    return True
                elif matrix[mid_row][mid_col] < target:
                    lcol = mid_col + 1
                else:
                    rcol = mid_col - 1
            return False
        elif matrix[mid_row][0] > target:
            rrow = mid_row - 1
        elif matrix[mid_row][0] < target:
            lrow = mid_row + 1
    
    return False