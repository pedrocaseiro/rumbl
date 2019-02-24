defmodule Rumbl.Multimedia.Annotation do
  use Ecto.Schema
  import Ecto.Changeset


  schema "annotations" do
    field :at, :integer
    field :body, :string
    belongs_to :video, Rumbl.Multimedia.Video
    belongs_to :user, Rumbl.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(annotation, attrs) do
    annotation
    |> cast(attrs, [:body, :at])
    |> validate_required([:body, :at])
  end
end
