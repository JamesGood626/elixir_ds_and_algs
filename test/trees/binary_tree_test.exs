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
end
