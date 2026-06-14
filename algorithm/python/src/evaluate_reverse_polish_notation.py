# https://leetcode.com/problems/evaluate-reverse-polish-notation/description/

from typing import List


def evaluateReversePolishNotation(tokens: List[str]) -> int:
    operators = ['+', '-', '*', '/']
    stacks = []
    for token in tokens:
        if token in operators:
            if len(stacks) < 2:
                raise ValueError('Invalid input')
            a = stacks.pop()
            b = stacks.pop()
            match token:
                case '+':
                    stacks.append(b + a)
                case '-':
                    stacks.append(b - a)
                case '*':
                    stacks.append(b * a)
                case '/':
                    if a == 0:
                        raise ValueError('Invalid input')
                    stacks.append(int(b / a))
        else:
           stacks.append(int(token)) 
           
    if len(stacks) != 1:
        raise ValueError('Invalid input')

    return stacks[0]