# Gossip protocol

Consul implements the Serf gossip protocol for managing cluster membership and broadcasting messages. The protocol operates through two gossip pools:

1. **LAN gossip pool** (port 8301, required): Communicates with all nodes in a single datacenter to share membership information. It automatically discovers servers, distributes failure detection throughout the cluster, and supports fast and reliable event broadcasts.

2. **WAN gossip pool** (port 8302, optional): Extends agent gossip to operate between a primary datacenter and one or more secondary datacenters in WAN-federated environments. Membership information enables servers to perform cross-datacenter requests.

**How models interact**: Nodes in the gossip pool exchange state information periodically. Each node randomly selects a few other nodes to exchange membership data, ensuring information propagates through the cluster. The protocol uses the SWIM (Scalable Weakly-consistent Infection-style Process Group Membership) algorithm with Lifeguard enhancements.

**Final state**: All nodes converge to a consistent view of cluster membership, with failure detection ensuring that failed or partitioned nodes are marked as unhealthy and removed from the cluster. The gossip protocol achieves eventual consistency across all nodes in the pool.

**Limitations**:
- **Eventual consistency**: Gossip provides eventual consistency, not strong consistency. There may be temporary inconsistencies between nodes.
- **Network overhead**: Periodic gossip exchanges consume bandwidth and CPU resources, especially in large clusters.
- **False positives**: The failure detection mechanism may temporarily mark healthy nodes as failed during network partitions or high latency.
- **No ordering guarantees**: Gossip messages are not guaranteed to be delivered in the same order across all nodes.
- **Limited payload size**: Not suitable for large data transfers; primarily designed for small control messages.
- **Security overhead**: Requires encryption key management and rotation for secure operation.

# Swim protocol

**Models**:
- **Member**: Each node in the gossip pool maintains information about all other members, including their health status, last known state, and metadata. Members track the failure detector state for each peer.
- **Failure detector**: Implements the core SWIM algorithm to detect node failures. Uses indirect probes and randomized suspicion timers to balance between detecting failures quickly and avoiding false positives.
- **Suspicion state**: Intermediate state between alive and failed. When a node is suspected to have failed, it enters suspicion with an associated timeout. Suspicion allows time for the node to respond or for confirmation from other nodes.
- **Ping probe**: Direct health check sent to a specific member to verify its status. Pings are sent at random intervals to random members, spreading failure detection load across the cluster.
- **Indirect probe (ping-req)**: When a direct ping fails, the probing node requests other members to ping the suspected node on its behalf. This improves detection reliability and reduces false positives.
- **Ack**: Response to a ping probe, confirming the node is alive and healthy. Contains current member state and metadata.
- **Suspect**: State indicating a node is potentially failed. Other nodes mark a node as suspect when they receive suspicion messages or fail to confirm its health.
- **Confirm**: Message indicating that a node is definitively failed. When enough evidence accumulates (failed pings, suspicion timeouts), a node is marked as failed and removed from the cluster.
- **Alive message**: Notification from a node confirming it is operational. Can be used to clear suspicion status and restore a node to the alive state.
- **Lifeguard extensions**: Enhancements to SWIM that use health scores and adaptive ping intervals to optimize failure detection sensitivity and reduce false positives in dynamic network conditions.

**How models interact**: Each node periodically selects random members to ping directly. If a ping succeeds, the member remains alive. If a ping fails, the probing node sends indirect ping requests to other members to verify the suspected node's health. Simultaneously, the suspect timer starts, and suspicion messages are gossiped to the cluster. Other nodes independently verify the suspected node and share results. When sufficient evidence confirms failure (multiple ping failures, expired suspicion), a confirm message is generated and gossiped, removing the failed member. Lifeguard extensions adjust ping frequency and suspicion timeouts based on network conditions and failure rates, balancing detection speed with reliability.

**Final state**: The SWIM protocol provides a consistent view of cluster membership across all nodes, with failure detection ensuring that failed or partitioned nodes are identified and removed within bounded time. The protocol achieves eventual consistency, with all nodes converging to the same membership view as gossip disseminates state changes. Alive members communicate their status, while failed members are removed and must rejoin to participate.

