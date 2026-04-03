defmodule CantorWeb.NotebookLive do
  use CantorWeb, :live_view

  alias Cantor.Cadence.{Parser, Compiler}

  def mount(_params, _session, socket) do
    cells = [
      %{
        id: "cell-1",
        type: :cadence,
        content: "kick(every: 4) |> visualize(:waveform)",
        output: nil,
        executing: false
      }
    ]

    {:ok,
     socket
     |> assign(:cells, cells)
     |> assign(:next_cell_id, 2)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-purple-50 to-indigo-50">
      <div class="max-w-6xl mx-auto px-4 py-8">
        <header class="mb-8 text-center">
          <h1 class="text-4xl font-bold bg-gradient-to-r from-purple-600 to-pink-600 bg-clip-text text-transparent">
            🎵 Cadence Notebook
          </h1>
          <p class="text-gray-600 mt-2">Literate Programming for AI Music</p>
        </header>

        <div class="space-y-6">
          <%= for cell <- @cells do %>
            <.cell cell={cell} />
          <% end %>
        </div>

        <div class="mt-8 text-center">
          <button
            phx-click="add_cell"
            class="px-6 py-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white rounded-lg font-semibold shadow-lg hover:from-purple-600 hover:to-pink-600 transition-all transform hover:scale-105"
          >
            ➕ Add Cadence Cell
          </button>
        </div>
      </div>
    </div>
    """
  end

  def cell(assigns) do
    ~H"""
    <div class="bg-white rounded-xl shadow-lg border border-gray-200 overflow-hidden">
      <div class="flex items-center justify-between px-4 py-2 bg-gray-50 border-b">
        <div class="flex items-center gap-2">
          <span class="text-xs font-mono text-gray-500"><%= @cell.id %></span>
          <span class="px-2 py-1 text-xs bg-purple-100 text-purple-700 rounded">Cadence</span>
        </div>
        
        <div class="flex gap-1">
          <button
            phx-click="execute_cell"
            phx-value-cell_id={@cell.id}
            disabled={@cell.executing}
            class="px-3 py-1 text-xs bg-green-500 text-white rounded hover:bg-green-600 disabled:bg-gray-400"
          >
            <%= if @cell.executing, do: "⏳ Running...", else: "▶️ Run" %>
          </button>
          
          <button
            phx-click="delete_cell"
            phx-value-cell_id={@cell.id}
            class="px-3 py-1 text-xs bg-red-500 text-white rounded hover:bg-red-600 focus-visible:ring-2 focus-visible:ring-red-400 focus:outline-none"
            aria-label="Delete cell"
            title="Delete cell"
          >
            🗑️
          </button>
        </div>
      </div>

      <div class="p-4">
        <textarea
          phx-blur="update_cell"
          phx-value-cell_id={@cell.id}
          name="content"
          aria-label="Cadence code"
          class="w-full h-24 p-3 font-mono text-sm bg-gray-900 text-green-400 rounded-lg border-2 border-gray-700 focus:border-purple-500 focus:outline-none resize-none"
          placeholder="Enter Cadence code..."
        ><%= @cell.content %></textarea>
      </div>

      <%= if @cell.output do %>
        <div class="border-t bg-gray-50 p-4">
          <.cell_output output={@cell.output} />
        </div>
      <% end %>
    </div>
    """
  end

  def cell_output(assigns) do
    ~H"""
    <div class="space-y-4" id="cell-output" phx-hook="CadenceAudio">
      <%= if @output.success do %>
        <div class="space-y-3">
          <div class="bg-white rounded-lg p-4 border">
            <h4 class="text-sm font-semibold text-gray-700 mb-2">🔗 JSON-LD Fingerprint</h4>
            <details class="group">
              <summary class="cursor-pointer text-sm text-blue-600 hover:text-blue-800">
                <%= @output.fingerprint_summary %>
                <span class="group-open:rotate-90 inline-block transition-transform ml-1">▶</span>
              </summary>
              <pre class="mt-2 p-3 bg-gray-100 rounded text-xs overflow-x-auto font-mono"><%= Jason.encode!(@output.fingerprint, pretty: true) %></pre>
            </details>
          </div>

          <div class="bg-gradient-to-r from-purple-100 to-pink-100 rounded-lg p-6">
            <div class="flex items-center justify-center gap-4 mb-4">
              <div class="text-4xl">🎵</div>
              <div class="flex gap-2">
                <button
                  phx-click="play_audio"
                  phx-value-fingerprint={Jason.encode!(@output.fingerprint)}
                  class="px-4 py-2 bg-green-500 text-white rounded-lg font-semibold shadow hover:bg-green-600 transition-all transform hover:scale-105"
                >
                  ▶️ Play
                </button>
                <button
                  phx-click="loop_audio"
                  phx-value-fingerprint={Jason.encode!(@output.fingerprint)}
                  class="px-4 py-2 bg-blue-500 text-white rounded-lg font-semibold shadow hover:bg-blue-600 transition-all transform hover:scale-105"
                >
                  🔄 Loop
                </button>
                <button
                  phx-click="stop_audio"
                  class="px-4 py-2 bg-red-500 text-white rounded-lg font-semibold shadow hover:bg-red-600 transition-all transform hover:scale-105"
                >
                  ⏹️ Stop
                </button>
              </div>
            </div>

            <div class="bg-gray-900 rounded-lg p-4 mt-4" id="consciousness-viz" phx-hook="ConsciousnessVisualizer">
              <canvas class="w-full h-64 rounded"></canvas>
            </div>

            <p class="text-xs text-gray-500 mt-2 text-center"><%= @output.viz_info || "Consciousness state visualization" %></p>
          </div>
        </div>
      <% else %>
        <div class="bg-red-50 border border-red-200 rounded-lg p-4">
          <div class="flex items-start gap-2">
            <span class="text-red-500 text-lg">❌</span>
            <div>
              <h4 class="text-sm font-semibold text-red-800">Error</h4>
              <pre class="text-xs text-red-700 mt-1 font-mono"><%= @output.error %></pre>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def handle_event("add_cell", _params, socket) do
    new_cell = %{
      id: "cell-#{socket.assigns.next_cell_id}",
      type: :cadence,
      content: "",
      output: nil,
      executing: false
    }

    {:noreply,
     socket
     |> update(:cells, &(&1 ++ [new_cell]))
     |> update(:next_cell_id, &(&1 + 1))}
  end

  def handle_event("delete_cell", %{"cell_id" => cell_id}, socket) do
    cells = Enum.reject(socket.assigns.cells, &(&1.id == cell_id))
    {:noreply, assign(socket, :cells, cells)}
  end

  def handle_event("update_cell", %{"cell_id" => cell_id, "content" => content}, socket) do
    cells = 
      Enum.map(socket.assigns.cells, fn cell ->
        if cell.id == cell_id do
          %{cell | content: content}
        else
          cell
        end
      end)

    {:noreply, assign(socket, :cells, cells)}
  end

  def handle_event("execute_cell", %{"cell_id" => cell_id}, socket) do
    cells = 
      Enum.map(socket.assigns.cells, fn cell ->
        if cell.id == cell_id do
          %{cell | executing: true, output: nil}
        else
          cell
        end
      end)

    socket = assign(socket, :cells, cells)
    cell = Enum.find(cells, &(&1.id == cell_id))
    execute_cadence_cell(cell, socket)
  end

  def handle_event("play_audio", %{"fingerprint" => fingerprint_json}, socket) do
    fingerprint = Jason.decode!(fingerprint_json)
    
    socket = push_event(socket, "play_audio", %{fingerprint: fingerprint, loop: false})
    {:noreply, socket}
  end

  def handle_event("loop_audio", %{"fingerprint" => fingerprint_json}, socket) do
    fingerprint = Jason.decode!(fingerprint_json)
    
    socket = push_event(socket, "play_audio", %{fingerprint: fingerprint, loop: true})
    {:noreply, socket}
  end

  def handle_event("stop_audio", _params, socket) do
    socket = push_event(socket, "stop_audio", %{})
    {:noreply, socket}
  end

  defp execute_cadence_cell(cell, socket) do
    case Parser.parse(cell.content) do
      {:ok, ast} ->
        fingerprint = Compiler.compile(ast, :fingerprint)
        
        output = %{
          success: true,
          fingerprint: fingerprint,
          fingerprint_summary: generate_fingerprint_summary(fingerprint),
          viz_info: extract_visualization_info(fingerprint)
        }

        update_cell_output(socket, cell.id, output)

      {:error, error} ->
        output = %{
          success: false,
          error: inspect(error)
        }

        update_cell_output(socket, cell.id, output)
    end
  end

  defp update_cell_output(socket, cell_id, output) do
    cells = 
      Enum.map(socket.assigns.cells, fn cell ->
        if cell.id == cell_id do
          %{cell | executing: false, output: output}
        else
          cell
        end
      end)

    {:noreply, assign(socket, :cells, cells)}
  end

  defp generate_fingerprint_summary(fingerprint) do
    graph = fingerprint["@graph"] || []
    count = length(graph)
    
    types = 
      graph
      |> Enum.map(&Map.get(&1, "@type", "Unknown"))
      |> Enum.frequencies()
      |> Enum.map(fn {type, count} -> "#{count}x #{type}" end)
      |> Enum.join(", ")

    "#{count} nodes: #{types}"
  end

  defp extract_visualization_info(fingerprint) do
    graph = fingerprint["@graph"] || []
    
    visualizers = 
      Enum.filter(graph, fn node ->
        get_in(node, ["@type"]) == "cadence:Visualizer" or
        get_in(node, ["processing", "@type"]) == "cadence:Visualizer"
      end)

    if visualizers != [] do
      "Contains #{length(visualizers)} visualizer(s)"
    else
      nil
    end
  end
end