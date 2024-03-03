from typing import List

# https://leetcode.com/problems/car-fleet/
# Time: O(nlogn)
# Space: O(n)
def carFleet(target: int, position: List[int], speed: List[int]) -> int:
    sorted_cars = sorted(zip(position, speed), key=lambda x: x[0])
    fleets = []
    for pos, spd in sorted_cars:
        time_to_target = (target - pos) / spd
        while fleets and time_to_target >= fleets[-1]:
            fleets.pop()
        fleets.append(time_to_target)
            
    return len(fleets)