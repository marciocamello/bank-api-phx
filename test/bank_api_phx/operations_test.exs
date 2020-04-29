defmodule BankApiPhx.OperationsTest do
  use BankApiPhx.DataCase

  alias BankApiPhx.Operations

  describe "transactions" do
    alias BankApiPhx.Operations.Transaction

    @valid_attrs %{account_from: "some account_from", account_to: "some account_to", type: "some type", value: "some value"}
    @update_attrs %{account_from: "some updated account_from", account_to: "some updated account_to", type: "some updated type", value: "some updated value"}
    @invalid_attrs %{account_from: nil, account_to: nil, type: nil, value: nil}

    def transaction_fixture(attrs \\ %{}) do
      {:ok, transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Operations.create_transaction()

      transaction
    end

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Operations.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Operations.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      assert {:ok, %Transaction{} = transaction} = Operations.create_transaction(@valid_attrs)
      assert transaction.account_from == "some account_from"
      assert transaction.account_to == "some account_to"
      assert transaction.type == "some type"
      assert transaction.value == "some value"
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Operations.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{} = transaction} = Operations.update_transaction(transaction, @update_attrs)
      assert transaction.account_from == "some updated account_from"
      assert transaction.account_to == "some updated account_to"
      assert transaction.type == "some updated type"
      assert transaction.value == "some updated value"
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Operations.update_transaction(transaction, @invalid_attrs)
      assert transaction == Operations.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Operations.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Operations.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Operations.change_transaction(transaction)
    end
  end
end
