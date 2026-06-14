# https://algo.monster/liteproblems/271
from typing import List

def encodeString(strs: List[str]) -> str:
    encodedString = ""
    for string in strs:
        strLen = str(len(string))
        encodedString += strLen + "#" + string
    return encodedString

def decodeString(string: str) -> List[str]:
    strIndex = 0
    decodedStrs = []
    while strIndex < len(string):
        length = ""
        
        # detect the length of string
        while string[strIndex] != '#':
            length += string[strIndex]
            strIndex += 1
        
        # By pass #
        strIndex += 1
        
        extractedString = string[strIndex:(strIndex + int(length))]
        decodedStrs.append(extractedString)
        strIndex += int(length)
    return decodedStrs
        