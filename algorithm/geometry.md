## Geometry

### 1. Convex Hull / Fence

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0587 | [Erect the Fence](./problems/0587-erect-the-fence.md) | [Go](./golang/0587_erect_the_fence.go) | _O(nlogn)_| _O(n)_| Hard           || Convex Hull, `Monotone Chain` | 
| 1924 | [Erect the Fence II](./problems/1924-erect-the-fence-ii.md) | [Go](./golang/1924_erect_the_fence_ii.go) | _O(n)_ on average | _O(n)_| Hard           | 🔒 | `Welzl's Algorithm` | 

---

### 2. 3D / Surface

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 0892 | [Surface Area of 3D Shapes](./problems/0892-surface-area-of-3d-shapes.md) | [Go](./golang/0892_surface_area_of_3d_shapes.go) | _O(n^2)_| _O(1)_| Easy           ||| 

---

### 3. Other

| # | Title | Solution | Time | Space | Difficulty | Tag | Note |
|-----|----------------|---------------|---------------|---------------|-------------|--------------|-----|
| 1453 | [Maximum Number of Darts Inside of a Circular Dartboard](./problems/1453-maximum-number-of-darts-inside-of-a-circular-dartboard.md) | [Go](./golang/1453_maximum_number_of_darts_inside_of_a_circular_dartboard.go) | _O(n^2 * logn)_| _O(n)_| Hard           || Line Sweep |
| 1515 | [Best Position for a Service Centre](./problems/1515-best-position-for-a-service-centre.md) | [Go](./golang/1515_best_position_for_a_service_centre.go) | _O(n * iter)_| _O(n)_| Hard           || Geometric Median, Gradient Descent, Weiszfeld's Algorithm |
| 1610 | [Maximum Number of Visible Points](./problems/1610-maximum-number-of-visible-points.md) | [Go](./golang/1610_maximum_number_of_visible_points.go) | _O(nlogn)_| _O(n)_| Hard           || Two Pointers, Sliding Window |
| 1956 | [Minimum Time For K Virus Variants to Spread](./problems/1956-minimum-time-for-k-virus-variants-to-spread.md) | [Go](./golang/1956_minimum_time_for_k_virus_variants_to_spread.go) | _O(nlogn * logr)_ | _O(n)_ | Hard | 🔒 | Geometry, Binary Search, Line Sweep, Segment Tree, Coordinate Compression
| 2101 | [Detonate the Maximum Bombs](./problems/2101-detonate-the-maximum-bombs.md) | [Go](./golang/2101_detonate_the_maximum_bombs.go) | _O(\|V\|^2 + \V\| * \|E\|)_ | _O(\V\| + \|E\|)_ | Medium | | Graph, DFS, BFS
