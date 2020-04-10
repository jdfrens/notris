defmodule Notris.PropCheckHelpers do
  @moduledoc """
  Helpers for property tests.
  """

  alias PropCheck.BasicTypes

  def rotation do
    BasicTypes.choose(0, 3)
  end

  def shape do
    Enum.random(~w(i l o t z)a)
  end

  def color do
    Enum.random(~w(red green blue orange)a)
  end
end
