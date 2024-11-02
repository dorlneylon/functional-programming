defmodule BinaryTreeDictTest do
  @moduledoc """
  Tests for the BinaryTreeDict module.
  """
  use ExUnit.Case
  use ExUnitProperties
  doctest BinaryTreeDict

  describe "new/0" do
    test "creates an empty dictionary" do
      assert %BinaryTreeDict{root: nil} = BinaryTreeDict.new()
    end
  end

  describe "put/3" do
    test "inserts a single key-value pair" do
      dict = BinaryTreeDict.new()
      dict = BinaryTreeDict.put(dict, 1, "one")

      assert {:ok, "one"} = BinaryTreeDict.get(dict, 1)
    end

    test "updates existing key with new value" do
      dict = BinaryTreeDict.new()
      dict = BinaryTreeDict.put(dict, 1, "one")
      dict = BinaryTreeDict.put(dict, 1, "ONE")

      assert {:ok, "ONE"} = BinaryTreeDict.get(dict, 1)
    end

    test "maintains binary search tree properties" do
      dict = BinaryTreeDict.new()
      dict = dict
             |> BinaryTreeDict.put(2, "two")
             |> BinaryTreeDict.put(1, "one")
             |> BinaryTreeDict.put(3, "three")

      # Verify the structure through get operations
      assert {:ok, "one"} = BinaryTreeDict.get(dict, 1)
      assert {:ok, "two"} = BinaryTreeDict.get(dict, 2)
      assert {:ok, "three"} = BinaryTreeDict.get(dict, 3)
    end
  end

  describe "get/2" do
    setup do
      dict = BinaryTreeDict.new()
             |> BinaryTreeDict.put(1, "one")
             |> BinaryTreeDict.put(2, "two")
             |> BinaryTreeDict.put(3, "three")

      {:ok, dict: dict}
    end

    test "returns {:ok, value} for existing key", %{dict: dict} do
      assert {:ok, "one"} = BinaryTreeDict.get(dict, 1)
      assert {:ok, "two"} = BinaryTreeDict.get(dict, 2)
      assert {:ok, "three"} = BinaryTreeDict.get(dict, 3)
    end

    test "returns :error for non-existing key", %{dict: dict} do
      assert :error = BinaryTreeDict.get(dict, 4)
      assert :error = BinaryTreeDict.get(dict, 0)
    end

    test "returns :error for empty dictionary" do
      assert :error = BinaryTreeDict.get(BinaryTreeDict.new(), 1)
    end
  end

  describe "delete/2" do
    setup do
      dict = BinaryTreeDict.new()
             |> BinaryTreeDict.put(5, "five")
             |> BinaryTreeDict.put(3, "three")
             |> BinaryTreeDict.put(7, "seven")
             |> BinaryTreeDict.put(2, "two")
             |> BinaryTreeDict.put(4, "four")
             |> BinaryTreeDict.put(6, "six")
             |> BinaryTreeDict.put(8, "eight")

      {:ok, dict: dict}
    end

    test "deletes leaf node", %{dict: dict} do
      dict = BinaryTreeDict.delete(dict, 2)
      assert :error = BinaryTreeDict.get(dict, 2)
      assert {:ok, "three"} = BinaryTreeDict.get(dict, 3)
    end

    test "deletes node with one child", %{dict: dict} do
      # First delete 2 to ensure 3 has only one child (4)
      dict = BinaryTreeDict.delete(dict, 2)
      # Then delete 3
      dict = BinaryTreeDict.delete(dict, 3)

      assert :error = BinaryTreeDict.get(dict, 3)
      assert {:ok, "four"} = BinaryTreeDict.get(dict, 4)
    end

    test "deletes node with two children", %{dict: dict} do
      dict = BinaryTreeDict.delete(dict, 5)

      assert :error = BinaryTreeDict.get(dict, 5)
      # Verify structure remains valid
      assert {:ok, "three"} = BinaryTreeDict.get(dict, 3)
      assert {:ok, "seven"} = BinaryTreeDict.get(dict, 7)
    end

    test "deleting non-existing key returns unchanged dictionary", %{dict: dict} do
      new_dict = BinaryTreeDict.delete(dict, 99)

      assert {:ok, "five"} = BinaryTreeDict.get(new_dict, 5)
      assert {:ok, "three"} = BinaryTreeDict.get(new_dict, 3)
      assert {:ok, "seven"} = BinaryTreeDict.get(new_dict, 7)
    end

    test "deleting from empty dictionary returns empty dictionary" do
      dict = BinaryTreeDict.new()
      assert %BinaryTreeDict{root: nil} = BinaryTreeDict.delete(dict, 1)
    end
  end

  describe "complex operations" do
    test "handles a sequence of operations" do
      dict = BinaryTreeDict.new()
             |> BinaryTreeDict.put(5, "five")
             |> BinaryTreeDict.put(3, "three")
             |> BinaryTreeDict.put(7, "seven")
             |> BinaryTreeDict.delete(3)
             |> BinaryTreeDict.put(3, "THREE")
             |> BinaryTreeDict.delete(5)
             |> BinaryTreeDict.put(4, "four")

      assert {:ok, "THREE"} = BinaryTreeDict.get(dict, 3)
      assert {:ok, "four"} = BinaryTreeDict.get(dict, 4)
      assert {:ok, "seven"} = BinaryTreeDict.get(dict, 7)
      assert :error = BinaryTreeDict.get(dict, 5)
    end
  end

  describe "monoid properties" do
    property "left identity" do
      check all kvs <- list_of({integer(), integer()}, min_length: 1, max_length: 5) do
        dict = Enum.reduce(kvs, BinaryTreeDict.new(), fn {k, v}, acc ->
          BinaryTreeDict.put(acc, k, v)
        end)

        assert BinaryTreeDict.to_list(BinaryTreeDict.combine(BinaryTreeDict.empty(), dict)) ==
               BinaryTreeDict.to_list(dict)
      end
    end

    property "right identity" do
      check all kvs <- list_of({integer(), integer()}, min_length: 1, max_length: 5) do
        dict = Enum.reduce(kvs, BinaryTreeDict.new(), fn {k, v}, acc ->
          BinaryTreeDict.put(acc, k, v)
        end)

        assert BinaryTreeDict.to_list(BinaryTreeDict.combine(dict, BinaryTreeDict.empty())) ==
               BinaryTreeDict.to_list(dict)
      end
    end

    property "associativity" do
      check all kvs1 <- list_of({integer(), integer()}, min_length: 1, max_length: 3),
                kvs2 <- list_of({integer(), integer()}, min_length: 1, max_length: 3),
                kvs3 <- list_of({integer(), integer()}, min_length: 1, max_length: 3) do
        dict1 = Enum.reduce(kvs1, BinaryTreeDict.new(), fn {k, v}, acc ->
          BinaryTreeDict.put(acc, k, v)
        end)
        dict2 = Enum.reduce(kvs2, BinaryTreeDict.new(), fn {k, v}, acc ->
          BinaryTreeDict.put(acc, k, v)
        end)
        dict3 = Enum.reduce(kvs3, BinaryTreeDict.new(), fn {k, v}, acc ->
          BinaryTreeDict.put(acc, k, v)
        end)

        combined1 = BinaryTreeDict.combine(BinaryTreeDict.combine(dict1, dict2), dict3)
        combined2 = BinaryTreeDict.combine(dict1, BinaryTreeDict.combine(dict2, dict3))

        assert BinaryTreeDict.to_list(combined1) == BinaryTreeDict.to_list(combined2)
      end
    end
  end

  describe "functional operations" do
    test "filter" do
      dict = BinaryTreeDict.new()
             |> BinaryTreeDict.put(1, "odd")
             |> BinaryTreeDict.put(2, "even")
             |> BinaryTreeDict.put(3, "odd")

      even_dict = BinaryTreeDict.filter(dict, fn k, _v -> rem(k, 2) == 0 end)
      assert {:ok, "even"} = BinaryTreeDict.get(even_dict, 2)
      assert :error = BinaryTreeDict.get(even_dict, 1)
    end

    test "map" do
      dict = BinaryTreeDict.new()
             |> BinaryTreeDict.put(1, 1)
             |> BinaryTreeDict.put(2, 2)

      doubled = BinaryTreeDict.map(dict, fn _k, v -> v * 2 end)
      assert {:ok, 2} = BinaryTreeDict.get(doubled, 1)
      assert {:ok, 4} = BinaryTreeDict.get(doubled, 2)
    end

    test "fold_left" do
      dict = BinaryTreeDict.new()
             |> BinaryTreeDict.put(1, 1)
             |> BinaryTreeDict.put(2, 2)
             |> BinaryTreeDict.put(3, 3)

      sum = BinaryTreeDict.fold_left(dict, 0, fn _k, v, acc -> acc + v end)
      assert sum == 6
    end

    test "fold_right" do
      dict = BinaryTreeDict.new()
             |> BinaryTreeDict.put(1, 1)
             |> BinaryTreeDict.put(2, 2)
             |> BinaryTreeDict.put(3, 3)

      sum = BinaryTreeDict.fold_right(dict, 0, fn _k, v, acc -> acc + v end)
      assert sum == 6
    end
  end
end
