use std::cmp::{Reverse};
use std::collections::{BTreeMap, BinaryHeap, VecDeque};
use std::ops::Add;

type Graph<V, E> = BTreeMap<V, BTreeMap<V, E>>;

pub fn dijkstra_breath_first_search<V: Ord + Copy + std::hash::Hash, E: Ord + Copy + Add<Output = E>>(
    graph: &Graph<V, E>,
    start_vertex: V,
    start_vertex_weight: E
) -> BTreeMap<V, Option<(V, E)>> {
    let mut shortPath = BTreeMap::<V, Option<(V, E)>>::new();
    
    // The (vertex, accumulcated_weight) pair
    let mut discoveredNodes = VecDeque::new();

    shortPath.insert(start_vertex, None);
    discoveredNodes.push_front((start_vertex, start_vertex_weight));

    while let Some((vertex, current_weight)) = discoveredNodes.pop_front() {
        // Find the neighbor nodes
        for (neighbor_vertex, weight) in &graph[&vertex] {
            if *neighbor_vertex == start_vertex {
                continue;
            }
            match shortPath.get(&neighbor_vertex) {
                // Find the path is shorter than before, replace it
                Some(Some((_, previous_short_weight))) if *previous_short_weight > current_weight + *weight => {
                    shortPath.insert(*neighbor_vertex, Some((vertex, current_weight + *weight)));
                }
                Some(Some((_, previous_short_weight))) if *previous_short_weight <= current_weight + *weight => {
                }
                _ => {
                    discoveredNodes.push_back((*neighbor_vertex, current_weight + *weight));
                    
                    // Add the path from current vertex to this neighbor vertex
                    shortPath.insert(*neighbor_vertex, Some((vertex, current_weight + *weight)));
                }
            }
        }
    }

    return shortPath;
}

pub fn dijkstra<V: Ord + Copy, E: Ord + Copy + Add<Output = E>>(
    graph: &Graph<V, E>,
    start_vertex: V,
) -> BTreeMap<V, Option<(V, E)>> {
    let mut ans = BTreeMap::<V, Option<(V, E)>>::new();
    
    // Discovered node, but not visited
    let mut previous_node = BinaryHeap::new();

    ans.insert(start_vertex, None);
    // previousNode.push(Reverse((0, start_vertex, start_vertex)));

    // From the start vertex, add the map 
    for (next_vertex, weight) in &graph[&start_vertex] {
        ans.insert(*next_vertex, Some((start_vertex, *weight)));
        previous_node.push(Reverse((*weight, *next_vertex, start_vertex)));
    }

    while let Some(Reverse((dist_new, new, prev))) = previous_node.pop() {
        match ans.get(&new) {
            // what we popped is what is in ans, we'll compute it
            Some(Some((p, d))) if *p == prev && *d == dist_new => {}
            None => {},
            // otherwise it's not interesting
            _ => continue,
        }

        for (next, weight) in &graph[&new] {
            match ans.get(next) {
                Some(Some((_, dist_next))) if dist_new + *weight >= *dist_next => {},
                Some(None) => {},
                _ => {
                    ans.insert(*next, Some((new, *weight + dist_new)));
                    previous_node.push(Reverse((*weight + dist_new, *next, new)));
                }
            }
        }
    }

    ans
}

#[cfg(test)]
mod tests {
    use super::{dijkstra, dijkstra_breath_first_search, Graph};
    use std::collections::BTreeMap;

    fn add_edge<V: Ord + Copy, E: Ord>(graph: &mut Graph<V, E>, v1: V, v2: V, c: E) {
        graph.entry(v1).or_insert_with(BTreeMap::new).insert(v2, c);
        graph.entry(v2).or_insert_with(BTreeMap::new);
    }

    #[test]
    fn single_vertex() {
        let mut graph: Graph<usize, usize> = BTreeMap::new();
        graph.insert(0, BTreeMap::new());

        let mut dists = BTreeMap::new();
        dists.insert(0, None);

        assert_eq!(dijkstra_breath_first_search(&graph, 0, 0), dists);
    }

    #[test]
    fn single_edge() {
        let mut graph = BTreeMap::new();
        add_edge(&mut graph, 0, 1, 2);
        // add_edge(&mut graph, 0, 3, 3);

        let mut dists_0 = BTreeMap::new();
        dists_0.insert(0, None);
        dists_0.insert(1, Some((0, 2)));

        assert_eq!(dijkstra_breath_first_search(&graph, 0, 0), dists_0);

        let mut dists_1 = BTreeMap::new();
        dists_1.insert(1, None);

        assert_eq!(dijkstra_breath_first_search(&graph, 1, 0), dists_1);
    }

    #[test]
    fn tree_1() {
        let mut graph = BTreeMap::new();
        let mut dists = BTreeMap::new();
        dists.insert(1, None);
        for i in 1..100 {
            add_edge(&mut graph, i, i * 2, i * 2);
            add_edge(&mut graph, i, i * 2 + 1, i * 2 + 1);

            match dists[&i] {
                Some((_, d)) => {
                    dists.insert(i * 2, Some((i, d + i * 2)));
                    dists.insert(i * 2 + 1, Some((i, d + i * 2 + 1)));
                }
                None => {
                    dists.insert(i * 2, Some((i, i * 2)));
                    dists.insert(i * 2 + 1, Some((i, i * 2 + 1)));
                }
            }
        }

        assert_eq!(dijkstra_breath_first_search(&graph, 1, 0), dists);
    }

    #[test]
    fn graph_1() {
        let mut graph = BTreeMap::new();
        add_edge(&mut graph, 'a', 'c', 12);
        add_edge(&mut graph, 'a', 'd', 60);
        add_edge(&mut graph, 'b', 'a', 10);
        add_edge(&mut graph, 'c', 'b', 20);
        add_edge(&mut graph, 'c', 'd', 32);
        add_edge(&mut graph, 'e', 'a', 7);

        let mut dists_a = BTreeMap::new();
        dists_a.insert('a', None);
        dists_a.insert('c', Some(('a', 12)));
        dists_a.insert('d', Some(('c', 44)));
        dists_a.insert('b', Some(('c', 32)));
        assert_eq!(dijkstra_breath_first_search(&graph, 'a', 0), dists_a);

        let mut dists_b = BTreeMap::new();
        dists_b.insert('b', None);
        dists_b.insert('a', Some(('b', 10)));
        dists_b.insert('c', Some(('a', 22)));
        dists_b.insert('d', Some(('c', 54)));
        assert_eq!(dijkstra_breath_first_search(&graph, 'b', 0), dists_b);

        let mut dists_c = BTreeMap::new();
        dists_c.insert('c', None);
        dists_c.insert('b', Some(('c', 20)));
        dists_c.insert('d', Some(('c', 32)));
        dists_c.insert('a', Some(('b', 30)));
        assert_eq!(dijkstra_breath_first_search(&graph, 'c', 0), dists_c);

        let mut dists_d = BTreeMap::new();
        dists_d.insert('d', None);
        assert_eq!(dijkstra_breath_first_search(&graph, 'd', 0), dists_d);

        let mut dists_e = BTreeMap::new();
        dists_e.insert('e', None);
        dists_e.insert('a', Some(('e', 7)));
        dists_e.insert('c', Some(('a', 19)));
        dists_e.insert('d', Some(('c', 51)));
        dists_e.insert('b', Some(('c', 39)));
        assert_eq!(dijkstra_breath_first_search(&graph, 'e', 0), dists_e);
    }
}
