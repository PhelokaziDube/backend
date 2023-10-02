defmodule Fluffy.CouchDBClient do
  use GenServer

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    config = Application.get_env(:fluffy, :couchdb)
    url = "http://#{config[:server]}" |> IO.inspect
    with  {:ok, server} <- :couchdb.server_record(url, username: config[:user], password: config[:pass]) |> IO.inspect,
          {:ok, connection} <- :couchdb.database_record(server, config[:db_name]) |> IO.inspect do
      {:ok, connection}
    end
  end

  def get_document(id) do
    GenServer.call(__MODULE__, {:get_document, id})
  end

  def create(id, value) do
    GenServer.call(__MODULE__, {:create, id, value})
  end

  def handle_call({:get_document, id}, _from, connection) do
    {:reply, :couchdb_documents.get(connection, id), connection}
  end

  def handle_call({:create, id, value}, _from, connection) do
    {:reply, :couchdb_documents.save(connection, %{"_id" => id, "value" => value}), connection}
  end
end
