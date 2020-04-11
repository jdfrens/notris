defmodule Notris.PropertyTestGenerators do
  @moduledoc """
  Generators from property tests.
  """

  alias Notris.Piece
  alias PropCheck.BasicTypes

  @spec rotation :: any()
  def rotation do
    BasicTypes.choose(0, 3)
  end

  @spec shape :: Piece.shape()
  def shape do
    Enum.random(~w(i l o t z)a)
  end

  @spec color :: Piece.color()
  def color do
    Enum.random(~w(red green blue orange)a)
  end
end
