defmodule Rumble.VideoViewTest do
  use Rumble.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    # create video stubs
    videos = [%Rumble.Video{id: 1, title: "dogs"},
              %Rumble.Video{id: 2, title: "cats"}]

    # Render the view as a string
    content = render_to_string(
      Rumble.VideoView,
      "index.html",
      conn: conn,
      videos: videos
    )

    # Check the view contains title
    assert String.contains?(content, "Listing videos")

    for video <- videos do
      # Check the view contains each video
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Rumble.Video.changeset(%Rumble.Video{})
    categories = [{"cats", 123}]

    content = render_to_string(
      Rumble.VideoView,
      "new.html",
      conn: conn,
      changeset: changeset,
      categories: categories
    )

    assert String.contains?(content, "New video")
  end
end
