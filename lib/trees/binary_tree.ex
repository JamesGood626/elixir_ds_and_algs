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

  def search(tree = %BinaryTree{root: %BinaryNode{value: value}}, search_value)
      when value === search_value do
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

  # Entrypoint for the :in_order traverse
  def traverse(:in_order, _tree = %{root: root}, func) when is_function(func) do
    traverse(:in_order, [root], root, func, :left_traverse)
  end

  # NOTE: 08/20/2019
  # Making progress on there... just a few pattern matches to handle exceptional cases,
  # but the recursion logic is in place to handle visiting the nodes in order w/out revisiting a node twice.
  # However, still not tail call optimized.
  @doc """
   Our base case, and we've built up the parent nodelist.
   Now we must only traverse the right subtrees of every node within that list,
   And ONLY traverse the left subtrees of nodes contained within the right subtree. (To prevent revisiting nodes.)
  """
  def traverse(:in_order, parent_nodes, node = %BinaryNode{left_child: nil}, func, :left_traverse)
      when is_function(func) do
    # Going to run with the assumption that the callback func will just do something along the lines
    # of just IO.puts the values in the tree, rather than transform the values. (but if it did transform values... then
    # I'd need to maintain the parent node so that I could reassign the node w/ the updated value as it's left/right_child).
    func.(node.value)

    Enum.map(parent_nodes, fn parent_node ->
      traverse(
        :in_order,
        [parent_node.right_child],
        parent_node.right_child,
        func,
        :left_traverse
      )

      func.(parent_node.left_child.value)
      func.(parent_node.value)
      func.(parent_node.right_child.value)
    end)
  end

  def traverse(:in_order, parent_nodes, node = %{left_child: left_child}, func, :left_traverse)
      when is_function(func) do
    traverse(:in_order, [node | parent_nodes], left_child, func, :left_traverse)
  end

  # def traverse(:post_order)

  ##############
  ## PRIVATES ##
  ##############
  defp insert_left(tree, nil, value, traversed),
    do: handle_new_node_insert(tree, traversed, value)

  defp insert_left(tree, node = %BinaryNode{value: node_value}, value, traversed) do
    traversed = List.flatten([traversed | [Access.key!(:left_child)]])

    compare_node_value(node_value, value, :traverse_left, :traverse_right)
    |> choose_traverse_direction(tree, node, value, traversed)
  end

  defp insert_right(tree, nil, value, traversed),
    do: handle_new_node_insert(tree, traversed, value)

  defp insert_right(tree, node = %BinaryNode{value: node_value}, value, traversed) do
    traversed = List.flatten([traversed | [Access.key!(:right_child)]])

    compare_node_value(node_value, value, :traverse_left, :traverse_right)
    |> choose_traverse_direction(tree, node, value, traversed)
  end

  defp create_new_node(value),
    do: fn _ -> {nil, %BinaryNode{value: value, left_child: nil, right_child: nil}} end

  defp handle_new_node_insert(tree, traversed, value) do
    {_, updated_tree} = get_and_update_in(tree, traversed, create_new_node(value))
    updated_tree
  end

  defp compare_node_value(node_value, value, left_case, right_case)
       when is_atom(left_case) and is_atom(right_case) do
    case node_value > value do
      true ->
        left_case

      false ->
        right_case
    end
  end

  defp compare_node_value(node_value, value, left_case, right_case)
       when is_function(left_case) and is_function(right_case) do
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

  def create_list() do
    list = [root: [value: 100, left_child: [value: 90, left_child: [], right_child: []], right_child: []]]
  end
end


