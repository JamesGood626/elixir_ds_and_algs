defmodule Graph do
  # defstruct node: %{value: nil}

  # Graph:
  # "A" -> "B" -> "C"
  # "A" -> "Z" -> "X"
  # "A" -> "J" -> "K"

  # [{"B", "C"}, {"A", "B"}, {"A", "Z"}, {"A", "J"}, {"J", "K"}, {"Z", "X"}, {"B", "C"}]

  def create(graph), do: graph

  def add_connection(graph, relation), do: [relation | graph]

  def remove_connection(graph, {lr, rr}) do
    graph
    |> Enum.filter(fn {x, y} ->
      if x !== lr and y !== rr do
        true
      end
    end)
  end

  def depth_first_search(graph) do
    # TODO
    # Where all children are visited first before the siblings are visited
  end

  @doc """
    Given the graph representation above..
    W/ "A" being the entrypoint; "A" has no siblings,
    so B, Z, and J are visited first as they're all siblings,
    and each of their children are prepended to the beggining of the visitation list

    graph = [
      {"B", "C"},
      {"A", "B"},
      {"A", "Z"},
      {"A", "J"},
      {"J", "K"},
      {"Z", "X"},
      {"B", "C"}
    ]

    breadth_first_search(graph, "A")

    From the puts and inspect from breadth_traversal
    visiting
    "J"
    visiting
    "Z"
    visiting
    "B"
    visiting
    "K"
    visiting
    "X"
    visiting
    "C"
    []
  """
  def breadth_first_search(graph, entrypoint) do
    connections = get_connections(graph, entrypoint)
    graph |> breadth_traversal(connections, MapSet.new())
  end

  defp breadth_traversal(graph, [], _visited), do: []

  defp breadth_traversal(graph, [x | xs], visited) do
    case MapSet.member?(visited, x) do
      true ->
        breadth_traversal(graph, xs, visited)

      false ->
        IO.puts("visiting")
        IO.inspect(x)
        # Having to run get_connections each time is bad O(n) time complexity for each recursion.
        # Would be better to have a function that creates a map of the connections just once, and then
        # pass that in to breadth traversel.
        breadth_traversal(
          graph,
          List.flatten([xs | get_connections(graph, x)]),
          MapSet.put(visited, x)
        )
    end
  end

  @doc """
  graph = [
    {"B", "C"},
    {"A", "B"},
    {"A", "Z"},
    {"A", "J"},
    {"J", "K"},
    {"Z", "X"},
    {"B", "C"}
  ]
  node = "A"

  get_connections(graph, node)
  Outputs -> ["J", "Z", "B"]
  """
  def get_connections(graph, node) do
    graph
    |> Enum.reduce([], fn {x, y}, acc ->
      if x === node do
        [y | acc]
      else
        acc
      end
    end)
  end

  # Could see this possibly helping a inorder to move
  # the case statement from breadth_traversal to here,
  # and then just pass in helper_fn which could handle
  # whatever logic the function that called it wants; in case
  # further recursion is needed etc.
  def detect_cycle(graph, visited, helper_fn) do
    # TODO
  end
end
