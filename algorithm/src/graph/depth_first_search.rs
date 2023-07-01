use std::collections::{VecDeque, HashSet};

pub fn depth_first_search(graph: &Graph, root: Vertex, objective: Vertex) -> Option<Vec<u32>> {
    let mut visited: HashSet<Vertex> = HashSet::new();
    let mut history: Vec<u32> = Vec::new();
    let mut queue = VecDeque::new();
    queue.push_back(root);

    while let Some(current_vertex) = queue.pop_front() {
        history.push(current_vertex.value());

        if current_vertex == objective {
            return Some(history);
        }

        for children in current_vertex.children(graph).into_iter().rev() {
            if visited.insert(children) {
                queue.push_front(children); 
            }

        }
    }
    None
}

#[derive(Copy, Clone, PartialEq, Eq, Hash)]
pub struct Vertex(u32);

impl core::fmt::Debug for Vertex {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_tuple("").field(&self.0).finish()
    }
}

#[derive(Copy, Clone, PartialEq, Eq, Hash)]
pub struct Edge(u32, u32);

#[derive(Clone)]
pub struct Graph {
    #[allow(dead_code)]
    vertices: Vec<Vertex>,
    #[allow(dead_code)]
    edges: Vec<Edge>,
}

impl Graph {
    pub fn new(vertices: Vec<Vertex>, edges: Vec<Edge>) -> Self {
        Graph { vertices, edges }
    }
}

impl Vertex {
    pub fn value(&self) -> u32 {
        self.0
    }

    pub fn children(&self, graph: &Graph) -> VecDeque<Vertex> {
        graph.edges.iter().filter(|e| e.0 == self.0).map(|x| x.1.into()).collect()
    }
}

impl From<u32> for Vertex {
   fn from(value: u32) -> Self {
       Vertex(value)
   } 
}

impl From<(u32, u32)> for Edge {
   fn from(value: (u32, u32)) -> Self {
       Edge(value.0, value.1)
   } 
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn find_1() {
        let vertices = vec![1, 2, 3, 4, 5, 6, 7];
        let edges = vec![(1, 2), (1, 3), (2, 4), (2, 5), (3, 6), (3, 7)];

        let root: u32 = 1;
        let fail_objective = 99;
        let success_objective = 7;
        let correct_path = vec![1, 2, 4, 5, 3, 6, 7];

        let graph = Graph::new(
            vertices.into_iter().map(|v| v.into()).collect(),
            edges.into_iter().map(|e| e.into()).collect(),
        );

        assert_eq!(
            depth_first_search(&graph, root.into(), fail_objective.into()),
            None
        );

        assert_eq!(
            depth_first_search(&graph, root.into(), success_objective.into()),
            Some(correct_path)
        );
    }

    #[test]
    fn find_2_sucess() {
        let vertices = vec![0, 1, 2, 3, 4, 5, 6, 7];
        let edges = vec![
            (0, 1),
            (1, 3),
            (3, 2),
            (2, 1),
            (3, 4),
            (4, 5),
            (5, 7),
            (7, 6),
            (6, 4),
        ];

        let root = 0;
        let objective = 6;

        let correct_path = vec![0, 1, 3, 2, 4, 5, 7, 6];

        let graph = Graph::new(
            vertices.into_iter().map(|v| v.into()).collect(),
            edges.into_iter().map(|e| e.into()).collect(),
        );

        assert_eq!(
            depth_first_search(&graph, root.into(), objective.into()),
            Some(correct_path)
        );
    }
}