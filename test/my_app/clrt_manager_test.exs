defmodule MyApp.CLRTManagerTest do
  use MyApp.DataCase

  alias MyApp.CLRTManager

  describe "slrtasks" do
    alias MyApp.CLRTManager.SLRTask

    @valid_attrs %{description: "some description", is_active: true, name: "some name"}
    @update_attrs %{description: "some updated description", is_active: false, name: "some updated name"}
    @invalid_attrs %{description: nil, is_active: nil, name: nil}

    def slr_task_fixture(attrs \\ %{}) do
      {:ok, slr_task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CLRTManager.create_slr_task()

      slr_task
    end

    test "list_slrtasks/0 returns all slrtasks" do
      slr_task = slr_task_fixture()
      assert CLRTManager.list_slrtasks() == [slr_task]
    end

    test "get_slr_task!/1 returns the slr_task with given id" do
      slr_task = slr_task_fixture()
      assert CLRTManager.get_slr_task!(slr_task.id) == slr_task
    end

    test "create_slr_task/1 with valid data creates a slr_task" do
      assert {:ok, %SLRTask{} = slr_task} = CLRTManager.create_slr_task(@valid_attrs)
      assert slr_task.description == "some description"
      assert slr_task.is_active == true
      assert slr_task.name == "some name"
    end

    test "create_slr_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CLRTManager.create_slr_task(@invalid_attrs)
    end

    test "update_slr_task/2 with valid data updates the slr_task" do
      slr_task = slr_task_fixture()
      assert {:ok, %SLRTask{} = slr_task} = CLRTManager.update_slr_task(slr_task, @update_attrs)
      assert slr_task.description == "some updated description"
      assert slr_task.is_active == false
      assert slr_task.name == "some updated name"
    end

    test "update_slr_task/2 with invalid data returns error changeset" do
      slr_task = slr_task_fixture()
      assert {:error, %Ecto.Changeset{}} = CLRTManager.update_slr_task(slr_task, @invalid_attrs)
      assert slr_task == CLRTManager.get_slr_task!(slr_task.id)
    end

    test "delete_slr_task/1 deletes the slr_task" do
      slr_task = slr_task_fixture()
      assert {:ok, %SLRTask{}} = CLRTManager.delete_slr_task(slr_task)
      assert_raise Ecto.NoResultsError, fn -> CLRTManager.get_slr_task!(slr_task.id) end
    end

    test "change_slr_task/1 returns a slr_task changeset" do
      slr_task = slr_task_fixture()
      assert %Ecto.Changeset{} = CLRTManager.change_slr_task(slr_task)
    end
  end
end
