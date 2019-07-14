defmodule BinaryTreeTest do
  use ExUnit.Case
  doctest BinaryTree
  alias BinaryTree
  alias BinaryNode

  @final_inserted_tree %BinaryTree{
    root: %BinaryNode{
      left_child: %BinaryNode{
        left_child:  %BinaryNode{
          left_child: %BinaryNode{
            left_child: nil,
            right_child: nil,
            value: 40
          },
          right_child: nil,
          value: 80
        },
        right_child: nil,
        value: 90
      },
      right_child: %BinaryNode{
        left_child: nil,
        right_child: %BinaryNode{
          left_child: nil,
          right_child: nil,
          value: 120
        },
        value: 110
      },
      value: 100
    }
  }

  @found_node %BinaryNode{
    left_child: nil,
    right_child: nil,
    value: 40
  }

  @no_results_for_search_response "That value is not in the tree."

  test "Creates a new binary tree" do
    assert BinaryTree.new() == %BinaryTree{root: %BinaryNode{value: nil, left_child: nil, right_child: nil}}
  end

  test "Can insert new values into the binary tree" do
    tree = BinaryTree.new()
    |> BinaryTree.insert(100)
    |> BinaryTree.insert(90)
    |> BinaryTree.insert(110)
    |> BinaryTree.insert(80)
    |> BinaryTree.insert(120)
    |> BinaryTree.insert(40)

    assert @final_inserted_tree == tree
  end

  test "Can search for a value in the binary tree" do
    tree = BinaryTree.new()
    |> BinaryTree.insert(100)
    |> BinaryTree.insert(90)
    |> BinaryTree.insert(110)
    |> BinaryTree.insert(80)
    |> BinaryTree.insert(120)
    |> BinaryTree.insert(40)

    assert @found_node == BinaryTree.search(tree, 40)
  end

  test "Can respond correctly when no value is found for a search" do
    tree = BinaryTree.new()

    assert @no_results_for_search_response == BinaryTree.search(tree, 1000)
  end
end
