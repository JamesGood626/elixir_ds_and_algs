defmodule PriorityQueueTest do
  use ExUnit.Case
  doctest PriorityQueue

  @food %{priority_level: 5, item: "Cook Food"}
  @guitar %{priority_level: 4, item: "Play Guitar"}
  @workout %{priority_level: 3, item: "Workout"}
  @clothes %{priority_level: 0, item: "Buy Clothes"}
  @transit %{priority_level: 0, item: "Take Subway"}

  @no_level_queue [
    @transit,
    @clothes
  ]

  @p_level_queue [
    @food,
    @guitar,
    @workout,
    @clothes,
    @transit
  ]

  describe "creates a priority queue" do
    test "with the default length" do
      assert PriorityQueue.new() == %PriorityQueue{length: 10, queue: []}
    end

    test "with a user provided length" do
      assert PriorityQueue.new(20) == %PriorityQueue{length: 20, queue: []}
    end

    test "unless the length is not greater than 3, then it fails" do
      assert PriorityQueue.new(3) == {:error, %{message: "You must provide a length greater than 3."}}
    end
  end

  describe "adds to the priority queue" do
    test "new items without a specified priority level" do
      p_queue = PriorityQueue.new()
      |> PriorityQueue.add_item(@transit)

      assert PriorityQueue.add_item(p_queue, @clothes) == %PriorityQueue{length: 10, queue: @no_level_queue}
    end

    test "new items with a specified priority level are added to their proper place" do
      p_queue = PriorityQueue.new()
      |> PriorityQueue.add_item(@clothes)
      |> PriorityQueue.add_item(@food)
      |> PriorityQueue.add_item(@workout)
      |> PriorityQueue.add_item(@guitar)

      assert PriorityQueue.add_item(p_queue, @transit) == %PriorityQueue{length: 10, queue: @p_level_queue}
    end

    test "unless the queue is full, then it will display an error message" do
      p_queue = PriorityQueue.new(4)
      |> PriorityQueue.add_item(@clothes)
      |> PriorityQueue.add_item(@food)
      |> PriorityQueue.add_item(@workout)
      |> PriorityQueue.add_item(@guitar)

      assert PriorityQueue.add_item(p_queue, @transit) == {:error, %{message: "The queue is full! You can't add another item."}}
    end
  end

  describe "peeks and removes from the queue" do
    test "peeks successfully" do
      p_queue = PriorityQueue.new()
      |> PriorityQueue.add_item(@transit)
      |> PriorityQueue.add_item(@clothes)

      assert PriorityQueue.peek(p_queue) == @transit
    end

    test "removes successfully" do
      p_queue = PriorityQueue.new()
      |> PriorityQueue.add_item(@transit)
      |> PriorityQueue.add_item(@clothes)

      {item, p_queue} = PriorityQueue.remove(p_queue)

      assert item == @transit
      assert p_queue == %PriorityQueue{length: 10, queue: [@clothes]}
    end
  end
end
