defmodule Schwabble.Timeline.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
