defmodule PollerWeb.PollLiveTest do
  use PollerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Poller.PollsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_poll(_) do
    poll = poll_fixture()
    %{poll: poll}
  end

  describe "Index" do
    setup [:create_poll]

    test "lists all polls", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/polls")

      assert html =~ "Listing Polls"
    end

    test "saves new poll", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/polls")

      assert index_live |> element("a", "New Poll") |> render_click() =~
               "New Poll"

      assert_patch(index_live, ~p"/polls/new")

      assert index_live
             |> form("#poll-form", poll: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#poll-form", poll: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/polls")

      html = render(index_live)
      assert html =~ "Poll created successfully"
    end

    test "updates poll in listing", %{conn: conn, poll: poll} do
      {:ok, index_live, _html} = live(conn, ~p"/polls")

      assert index_live |> element("#polls-#{poll.id} a", "Edit") |> render_click() =~
               "Edit Poll"

      assert_patch(index_live, ~p"/polls/#{poll}/edit")

      assert index_live
             |> form("#poll-form", poll: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#poll-form", poll: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/polls")

      html = render(index_live)
      assert html =~ "Poll updated successfully"
    end

    test "deletes poll in listing", %{conn: conn, poll: poll} do
      {:ok, index_live, _html} = live(conn, ~p"/polls")

      assert index_live |> element("#polls-#{poll.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#polls-#{poll.id}")
    end
  end

  describe "Show" do
    setup [:create_poll]

    test "displays poll", %{conn: conn, poll: poll} do
      {:ok, _show_live, html} = live(conn, ~p"/polls/#{poll}")

      assert html =~ "Show Poll"
    end

    test "updates poll within modal", %{conn: conn, poll: poll} do
      {:ok, show_live, _html} = live(conn, ~p"/polls/#{poll}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Poll"

      assert_patch(show_live, ~p"/polls/#{poll}/show/edit")

      assert show_live
             |> form("#poll-form", poll: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#poll-form", poll: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/polls/#{poll}")

      html = render(show_live)
      assert html =~ "Poll updated successfully"
    end
  end
end
