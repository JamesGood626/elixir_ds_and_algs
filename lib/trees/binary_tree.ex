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

  # def traverse(:pre_order)

  def traverse(:in_order, tree, func) when is_atom(order) and is_function(func) do
    traverse(:in_order, [tree.root], tree.root, func, :left_traverse)
  end

  @doc """
    We build up the parent_nodes list, adding the most recently traversed node to the front,
    in order to facilitate unraveling back up the tree (and visiting the parent and right_childs)
    once we hit the leftmost node of the tree.
  """
  def traverse(:in_order, parent_nodes, node, func, :left_traverse) do
    case traverse(:in_order, [node | parent_nodes], node.left_child, func, :left_traverse) do
      :end_of_tree ->
        [head | tail] = parent_nodes
        traverse(:in_order, tail, head, func, :parent_node)
    end
  end

  def traverse(:in_order, parent_nodes, node = %BinaryNode{left_child: nil, right_child: nil}, func, :left_traverse) do
    # Going to run with the assumption that the callback func will just do something along the lines
    # of just IO.puts the values in the tree, rather than transform the values.
    func.(node.value)
    :end_of_tree
  end

  def traverse(:in_order, parent_nodes, node = %BinaryNode{left_child: nil, right_child: right_child}, func, :left_traverse) do
    # Going to run with the assumption that the callback func will just do something along the lines
    # of just IO.puts the values in the tree, rather than transform the values.
    func.(node.value)
    :end_of_tree
  end

  def traverse(:in_order, parent_nodes, node, func, :left_child) do

  end

  def traverse(:in_order, parent_nodes, node, func, :parent_node) do
    func.(node.value)
    :right_child
  end

  # TODO: Due to the duplication of these pattern matches... I think introducing guards
  # w/ names such as: can_traverse_left & can_traverse_right will be ideal...
  # AND creating a reusable helper function that runs the callback function and returns the atom
  # of the next operation to perform. This should help make these functions become a single line.
  # and facilitate readability as all of the rules can be grouped closer together.
  def traverse(:in_order, parent_nodes, node = %{left_child: nil, right_child: nil}, func, :right_child) do
    func.(node.value)
    :parent_node
  end

  def traverse(:in_order, parent_nodes, node = %{left_child: left_child, right_child: nil}, func, :right_child) do
    func.(node.value)
    :parent_node
  end

  def traverse(:in_order, parent_nodes, node = %{left_child: nil, right_child: right_child}, func, :right_child) do
    func.(node.value)
    :right_child
  end

  # def traverse(:post_order)

  ##############
  ## PRIVATES ##
  ##############
  defp insert_left(tree, nil, value, traversed), do: handle_new_node_insert(tree, traversed, value)
  defp insert_left(tree, node = %BinaryNode{value: node_value}, value, traversed) do
    traversed = List.flatten([traversed | [Access.key!(:left_child)]])
    compare_node_value(node_value, value, :traverse_left, :traverse_right)
    |> choose_traverse_direction(tree, node, value, traversed)
  end

  defp insert_right(tree, nil, value, traversed), do: handle_new_node_insert(tree, traversed, value)
  defp insert_right(tree, node = %BinaryNode{value: node_value}, value, traversed) do
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

  defp compare_node_value(node_value, value, left_case, right_case) when is_function(left_case) and is_function(right_case) do
    case node_value > value do
      true ->
        left_case.()
      false ->
        right_case.()
    end
  end

  defp choose_traverse_direction(:traverse_left, tree, node, value, traversed) do
    insert_left(tree, node.left_child, value, traversed)
  end

  defp choose_traverse_direction(:traverse_right, tree, node, value, traversed) do
    insert_right(tree, node.right_child, value, traversed)
  end
end
