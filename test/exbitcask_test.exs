defmodule ExBitcaskTest do
  use ExUnit.Case
  alias ExBitcask.Database

  setup do
    on_exit(fn ->
      File.rm_rf("test.db")
    end)
  end

  test "Opens and closes the database" do
    db = ExBitcask.open("test.db")
    assert %Database{folder: "test.db", options: []} = db
    assert :ok == ExBitcask.close(db)
  end

  test "Denies writing to a read_only database" do
    db = ExBitcask.open("test.db")
    assert {:error, :read_only} = catch_throw(ExBitcask.put(db, "key", "val"))
    ExBitcask.close(db)
  end

  test "Writes and reads to a :read_write db" do
    db = ExBitcask.open("test.db", [:read_write])
    assert :not_found = ExBitcask.get(db, "key")
    assert :ok = ExBitcask.put(db, "key", "val")
    assert {:ok, "val"} = ExBitcask.get(db, "key")
    ExBitcask.close(db)
  end


end
