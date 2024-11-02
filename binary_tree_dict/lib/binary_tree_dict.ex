defmodule BinaryTreeDict do
  @moduledoc """
  Implementation of a polymorphic dictionary using a binary search tree.
  Implements monoid properties and common functional operations.
  """

  defmodule Node do
    @moduledoc """
    A node in the binary search tree.
    """
    @type t(k, v) :: %__MODULE__{
      key: k,
      value: v,
      left: t(k, v) | nil,
      right: t(k, v) | nil
    }
    defstruct key: nil, value: nil, left: nil, right: nil
  end

  @typep node(k, v) :: Node.t(k, v) | nil
  @type t(k, v) :: %__MODULE__{root: node(k, v)}
  @type t :: %__MODULE__{root: node(any(), any())}
  defstruct root: nil

  @doc """
  Creates a new empty binary tree dictionary.

  ## Examples
      iex> BinaryTreeDict.new()
      %BinaryTreeDict{root: nil}
  """
  def new, do: %BinaryTreeDict{}

  @doc """
  Inserts a key-value pair into the dictionary.
  If the key already exists, updates the value.
  """
  def put(dict, key, value) do
    %BinaryTreeDict{dict | root: do_put(dict.root, key, value)}
  end

  defp do_put(nil, key, value) do
    %Node{key: key, value: value}
  end
  defp do_put(node, key, value) when key < node.key do
    %Node{node | left: do_put(node.left, key, value)}
  end
  defp do_put(node, key, value) when key > node.key do
    %Node{node | right: do_put(node.right, key, value)}
  end
  defp do_put(node, _key, value) do
    %Node{node | value: value}
  end

  @doc """
  Gets a value from the dictionary by key.
  Returns `{:ok, value}` if found, `:error` if not found.
  """
  def get(dict, key) do
    case do_get(dict.root, key) do
      nil -> :error
      value -> {:ok, value}
    end
  end

  defp do_get(nil, _key), do: nil
  defp do_get(node, key) when key < node.key, do: do_get(node.left, key)
  defp do_get(node, key) when key > node.key, do: do_get(node.right, key)
  defp do_get(node, _key), do: node.value

  @doc """
  Deletes a key-value pair from the dictionary.
  Returns the updated dictionary.
  """
  def delete(dict, key) do
    %BinaryTreeDict{dict | root: do_delete(dict.root, key)}
  end

  defp do_delete(nil, _key), do: nil
  defp do_delete(node, key) when key < node.key do
    %Node{node | left: do_delete(node.left, key)}
  end
  defp do_delete(node, key) when key > node.key do
    %Node{node | right: do_delete(node.right, key)}
  end
  defp do_delete(node, _key) do
    cond do
      node.left == nil -> node.right
      node.right == nil -> node.left
      true ->
        {min_key, min_value, new_right} = delete_min(node.right)
        %Node{key: min_key, value: min_value, left: node.left, right: new_right}
    end
  end

  # Find and remove the minimum node in a subtree
  defp delete_min(%Node{left: nil} = node) do
    {node.key, node.value, node.right}
  end
  defp delete_min(%Node{} = node) do
    {min_key, min_value, new_left} = delete_min(node.left)
    {min_key, min_value, %Node{node | left: new_left}}
  end

  @doc """
  Returns an empty dictionary (identity element for monoid)
  """
  def empty, do: new()

  @doc """
  Combines two dictionaries. For duplicate keys, values from the second dictionary take precedence.
  This is the monoid operation.
  """
  def combine(dict1, dict2) do
    # Simply insert all entries from dict2 into dict1
    to_list(dict2)
    |> Enum.reduce(dict1, fn {k, v}, acc -> put(acc, k, v) end)
  end

  @doc """
  Converts dictionary to list of key-value tuples
  """
  def to_list(dict) do
    do_inorder(dict.root, [])
  end

  defp do_inorder(nil, acc), do: acc
  defp do_inorder(node, acc) do
    do_inorder(node.left, [{node.key, node.value} | do_inorder(node.right, acc)])
  end

  @doc """
  Filters dictionary based on predicate function
  """
  def filter(dict, predicate) when is_function(predicate, 2) do
    to_list(dict)
    |> Enum.filter(fn {k, v} -> predicate.(k, v) end)
    |> Enum.reduce(empty(), fn {k, v}, acc -> put(acc, k, v) end)
  end

  @doc """
  Maps values in dictionary using provided function
  """
  def map(dict, fun) when is_function(fun, 2) do
    to_list(dict)
    |> Enum.map(fn {k, v} -> {k, fun.(k, v)} end)
    |> Enum.reduce(empty(), fn {k, v}, acc -> put(acc, k, v) end)
  end

  @doc """
  Performs left fold over dictionary elements in order
  """
  def fold_left(dict, acc, fun) when is_function(fun, 3) do
    to_list(dict)
    |> Enum.reduce(acc, fn {k, v}, acc -> fun.(k, v, acc) end)
  end

  @doc """
  Performs right fold over dictionary elements in reverse order
  """
  def fold_right(dict, acc, fun) when is_function(fun, 3) do
    to_list(dict)
    |> Enum.reverse()
    |> Enum.reduce(acc, fn {k, v}, acc -> fun.(k, v, acc) end)
  end
end
