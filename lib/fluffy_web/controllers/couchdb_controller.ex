defmodule FluffyWeb.CouchDBController do
  alias Fluffy.CouchDBClient
  use FluffyWeb, :controller


  def show(conn, %{"id" => id}) do
    with  {:ok, value} <- CouchDBClient.get_document(id) |> IO.inspect() do
      conn
      |> put_status(:ok)
      |> json(%{message: "OK", value: value})
    else
      {:error, :unauthenticated} ->
        conn
        |> put_status(:unauthorized)
        # |> json(%{problem: "Unauthenticated", solution: "Permit unauthenticated localhost access to CouchDB?  Or figure out the permissions..."})
      {:error, :not_found} ->
        CouchDBClient.create(id, "Hello from CouchDB!")
        conn
        |> put_status(:ok)
        |> json (%{message: "OK", value: "NEW value created in CouchDB; refresh and I'll show it to you"})
    end
    # {:ok, parsed_doc} = Jiffy.decode(doc)
    # conn
    # |> put_status(:ok)
    # |> json(%{message: "OK", doc: doc})
  end
end
