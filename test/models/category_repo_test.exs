defmodule Rumbl.CategoryRepoTest do
  use Rumbl.ModelCase

  alias Rumbl.Category

  test "alphabetical/1 orders by name" do
    Repo.insert!(%Category{name: "c"})
    Repo.insert!(%Category{name: "a"})
    Repo.insert!(%Category{name: "b"})

    query = Category |> Category.alphabetized
    category_names = Repo.all from c in query, select: c.name

    assert category_names == ~w(a b c)
  end
end
