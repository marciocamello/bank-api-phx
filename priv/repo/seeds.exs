# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankApiPhx.Repo.insert!(%BankApiPhx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BankApiPhx.Repo
alias BankApiPhx.Accounts
alias BankApiPhx.Accounts.User

Repo.truncate(BankApiPhx.Accounts.Account)
Repo.truncate(BankApiPhx.Accounts.User)

user1 = %{
  email: "hermione@hogwarts.com",
  firstName: "Hermione",
  lastName: "Granger",
  phone: "00 0000 0000",
  password: "123123123"
}

{:ok, %User{} = account} =Accounts.create_user(user1)
Accounts.bind_account(account)

user2 = %{
  email: "harrypotter@hogwarts.com",
  firstName: "Harry",
  lastName: "Potter",
  phone: "00 0000 0000",
  password: "123123123"
}

{:ok, %User{} = account} = Accounts.create_user(user2)
Accounts.bind_account(account)

admin = %{
  email: "albusdumbledore@hogwarts.com",
  firstName: "Albus",
  lastName: "Dumbledore",
  phone: "00 0000 0000",
  password: "123123123",
  acl: "admin"
}

Accounts.create_user(admin)