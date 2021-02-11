defmodule Acceptor do
  def start(config) do
    ballot = :bottom
    accepted = MapSet.new()
    next(config, ballot, accepted)
  end

  def next(config, ballot, accepted) do
    receive do
      {:p1a, leader, new_ballot} ->
        ballot = if Util.ballot_greater?(new_ballot, ballot), do: new_ballot, else: ballot
        send(leader, {:p1b, {self(), ballot, accepted}})
        next(config, ballot, accepted)

      {:p2a, leader, {new_ballot, slot, command}} ->
        accepted =
          if new_ballot == ballot,
            do: MapSet.put(accepted, {ballot, slot, command}),
            else: accepted

            IO.puts("(acceptor): sending ballot #{inspect ballot}")
        send(leader, {:p2b, self(), ballot})
        next(config, ballot, accepted)
    end
  end
end
