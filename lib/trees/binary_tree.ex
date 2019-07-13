defmodule BinaryNode do
  defstruct [:value, :left_child, :right_child]

  def add_value(node, value), do: node |> Map.put(:value, value)
  def run_op(node = %{value: value}, func), do: node |> Map.put(:value, func.(value))
end

defmodule BinaryTree do
  defstruct [:root]

  def new(), do: %BinaryTree{root: %BinaryNode{value: nil, left_child: nil, right_child: nil}}

  def insert(tree = %BinaryTree{root: %BinaryNode{value: nil}}, value) do
    new_node = %BinaryNode{value: value, left_child: nil, right_child: nil}
    Map.put(tree, :root, new_node)
  end

  def insert(tree = %BinaryTree{root: %BinaryNode{left_child: nil}}, value) do
    new_node = %BinaryNode{value: value, left_child: nil, right_child: nil}
    updated_node = tree.root |> Map.put(:left_child, new_node)
    Map.put(tree, :root, updated_node)
  end

  def insert(tree = %BinaryTree{root: %BinaryNode{right_child: nil}}, value) do
    new_node = %BinaryNode{value: value, left_child: nil, right_child: nil}
    updated_node = tree.root |> Map.put(:right_child, new_node)
    Map.put(tree, :root, updated_node)
  end

  def insert(tree = %BinaryTree{root: %BinaryNode{value: root_value}}, value) do
    case compare_node_value(root_value, value) do
      :traverse_left ->
        traversed = [Access.key!(:root), Access.key!(:left_child)]
        choose_traverse_direction(:traverse_left, tree, tree.root, value, traversed)
      :traverse_right ->
        traversed = [Access.key!(:root), Access.key!(:right_child)]
        choose_traverse_direction(:traverse_right, tree, tree.root, value, traversed)

    end
  end

  def insert_left(tree, nil, value, traversed), do: handle_new_node_insert(tree, traversed, value)
  def insert_left(tree, node = %BinaryNode{value: node_value}, value, traversed) do
    traversed = List.flatten([traversed | [Access.key!(:left_child)]])
    compare_node_value(node_value, value) |> choose_traverse_direction(tree, node, value, traversed)
  end

  def insert_right(tree, nil, value, traversed), do: handle_new_node_insert(tree, traversed, value)
  def insert_right(tree, node = %BinaryNode{value: node_value}, value, traversed) do
    traversed = List.flatten([traversed | [Access.key!(:right_child)]])
    compare_node_value(node_value, value) |> choose_traverse_direction(tree, node, value, traversed)
  end

  defp create_new_node(value), do: fn _ -> {nil, %BinaryNode{value: value, left_child: nil, right_child: nil}} end

  defp handle_new_node_insert(tree, traversed, value) do
    {_, updated_tree} = get_and_update_in(tree, traversed, create_new_node(value))
    updated_tree
  end

  defp compare_node_value(node_value, value) do
    case value < node_value do
      true ->
        :traverse_left
      false ->
        :traverse_right
    end
  end

  defp choose_traverse_direction(:traverse_left, tree, node, value, traversed) do
    BinaryTree.insert_left(tree, node.left_child, value, traversed)
  end

  defp choose_traverse_direction(:traverse_right, tree, node, value, traversed) do
    BinaryTree.insert_right(tree, node.right_child, value, traversed)
  end

  # def search(tree, search_value)
end
