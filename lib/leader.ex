defmodule Leader do
  def start(acceptors, replicas) do
    ballot = {0, self()}
    spawn(Scout, :start, [self(), acceptors, ballot])
    active = false
    proposals = Map.new()
    next(acceptors, replicas, ballot, proposals, active)
  end

  defp next(acceptors, replicas, ballot, proposals, active) do
    receive do
      {:propose, slot, command} ->
        new_proposal = !Map.has_key?(proposals, slot)
        proposals = if new_proposal, do: Map.put(proposals, slot, command), else: proposals

        if new_proposal do
          if active,
            do: spawn(Commander, :start, [self(), acceptors, replicas, {ballot, slot, command}])
        end

        next(acceptors, replicas, ballot, proposals, active)

      {:adopted, ^ballot, pvals} ->
        :TODO_WTF

      {:adopted, other_ballot, _} ->
        IO.puts("#{inspect(self())} - ERROR: Received unexpected ballot #{inspect(other_ballot)}")
        exit(:crash)

      {:preempted, {other_ballot_num, other_leader}} ->
        {active, ballot} =
          if Util.ballot_greater?({other_ballot_num, other_leader}, ballot) do
            new_ballot = {other_ballot_num + 1, self()}
            spawn(Scout, :start, [self(), acceptors, new_ballot])

            {false, new_ballot}
          else
            {active, ballot}
          end

        next(acceptors, replicas, ballot, proposals, active)
    end
  end
end
