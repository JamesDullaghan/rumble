ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Rumble.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Rumble.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Rumble.Repo)