**Limitations**:
- **Eventual consistency**: Like gossip, SWIM provides eventual consistency. There may be temporary divergence in membership views between nodes during failure detection.
- **False positives**: Network partitions or temporary unavailability can cause healthy nodes to be temporarily marked as failed, though suspicion timers and indirect probes mitigate this.
- **Detection latency**: Time to detect failures depends on ping intervals and suspicion timeouts, introducing a bounded but non-zero delay between failure and removal.
- **Network sensitivity**: Performance and accuracy depend on network reliability. High latency or packet loss can increase false positive rates or slow failure detection.
- **Scalability tradeoffs**: Direct pings and indirect probes create O(N) network operations, requiring careful tuning for large clusters. Randomization helps distribute load but cannot eliminate overhead.
- **Resource overhead**: Maintaining failure detector state and sending periodic probes consumes memory, CPU, and network resources proportional to cluster size.
- **Quiescent nodes**: Nodes that are alive but unresponsive (e.g., due to resource exhaustion) may be incorrectly detected as failed, as SWIM primarily tests reachability not application health.
- **Recovery complexity**: Failed nodes cannot simply resume operation; they must rejoin the cluster and regain membership state, which may involve data resynchronization.

# Raft protocol

**Models**:
- **Follower**: All nodes start as followers. They accept log entries from the leader and cast votes in elections.
- **Candidate**: When followers don't receive entries for some time, they self-promote to candidate and request votes from peer set members.
- **Leader**: The elected node that records the authoritative Raft log and replicates it to followers. The leader must accept new log entries and replicate to all followers.
- **Log entries**: Fundamental units of work representing cluster changes (adding nodes, registering services, updating key-value pairs). Entries have an ordered Raft index.
- **Peer set**: All members participating in log replication. In Consul, server nodes in a datacenter form the peer set.
- **Quorum**: Majority of peer set members (at least `(N/2)+1` for set size `N`). Required to commit log entries and form a cluster.

**How models interact**: Followers receive log entries from the leader and cast votes. When no entries arrive, followers become candidates and request votes. Candidates receiving quorum become leaders. Leaders write entries to durable storage, replicate to quorum of followers, and once committed (stored on quorum), apply entries to the state machine. Consul blocks writes until entries are committed and applied.

**Final state**: The Raft protocol achieves strong consistency across the cluster. All members agree on log entries and their order when entries are committed to a quorum.

**Limitations**:
- **Availability tradeoff**: Cluster becomes unavailable when quorum is lost. Writes cannot process and manual intervention may be needed to re-establish a leader.
- **Write latency**: Leader must write to durable storage and replicate to quorum followers before writes complete, adding latency.
- **Single leader**: Only the leader can process writes and (in consistent mode) reads, limiting throughput.
- **Limited fault tolerance**: Tolerates at most `(N-1)/2` node failures for cluster size N (e.g., 1 failure for 3 servers, 2 for 5).
- **Network dependency**: Requires reliable network communication between leader and followers for log replication.
- **Storage growth**: Logs grow unbounded without snapshots; Consul uses MemDB snapshots to compact logs.
- **Bootstrap complexity**: New datacenters require initial bootstrap mode and careful server joining to preserve consistency.

# Consul

**What Consul is solving**:
Consul addresses service discovery, service mesh, and configuration management challenges in distributed systems. It provides:
- **Service discovery**: Automatically registering services and enabling clients to discover available service instances through DNS or HTTP APIs
- **Health checking**: Monitoring service health and routing traffic only to healthy instances
- **Key-value storage**: Hierarchical configuration data stored with strong consistency via Raft
- **Multi-datacenter support**: Federation across datacenters with cross-DC service discovery and queries
- **Service mesh**: Zero-trust networking with automatic TLS, service-to-service authorization, and observability

Consul's architecture enables these features by combining gossip protocols for membership and event dissemination with Raft for consistent state management.

