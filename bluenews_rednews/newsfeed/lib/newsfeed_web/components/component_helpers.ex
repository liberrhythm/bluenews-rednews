# Code obtained with permission from @kimlindholm at https://github.com/kimlindholm/phoenix_component_folders

defmodule NewsfeedWeb.Components.ComponentHelpers do
  alias Phoenix.Naming
  alias NewsfeedWeb.Components

  @moduledoc """
  Conveniences for reusable UI components
  """

  def c(namespace, name \\ :index, assigns \\ []) do
    component(namespace, template(name), assigns)
  end

  def c(namespace, name, assigns, opts) do
    component(namespace, template(name), assigns, opts)
  end

  def component(namespace, template, assigns) do
    apply(
      view(namespace),
      :render,
      [template, assigns]
    )
  end

  def component(namespace, template, assigns, do: block) do
    apply(
      view(namespace),
      :render,
      [template, Keyword.merge(assigns, do: block)]
    )
  end

  def view_opts(namespace) do
    %{
      root: "lib/newsfeed_web/components/#{namespace}/templates",
      namespace: NewsfeedWeb,
      path: ""
    }
  end

  defp view(name) do
    module_name = Naming.camelize("#{name}") <> "View"
    Module.concat(Components, module_name)
  end

  defp template(name) when is_atom(name) do
    "#{name}.html"
  end
end
