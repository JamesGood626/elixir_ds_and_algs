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
    case compare_node_value(root_value, value, :traverse_left, :traverse_right) do
      :traverse_left ->
        traversed = [Access.key!(:root), Access.key!(:left_child)]
        choose_traverse_direction(:traverse_left, tree, tree.root, value, traversed)
      :traverse_right ->
        traversed = [Access.key!(:root), Access.key!(:right_child)]
        choose_traverse_direction(:traverse_right, tree, tree.root, value, traversed)

    end
  end

  def search(nil, _search_value), do: "That value is not in the tree."
  def search(tree = %BinaryTree{root: %BinaryNode{value: value}}, search_value) when value === search_value do
    tree.root
  end

  def search(tree = %BinaryTree{root: %BinaryNode{value: value}}, search_value) do
    left_search = fn -> search(tree.root.left_child, search_value) end
    right_search = fn -> search(tree.root.right_child, search_value) end
    compare_node_value(value, search_value, left_search, right_search)
  end

  def search(node = %BinaryNode{value: value}, search_value) when value === search_value, do: node
  def search(node, search_value) do
    left_search = fn -> search(node.left_child, search_value) end
    right_search = fn -> search(node.right_child, search_value) end
    compare_node_value(node.value, search_value, left_search, right_search)
  end

  # You were thinking traversal here.
  # search(:left, tree.root, search_value)

  ##############
  ## PRIVATES ##
  ##############
  def insert_left(tree, nil, value, traversed), do: handle_new_node_insert(tree, traversed, value)
  def insert_left(tree, node = %BinaryNode{value: node_value}, value, traversed) do
    traversed = List.flatten([traversed | [Access.key!(:left_child)]])
    compare_node_value(node_value, value, :traverse_left, :traverse_right)
    |> choose_traverse_direction(tree, node, value, traversed)
  end

  def insert_right(tree, nil, value, traversed), do: handle_new_node_insert(tree, traversed, value)
  def insert_right(tree, node = %BinaryNode{value: node_value}, value, traversed) do
    traversed = List.flatten([traversed | [Access.key!(:right_child)]])
    compare_node_value(node_value, value, :traverse_left, :traverse_right)
    |> choose_traverse_direction(tree, node, value, traversed)
  end

  defp create_new_node(value), do: fn _ -> {nil, %BinaryNode{value: value, left_child: nil, right_child: nil}} end

  defp handle_new_node_insert(tree, traversed, value) do
    {_, updated_tree} = get_and_update_in(tree, traversed, create_new_node(value))
    updated_tree
  end

  defp compare_node_value(node_value, value, left_case, right_case) when is_atom(left_case) and is_atom(right_case) do
    case node_value > value do
      true ->
        left_case
      false ->
        right_case
    end
  end

  defp compare_node_value(node_value, value, left_case, right_case) do
    case node_value > value do
      true ->
        left_case.()
      false ->
        right_case.()
    end
  end

  defp choose_traverse_direction(:traverse_left, tree, node, value, traversed) do
    BinaryTree.insert_left(tree, node.left_child, value, traversed)
  end

  defp choose_traverse_direction(:traverse_right, tree, node, value, traversed) do
    BinaryTree.insert_right(tree, node.right_child, value, traversed)
  end
end
