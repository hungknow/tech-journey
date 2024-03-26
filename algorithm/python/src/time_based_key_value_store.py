# https://leetcode.com/problems/time-based-key-value-store/

class TimeMap:
    def __init__(self):
        # {
        # "foo": {
        #     1: "bar",
        #     4: "bar2"
        # },
        #}
        self.store = {}

    def set(self, key: str, value: str, timestamp: int) -> None:
        self.store[key] = self.store.get(key, {})
        self.store[key][timestamp] = value 

    def get(self, key: str, timestamp: int) -> str:
        if key not in self.store:
            return ""
        obj = self.store[key]
        if timestamp in obj:
            return obj[timestamp]
        keys = list(obj.keys()) 
        l = 0
        r = len(keys) - 1
        while l <= r:
            if keys[l] >= timestamp and timestamp < keys[r]:
                return obj[keys[l]]
            m = (l + r) // 2
            midKey = keys[m]
            # print(l, r, keys[l], keys[r], keys[m], midKey, timestamp)
            if midKey == timestamp:
                return obj[m]
            elif keys[m] < timestamp:
                l = m + 1
            elif keys[m] > timestamp:
                r = m
        return obj[keys[-1]]