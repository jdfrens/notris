defmodule Notris.PropertyTestGenerators do
  @moduledoc """
  Generators from property tests.

  NOTE: PropCheck bleeds out an opaque `:proper_types.type()` which makes it difficult to type check this well.  Many
  entries in `.dialyzer_ignore.exs` are for this file.
  """

  use PropCheck

  alias Notris.Piece

  @doc """
  Generates 0, 1, 2, or 3, the number of right rotations to apply.
  """
  @spec rotation :: :proper_types.type()
  def rotation do
    choose(0, 3)
  end

  @doc """
  Generates a valid shape atom.
  """
  @spec shape :: :proper_types.type()
  def shape do
    oneof(~w(i l ml o s t z)a)
  end

  @doc """
  Generates a valid color.
  """
  @spec color :: :proper_types.type()
  def color do
    oneof(~w(red green blue orange)a)
  end

  @doc """
  Generates a `Notris.Piece.t()`.
  """
  @spec piece :: :proper_types.type()
  def piece do
    let {shape, rotate, color} <- {shape(), rotation(), color()} do
      Piece.new(shape, rotate, color)
    end
  end
end
