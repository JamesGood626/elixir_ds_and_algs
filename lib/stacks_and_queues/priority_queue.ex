defmodule PriorityQueue do
  defstruct [:length, :queue]
  # A user may create a priority queue of a specified length. (Check)
  # A user may add an item to the queue.
  # A user may add a item, with a specified priority level, to the queue.
  # A user may remove the first item from the queue.
  # A user may peek at the first item in the queue.
  # A user may clear the entire queue.

  # INVARIANTS
  # - The priority queue may never have more than the specified length in the queue.
  # - Items w/ a priority level will be added above lower level priorities, or below
  #   an item w/ a similar level of priority.

  def new(length) when length <= 3, do: {:error, %{message: "You must provide a length greater than 3."}}
  def new(length \\ 10) do
    %PriorityQueue{length: length, queue: []}
  end

  def add_item(p_queue, item) do
    case check_valid_add(p_queue) do
      true ->
        handle_add_item(p_queue, item)
      false ->
        {:error, %{message: "The queue is full! You can't add another item."}}
    end
  end


  defp check_valid_add(p_queue = %PriorityQueue{length: length, queue: queue}), do: length(queue) < length

  defp handle_add_item(p_queue = %{queue: []}, item), do: p_queue |> Map.put(:queue, [item] )

  defp handle_add_item(p_queue = %{queue: [head | []]}, item = %{priority_level: p_level}) do
    case head.priority_level >= p_level do
      true ->
        p_queue |> Map.put(:queue, [head | [item]])
      false ->
        p_queue |> Map.put(:queue, [item | [head]])
    end
  end

  defp handle_add_item(p_queue = %{queue: [head | tail]}, item) do
    p_queue |> Map.put(:queue, priority_level_insert([head], tail, item))
  end

  def peek(p_queue = %{queue: [head | _tail]}), do: head

  def remove(p_queue = %{queue: [head | tail]}) do
    {head, p_queue |> Map.put(:queue, tail)}
  end

  defp priority_level_insert([new_head | []], [old_head | []], item = %{priority_level: p_level}) do
    case old_head.priority_level < p_level do
      true ->
        [new_head | [item | [old_head]]]
      false ->
        [new_head | [old_head | [item]]]
    end
  end

  defp priority_level_insert([new_head | []], [old_head | old_tail], item = %{priority_level: p_level}) do
    case old_head.priority_level < p_level do
      true ->
        List.flatten([new_head | [item | [old_head | old_tail]]])
      false ->
        priority_level_insert(List.flatten([new_head | [old_head]]), old_tail, item)
    end
  end

  defp priority_level_insert([new_head | new_tail], [old_head | []], item = %{priority_level: p_level}) do
    case old_head.priority_level < p_level do
      true ->
        List.flatten([new_head | [new_tail | [item | [old_head]]]])
      false ->
        List.flatten([new_head | [new_tail | [old_head | [item]]]])
    end
  end

  defp priority_level_insert([new_head | new_tail], [old_head | old_tail], item = %{priority_level: p_level}) do
    case old_head.priority_level < p_level do
      true ->
        List.flatten([new_head | [new_tail | [item | [old_head | old_tail]]]])
      false ->
        priority_level_insert(List.flatten([new_head | [new_tail | [old_head]]]), old_tail, item)
    end
  end

  defp priority_level_insert([new_head | new_tail], [], item), do: List.flatten([new_head | [new_tail | [item]]])
end
