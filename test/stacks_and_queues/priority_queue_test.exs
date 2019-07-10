defmodule PriorityQueueTest do
  use ExUnit.Case
  doctest PriorityQueue

  @no_level_queue [
    %{priority_level: 0, item: "Play Guitar"},
    %{priority_level: 0, item: "Workout"}
  ]

  @p_level_queue [
    %{priority_level: 4, item: "Play Guitar"},
    %{priority_level: 3, item: "Workout"},
    %{priority_level: 2, item: "Cook Food"},
    %{priority_level: 0, item: "Buy Clothes"}
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
      |> PriorityQueue.add_item(%{priority_level: 0, item: "Play Guitar"})

      assert PriorityQueue.add_item(p_queue, %{priority_level: 0, item: "Workout"}) == %PriorityQueue{length: 10, queue: @no_level_queue}
    end

    test "new items with a specified priority level are added to their proper place" do
      p_queue = PriorityQueue.new()
      |> PriorityQueue.add_item(%{priority_level: 4, item: "Play Guitar"})
      |> PriorityQueue.add_item(%{priority_level: 2, item: "Cook Food"})
      |> PriorityQueue.add_item(%{priority_level: 0, item: "Buy Clothes"})

      assert PriorityQueue.add_item(p_queue, %{priority_level: 3, item: "Workout"}) == %PriorityQueue{length: 10, queue: @p_level_queue}
    end
  end
end
