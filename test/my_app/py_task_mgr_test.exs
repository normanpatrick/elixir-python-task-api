defmodule MyApp.PyTaskMgrTest do
  use MyApp.DataCase

  alias MyApp.PyTaskMgr

  describe "pytasks" do
    alias MyApp.PyTaskMgr.PyTask

    @valid_attrs %{description: "some description", is_active: true, name: "some name", status: "some status"}
    @update_attrs %{description: "some updated description", is_active: false, name: "some updated name", status: "some updated status"}
    @invalid_attrs %{description: nil, is_active: nil, name: nil, status: nil}

    def py_task_fixture(attrs \\ %{}) do
      {:ok, py_task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PyTaskMgr.create_py_task()

      py_task
    end

    test "list_pytasks/0 returns all pytasks" do
      py_task = py_task_fixture()
      assert PyTaskMgr.list_pytasks() == [py_task]
    end

    test "get_py_task!/1 returns the py_task with given id" do
      py_task = py_task_fixture()
      assert PyTaskMgr.get_py_task!(py_task.id) == py_task
    end

    test "create_py_task/1 with valid data creates a py_task" do
      assert {:ok, %PyTask{} = py_task} = PyTaskMgr.create_py_task(@valid_attrs)
      assert py_task.description == "some description"
      assert py_task.is_active == true
      assert py_task.name == "some name"
      assert py_task.status == "some status"
    end

    test "create_py_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PyTaskMgr.create_py_task(@invalid_attrs)
    end

    test "update_py_task/2 with valid data updates the py_task" do
      py_task = py_task_fixture()
      assert {:ok, %PyTask{} = py_task} = PyTaskMgr.update_py_task(py_task, @update_attrs)
      assert py_task.description == "some updated description"
      assert py_task.is_active == false
      assert py_task.name == "some updated name"
      assert py_task.status == "some updated status"
    end

    test "update_py_task/2 with invalid data returns error changeset" do
      py_task = py_task_fixture()
      assert {:error, %Ecto.Changeset{}} = PyTaskMgr.update_py_task(py_task, @invalid_attrs)
      assert py_task == PyTaskMgr.get_py_task!(py_task.id)
    end

    test "delete_py_task/1 deletes the py_task" do
      py_task = py_task_fixture()
      assert {:ok, %PyTask{}} = PyTaskMgr.delete_py_task(py_task)
      assert_raise Ecto.NoResultsError, fn -> PyTaskMgr.get_py_task!(py_task.id) end
    end

    test "change_py_task/1 returns a py_task changeset" do
      py_task = py_task_fixture()
      assert %Ecto.Changeset{} = PyTaskMgr.change_py_task(py_task)
    end
  end
end
