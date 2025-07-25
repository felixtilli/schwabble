defmodule SchwabbleWeb.PostLive.Form do
  use SchwabbleWeb, :live_view

  alias Schwabble.Timeline
  alias Schwabble.Timeline.Post

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage post records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="post-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:body]} type="text" label="Body" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Post</.button>
          <.button navigate={return_path(@return_to, @post)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    post = Timeline.get_post!(id)

    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, post)
    |> assign(:form, to_form(Timeline.change_post(post)))
  end

  defp apply_action(socket, :new, _params) do
    post = %Post{}

    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, post)
    |> assign(:form, to_form(Timeline.change_post(post)))
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset = Timeline.change_post(socket.assigns.post, post_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.live_action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Timeline.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, post))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_post(socket, :new, post_params) do
    case Timeline.create_post(post_params) do
      {:ok, post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, post))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _post), do: ~p"/posts"
  defp return_path("show", post), do: ~p"/posts/#{post}"
end
