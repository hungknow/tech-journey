def validParentheses(s: str) -> bool:
    stack = []
    for c in s:
        if c in ["(", "[", "{"]:
            stack.append(c)
        else:
            if len(stack) == 0 or \
                (c == ")" and stack[-1] != "(") or \
                (c == "]" and stack[-1] != "[") or \
                (c == "}" and stack[-1] != "{"):
                return False
            stack.pop()

    if len(stack) > 0:
        return False
       
    return True