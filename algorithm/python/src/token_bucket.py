# https://dev.to/satrobit/rate-limiting-using-the-token-bucket-algorithm-3cjh
# https://code.activestate.com/recipes/578659-python-3-token-bucket-rate-limit/
import math
import time

class TokenBucket:
    def __init__(self, tokens, time_unit):
        # number of tokens added to the bucket in each time unit.
        self.tokens = tokens
        # the tokens are added in this time frame.
        self.time_unit = time_unit
        # this function is called when the packet is being forwarded.
        # self.forward_callback = forward_callback
        # this function is called when the packet should be dropped.
        # self.drop_callback = drop_callback
        self.bucket = tokens
        # the timestamp that we previously handled a packet
        self.last_check = time.time()
    
    # return number of packets that be dropped
    def consume(self, packet_num):
        current = time.time()
        time_passed = current - self.last_check
        self.last_check = current
        self.bucket += time_passed * (self.tokens / self.time_unit)

        if self.bucket > self.tokens:
            self.bucket = self.tokens

        coverred_packet = min(packet_num, math.floor(self.bucket))
        self.bucket -= coverred_packet
        
        # If the bucket doesn't have enough token, drop the packet.
        if coverred_packet != packet_num:
            return packet_num - coverred_packet
        else:
            return 0