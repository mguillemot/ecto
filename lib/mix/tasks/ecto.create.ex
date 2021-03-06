defmodule Mix.Tasks.Ecto.Create do
  use Mix.Task
  import Mix.Ecto

  @shortdoc "Create the storage for the repo"

  @moduledoc """
  Create the storage for the repository.

  ## Examples

      mix ecto.create
      mix ecto.create -r Custom.Repo

  ## Command line options

    * `-r`, `--repo` - the repo to create (defaults to `YourApp.Repo`)
    * `--no-start` - do not start applications
    * `--quiet` - do no log output

  """

  @doc false
  def run(args) do
    Mix.Task.run "app.start", args

    repo = parse_repo(args)
    ensure_repo(repo)
    ensure_implements(repo.adapter, Ecto.Adapter.Storage, "to create storage for #{inspect repo}")

    {opts, _, _} = OptionParser.parse args, switches: [quiet: :boolean]

    case Ecto.Storage.up(repo) do
      :ok ->
        unless opts[:quiet] do
          Mix.shell.info "The database for #{inspect repo} has been created."
        end
      {:error, :already_up} ->
        unless opts[:quiet] do
          Mix.shell.info "The database for #{inspect repo} has already been created."
        end
      {:error, term} ->
        Mix.raise "The database for #{inspect repo} couldn't be created, reason given: #{term}."
    end
  end
end
