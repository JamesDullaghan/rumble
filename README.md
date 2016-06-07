# Rumble

To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Notes

* Implemented webpack to avoid learning YABT (yet another build tool)

# Elixir Notes

```elixir
  x(1,2) |> y(a,b,c)
  # Means

  newvar = x(1,2);
  y(newvar,a,b,c);
```

```erlang
capitalize_atom(X) ->
  list_to_atom(binary_to_list(capitalize_binary(list_to_binary(atom_to_list(X))))).
```

```erlang
  capitalize_atom(X) ->
    V1 = atom_to_list(X),
    V2 = list_to_binary(V1),
    V3 = capitalize_binary(V2),
    V4 = binary_to_list(V3),
    binary_to_atom(V4).
```
