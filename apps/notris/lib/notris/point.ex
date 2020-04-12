defmodule Notris.Point do
  @moduledoc """
  Definitions for points.
  """

  @type piece_point :: {1..4, 1..4}
  @type game_point :: {pos_integer(), pos_integer()}
end
