defmodule Configuration do
  def node_id(config, node_type, node_num \\ "") do
    Map.merge(
      config,
      %{
        node_type: node_type,
        node_num: node_num,
        node_name: "#{node_type}#{node_num}",
        node_location: Util.node_string()
      }
    )
  end

  # -----------------------------------------------------------------------------

  def params(:default) do
    %{
      # max requests each client will make
      max_requests: 5_000,
      # time (ms) to sleep before sending new request
      client_sleep: 2,
      # time (ms) to stop sending further requests
      client_stop: 60_000,
      # :round_robin, :quorum or :broadcast
      client_send: :broadcast,
      # number of active bank accounts
      n_accounts: 100,
      # max amount moved between accounts
      max_amount: 1_000,
      # print transaction log summary every print_after msecs
      print_after: 1_000,
      crash_server: %{},
      # Use pinging to prevent livelock between leaders
      prevent_livelock: false,
      debug_level: 1
    }
  end

  # -----------------------------------------------------------------------------

  def params(:faster) do
    # settings for faster throughput
    config = params(:default)

    _config =
      Map.merge(
        config,
        %{
          # ADD YOUR OWN PARAMETERS HERE
        }
      )
  end

  # -----------------------------------------------------------------------------

  # Higher debug level means more messages
  # same as :default with debug_level: 1
  def params(:debug1) do
    Map.merge(params(:default), %{
      debug_level: 0,
      max_requests: 2,
      client_sleep: 500
    })
  end

  # Less chatty, with more requests
  def params(:debug2) do
    Map.merge(params(:default), %{
      debug_level: 1,
      max_requests: 4,
      client_sleep: 500
    })
  end

  # same as :default with debug_level: 3
  def params(:debug3) do
    Map.merge(params(:default), %{
      debug_level: 1,
      max_requests: 30,
      client_sleep: 10
    })
  end

  # -----------------------------------------------------------------------------
  # Benchmarking configs

  def params(:low_load) do
    Map.merge(params(:default), %{
      debug_level: 1,
      max_requests: 100,
      client_sleep: 10
    })
  end

  def params(:low_load_prevent_livelock) do
    Map.merge(params(:low_load), %{
      prevent_livelock: true
    })
  end

  def params(:low_load_prevent_livelock_crash_1_server) do
    Map.merge(params(:low_load), %{
      prevent_livelock: true,
      crash_server: %{1 => 500}
    })
  end

  def params(:high_load) do
    Map.merge(params(:default), %{
      max_requests: 1000,
      client_sleep: 5
    })
  end

  def params(:high_load_prevent_livelock) do
    Map.merge(params(:high_load), %{
      prevent_livelock: true
    })
  end

  def params(:high_load_prevent_livelock_crash_1_server) do
    Map.merge(params(:high_load), %{
      prevent_livelock: true,
      crash_server: %{1 => 5000}
    })
  end

  def params(:very_high_load) do
    Map.merge(params(:default), %{
      max_requests: 5000,
      client_sleep: 2
    })
  end

  def params(:very_high_load_prevent_livelock) do
    Map.merge(params(:very_high_load), %{
      prevent_livelock: true
    })
  end
end

# module ----------------------------------------------------------------
