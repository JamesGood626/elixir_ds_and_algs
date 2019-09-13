defmodule BinaryTreeKeywordList do
  @initial_insert "INITIAL_INSERT"

  def new_bst(n) do
    [root: new_node(n)]
  end

  def new_node(n) do
    [value: n, left_child: [], right_child: []]
  end

  # Yeah, this wouldn't be tailrec...
  def add(bst, n) do
    List.foldl(bst, [], fn {key, node}, acc -> [{key, traverse(node, n)} | acc] end)
  end

  def traverse(node, n) do
    create_new_node = fn _ -> new_node(n) end
    case node do
      [value: value, left_child: [], right_child: []] ->
        insert(@initial_insert, node, value, n)
      [value: value, left_child: left_child, right_child: []] ->
        insert(@traversal_insert, node, value, n, create_new_node, continue_traversing(left_child, n))
      [value: value, left_child: [], right_child: right_child] ->
        insert(@traversal_insert, node, value, n, continue_traversing(right_child, n), create_new_node)
      [value: value, left_child: left_child, right_child: right_child] ->
        insert(@traversal_insert, node, value, n, continue_traversing(right_child, n), continue_traversing(left_child, n))
      _ ->
        "Not what you expected"
    end
  end

  def continue_traversing(node, n), do: fn _ -> traverse(node, n) end

  def insert(@initial_insert, node, value, n) do
    if value > n do
      Keyword.update(node, :left_child, [], fn _ -> new_node(n) end)
    else
      Keyword.update(node, :right_child, [], fn _ -> new_node(n) end)
    end
  end

  def insert(@traversal_insert, node, value, n, fun_one, fun_two) do
    if value < n do
      Keyword.update(node, :right_child, [], fun_one)
    else
      Keyword.update(node, :left_child, [], fun_two)
    end
  end
end

# foldl should help encode the traversal pattrn in a simpler way
# than my previous attempt which utilized multiple function clauses.
# List.foldl(list, [], fn x, acc -> [x | acc] end)
#   root: [
#     value: 100,
#     left_child: [value: 90, left_child: [], right_child: []],
#     right_child: []
#   ]
# ]

# List.foldl(list, [], fn {_, val}, acc -> [val | acc] end)
# [
#   [
#     value: 100,
#     left_child: [value: 90, left_child: [], right_child: []],
#     right_child: []
#   ]
# ]
