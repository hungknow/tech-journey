import math
import time

class SlidingWindow:
    def __init__(self, capacity, time_unit, get_time=time.time):
        self.capacity = capacity
        self.time_unit = time_unit
        self.get_time = get_time
        self.cur_time = self.get_time()
        self.cur_count = 0
        self.pre_count = 0
    
    def consume(self, handle_num):
        now_time = self.get_time()
        diff = now_time - self.cur_time
        if diff > self.time_unit:
            if diff > self.time_unit * 2:
                self.cur_time = now_time
                self.pre_count = 0
            else:
                self.cur_time = self.cur_time + self.time_unit
                self.pre_count = self.cur_count
            self.cur_count = 0

        previous_portion = (self.time_unit - diff) / self.time_unit if diff < self.time_unit else 0
        ec = self.cur_count + math.floor(self.pre_count * previous_portion)

        if ec >= self.capacity:
            return handle_num
        
        remaining_capacity = self.capacity - ec
        handled_num = min(remaining_capacity, handle_num)
        self.cur_count += handled_num
        return handle_num - handled_num