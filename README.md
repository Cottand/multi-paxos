# Multi-Paxos

This is an Elixir implementation of a variant of the Paxos algorithm,
as described in the paper [Paxos Made Moderately Complex](https://dl.acm.org/doi/10.1145/2673577) _(Robbert van Renesse and Deniz Altınbüken)_. Paxos is a [consensus algorithm](https://en.wikipedia.org/wiki/Consensus_(computer_science)), a fundamental problem in distributed computing. 

We model several servers, each of which maintains a replica of a ledger. The all Service a number of clients, who broadcast transactions. Our ledger replicas must guarantee:
- **Consistency**: transactions are appended in the same order to all ledgers
- **Liveness**: all transactions will eventually be appended
- **Safety**: only transactions broadcast by clients will be appended
- **Failure tolerance**: as long as a majority of replicas is correct (ie, have not crashed), we will maintain Consistency, Liveness, and Safety.

The resulting architecture is not simple:

![](https://codimd.s3.shivering-isles.com/demo/uploads/upload_58c824142e3b35e0f1a2ced2e1e43811.png)

![](https://codimd.s3.shivering-isles.com/demo/uploads/upload_f95e10d340bc28219674778beb8d3fd6.png)


Every module is its own Elixir process, and no global concurrency primitives (like locks or semaphores) are used at all. This is a non-blocking, partially asynchronous distributed system.

For a more detailed implementation description, see the report.

To see possible running configuraitons, see `configuration.ex` file.
Change running configurations as variable in Makefile.
The `prevent_livelock` ones are the most relevant ones!

## Running

`make clean` - remove compiled code  
`make compile` - compile  
`make run` - same as `make run SERVERS=5 CLIENTS=5 CONFIG=default DEBUG=0 MAX_TIME=15000`
