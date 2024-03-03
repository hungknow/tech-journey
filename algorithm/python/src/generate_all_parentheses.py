from typing import List

# Time: O(2^n)
# Space: O(2^n)
def generateAllParentheses(count: int) -> List[str]:
    res = []
    def dfs(left: int, right: int, s: str):
        if left == count and right == count:
            res.append(s)
            return
        if left < count:
            dfs(left + 1, right, s + "(")    
        if left > right:
            dfs(left, right + 1, s + ")") 

    dfs(0, 0, "")
    return res