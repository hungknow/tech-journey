#  Given a array of possibly overlapping ranges, produces
#  an array of non-overlapping ranges covering the same
#  values.
from functools import cmp_to_key
from typing import List, Tuple

def nonOverlappingRanges(ranges: List[Tuple[int, int]]) -> List[Tuple[int, int]]:
    sorted_ranges = sorted(ranges, key=cmp_to_key(lambda x, y: 1 if x[0] > y[0] else -1))
    res = []
    for r in sorted_ranges:
        # The first item in the result
        # or the first item in range is greater than the last item in the last result
        if not res or r[0] > res[-1][1]:
            res.append(r)
        else:
            # The last item in the result is less than the last item in the range
            res[-1] = (res[-1][0], max(res[-1][1], r[1]))
    return res

