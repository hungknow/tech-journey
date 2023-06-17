This folder contains simple proof-of-concept reference implementations of yjs, automerge and sync9's list types.
CRDT is useful when building the collaborative applications.

# CRDT concept: 
- https://www.youtube.com/watch?v=OOlnp2bZVRs
- https://www.youtube.com/watch?v=B5NULPSiOGw
- https://www.youtube.com/watch?v=BRvj8PykSc4

Reference: https://www.bartoszsypytkowski.com/the-state-of-a-state-based-crdts/

# Indexed Sequence CRDT
- [YATA](https://www.bartoszsypytkowski.com/yata/)
	- yjs
	- yrs

# Whats in the box
The actual implementations share the base code in crdts.ts.
The main point of divergence is in the `integrate` function for each algorithm.
These methods are called when inserting a new item, find the position at which the new item should be inserted.

# Useful projects
- https://github.com/soundcloud/roshi
- https://riak.com/products/riak-kv


# Reference
- https://github.com/josephg/reference-crdts/tree/main
- https://arxiv.org/pdf/1603.01529.pdf
- https://arxiv.org/pdf/1503.09052.pdf