**Models**:
- **Agent**: Lightweight process running on each node that manages service registration, health checks, and gossip pool participation. Agents can run in client or server mode.
- **Client agent**: Lightweight agent that forwards RPC requests to server agents, performs health checks, and participates in LAN gossip. Clients store minimal local state.
- **Server agent**: Full-featured agent that participates in Raft consensus, stores service catalog data, handles RPC requests, and participates in both LAN and WAN gossip pools.
- **Service**: Logical definition of an application or microservice, including name, port, tags, and metadata. Services are registered with agents and discovered by other services.
- **Health check**: Periodic verification of service or node health (HTTP, TCP, Script, Docker, TTL, gRPC, and Alias check types). Health results influence routing and service availability.
- **Service catalog**: Centralized directory of all registered services, nodes, and health checks maintained by server agents with strong consistency via Raft.
- **Session**: Temporary binding between a node and service behavior, used for leader election, distributed locking, and coordination. Sessions are tied to node health.
- **KV store**: Hierarchical key-value data store with strong consistency. Supports ACID transactions, watch queries, and TTL on keys.
- **ACL (Access Control List)**: Fine-grained permission system controlling access to services, KV entries, and Consul APIs. Supports role-based policies and token management.
- **Connect**: Service mesh implementation providing automatic mTLS encryption, service identity via certificates, intention-based authorization, and sidecar proxy management.
- **Prepared query**: Query template with optional failover, nearness sorting, and service filtering. Enables intelligent routing strategies.
- **Intention**: Policy defining which services may communicate (allow or deny). Enforced by Connect proxies to implement zero-trust networking.
- **Datacenter**: Logical grouping of Consul agents sharing the same LAN gossip pool and Raft consensus domain. Datacenters federate via WAN gossip for cross-DC queries.
- **WAN federation**: Mechanism linking multiple datacenters through WAN gossip pools, enabling cross-DC service discovery, replication of ACLs and prepared queries, and multi-DC failover.

**How models interact**:
Agents start and join the gossip pool, discovering peers and establishing cluster membership. Client agents register services and health checks locally, then forward read/write RPCs to server agents. Server agents participate in Raft consensus, maintaining the authoritative service catalog and KV store with strong consistency. Health check results from all agents converge at servers, updating service health status. Sessions are created on server agents and tied to node health; if a node fails, associated sessions expire, releasing locks and triggering coordination events. Connect agents generate TLS certificates, create sidecar proxies, and enforce intentions between services. Prepared queries are configured and stored in the catalog; clients execute queries with optional datacenter failover. ACL tokens and policies govern all API operations, with servers validating permissions. Datacenters federate via WAN gossip, enabling cross-DC queries and configuration replication while maintaining independent Raft consensus domains.

**Final state**:
Consul provides a unified platform for service discovery, configuration, and service mesh. The service catalog converges to a consistent view across all server nodes via Raft, while gossip ensures rapid membership dissemination and event propagation. Clients discover services with configurable consistency modes (default, stale, or consistent). Health checking ensures only healthy services receive traffic, and Connect enforces secure service-to-service communication. Multi-datacenter deployment enables geographic distribution with coordinated service discovery and configuration.

**Why Consul beats or complements other protocols**:
Consul doesn't compete with individual protocols but integrates them into a comprehensive service platform:
- **vs. Gossip alone**: Gossip provides membership and event dissemination but lacks strong consistency, query capabilities, and service-specific features. Consul adds Raft for consistent state, rich APIs, DNS/HTTP interfaces, and service mesh.
- **vs. SWIM alone**: SWIM excels at failure detection but doesn't solve service registration, discovery, or configuration. Consul builds SWIM-based failure detection into a full service platform with health checks, KV storage, and ACLs.
- **vs. Raft alone**: Raft provides strong consistency but has high write latency and no built-in membership or event dissemination. Consul uses Raft for critical state while using gossip for low-latency membership events, balancing consistency and performance.
- **vs. etcd**: Both use Raft for strong consistency and offer KV storage, but Consul adds service discovery, health checking, DNS interface, service mesh, and multi-datacenter federation. etcd is more focused on configuration storage.
- **vs. ZooKeeper**: ZooKeeper provides coordination primitives but requires client-side implementations and has complex deployment. Consul offers simpler APIs (DNS/HTTP), built-in health checking, and automatic TLS service mesh.
- **vs. Kubernetes service discovery**: Kubernetes has built-in service discovery but is cluster-bound. Consul works across any infrastructure, supports multi-cloud and multi-datacenter deployment, and provides additional features like service mesh and KV store.
- **vs. static configuration**: Consul eliminates manual service endpoint management with automatic registration, health-based filtering, and dynamic updates, reducing operational overhead and improving reliability.

Consul's innovation lies in combining gossip (for low-latency membership and events), SWIM (for failure detection), and Raft (for strong consistency) into a cohesive service platform that addresses real-world distributed systems challenges: service discovery, configuration management, health checking, and secure service-to-service communication.