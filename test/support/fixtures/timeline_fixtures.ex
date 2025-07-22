defmodule Schwabble.TimelineFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Schwabble.Timeline` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        body: "some body"
      })
      |> Schwabble.Timeline.create_post()

    post
  end
end
