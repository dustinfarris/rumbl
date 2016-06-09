defmodule Rumbl.UserTest do
  use Rumbl.ModelCase, async: true

  alias Rumbl.User

  @valid_attrs %{name: "A User", username: "eva", password: "secret"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)

    refute changeset.valid?
  end

  test "changeset does not accept long username" do
    attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))

    with errors = errors_on(%User{}, attrs) do
      assert {:username, {"should be at most %{count} character(s)", [count: 20]}} in errors
    end
  end

  test "registration_changeset password must be at least 6 chars long" do
    attrs = Map.put(@valid_attrs, :password, "123")

    changeset = User.registration_changeset(%User{}, attrs)

    with errors = changeset.errors do
      assert {:password, {"should be at least %{count} character(s)", count: 6}} in errors
    end
  end

  test "registration_changeset with valid attributes hashes password" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)

    %{password: password, password_hash: password_hash} = changeset.changes

    assert changeset.valid?
    assert password_hash
    assert Comeonin.Bcrypt.checkpw(password, password_hash)
  end
end
