defmodule FluffyWeb.CouchdbController do
  use FluffyWeb, :controller

  def show(conn, %{"id" => id}) do
    doc = FluffyWeb.CouchDBController.get_document(id)
    case Jiffy.decode(doc) do
      {:ok, parsed_doc} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "OK", doc: doc})
      end
    end
end
