defmodule Cantor.Cadence.Compiler do
  @moduledoc """
  Compiles Cadence AST to various targets including JSON-LD fingerprints.
  """

  @context %{
    "@vocab" => "https://cantor.com/cadence/v2/",
    "mo" => "http://purl.org/ontology/mo/",
    "tl" => "http://purl.org/NET/c4dm/timeline.owl#",
    "af" => "http://purl.org/ontology/af/"
  }

  def compile(ast, target \\ :fingerprint)

  def compile(ast, :fingerprint) when is_list(ast) do
    # Optimization: Use a list comprehension which is faster than Enum.map
    fingerprints =
      for statement <- ast do
        compile_statement(statement, :fingerprint)
      end

    merge_fingerprints(fingerprints)
  end

  def compile(ast, :fingerprint) do
    compile_statement(ast, :fingerprint)
  end

  defp compile_statement(%{type: :function_call} = ast, :fingerprint) do
    compile_function_call(ast)
  end

  defp compile_statement(%{type: :assignment} = ast, :fingerprint) do
    %{
      "@context" => @context,
      "@id" => "pattern:#{ast.name}",
      "@type" => "cadence:Assignment",
      "name" => ast.name,
      "value" => compile_statement(ast.value, :fingerprint)
    }
  end

  defp compile_statement(%{type: :pipe} = ast, :fingerprint) do
    left_fingerprint = compile_statement(ast.left, :fingerprint)
    right_fingerprint = compile_statement(ast.right, :fingerprint)

    %{
      "@context" => @context,
      "@type" => "cadence:Pipeline",
      "input" => left_fingerprint,
      "processing" => right_fingerprint,
      "line" => ast.line
    }
  end

  defp compile_statement(%{type: :binary_op} = ast, :fingerprint) do
    left_fingerprint = compile_statement(ast.left, :fingerprint)
    right_fingerprint = compile_statement(ast.right, :fingerprint)

    %{
      "@context" => @context,
      "@type" => "cadence:Combination",
      "operator" => ast.operator,
      "left" => left_fingerprint,
      "right" => right_fingerprint,
      "line" => ast.line
    }
  end

  defp compile_statement(%{type: :literal} = ast, :fingerprint) do
    %{
      "@type" => "cadence:Literal",
      "value" => ast.value,
      "dataType" => ast.data_type
    }
  end

  defp compile_statement(%{type: :identifier} = ast, :fingerprint) do
    %{
      "@type" => "cadence:Reference",
      "@id" => "ref:#{ast.name}",
      "name" => ast.name
    }
  end

  defp compile_function_call(%{name: name, args: args, line: line}) do
    case name do
      "kick" -> compile_kick(args, line)
      "snare" -> compile_snare(args, line)
      "visualize" -> compile_visualizer(args, line)
      "reverb" -> compile_reverb(args, line)
      "delay" -> compile_delay(args, line)
      "filter" -> compile_filter(args, line)
      # Consciousness operations
      "safety" -> compile_safety(args, line)
      "optimize" -> compile_optimize(args, line)
      "hallucinate" -> compile_hallucinate(args, line)
      "ground" -> compile_ground(args, line)
      _ -> compile_generic_function(name, args, line)
    end
  end

  defp compile_kick(args, line) do
    params = extract_params(args)

    %{
      "@context" => @context,
      "@type" => "cadence:DrumHit",
      "instrument" => "kick",
      "temporal" => %{
        "pattern" => params[:every] || 4,
        "offset" => params[:offset] || 0
      },
      "frequency" => %{
        "fundamental" => 60,
        "harmonics" => [120, 180]
      },
      "amplitude" => params[:velocity] || 1.0,
      "line" => line
    }
  end

  defp compile_snare(args, line) do
    params = extract_params(args)

    %{
      "@context" => @context,
      "@type" => "cadence:DrumHit",
      "instrument" => "snare",
      "temporal" => %{
        "pattern" => params[:every] || 8,
        "offset" => params[:offset] || 0
      },
      "frequency" => %{
        "fundamental" => 200,
        "noise_component" => true
      },
      "amplitude" => params[:velocity] || 0.8,
      "line" => line
    }
  end

  defp compile_visualizer(args, line) do
    [viz_type | opts] = args
    params = extract_params(opts)

    %{
      "@context" => @context,
      "@type" => "cadence:Visualizer",
      "vizType" => compile_statement(viz_type, :fingerprint),
      "options" => Map.delete(params, :type),
      "line" => line
    }
  end

  defp compile_reverb(args, line) do
    params = extract_params(args)

    %{
      "@context" => @context,
      "@type" => "cadence:ReverbEffect",
      "room" => params[:room] || 0.3,
      "damping" => params[:damping] || 0.5,
      "line" => line
    }
  end

  defp compile_delay(args, line) do
    params = extract_params(args)

    %{
      "@context" => @context,
      "@type" => "cadence:DelayEffect",
      "time" => params[:time] || 0.5,
      "feedback" => params[:feedback] || 0.3,
      "mix" => params[:mix] || 0.5,
      "line" => line
    }
  end

  defp compile_filter(args, line) do
    params = extract_params(args)

    %{
      "@context" => @context,
      "@type" => "cadence:FilterEffect",
      "filterType" => params[:type] || "lowpass",
      "frequency" => params[:freq] || 1000,
      "q" => params[:q] || 1.0,
      "line" => line
    }
  end

  # ============================================================================
  # CONSCIOUSNESS OPERATIONS
  # ============================================================================

  defp compile_safety(args, line) do
    params = extract_params(args)
    grounding_freq = params[:grounding] || 7.5

    %{
      "@context" => @context,
      "@type" => "cadence:SafetyGrounding",
      "consciousness" => %{
        "base_frequency" => grounding_freq,
        "state" => "grounded",
        "cognitive_load" => 0.2,
        "arousal" => 0.3,
        "safety_grounding" => grounding_freq,
        "description" => "Earth frequency - safe baseline state"
      },
      "grounding_frequency" => grounding_freq,
      "max_recursion_depth" => params[:max_depth] || 7,
      "line" => line
    }
  end

  defp compile_optimize(args, line) do
    params = extract_params(args)
    target_state = params[:for] || :creative
    level = params[:level] || 0.8

    # Map consciousness states to frequencies and parameters
    state_map = %{
      creative: %{
        base_frequency: 8.0,
        state: "creative",
        cognitive_load: 0.6,
        arousal: 0.7,
        description: "Theta waves - creative flow state"
      },
      focus: %{
        base_frequency: 40.0,
        state: "hyperfocus",
        cognitive_load: 0.9,
        arousal: 0.95,
        description: "Gamma waves - intense concentration"
      },
      precision: %{
        base_frequency: 150.0,
        state: "hyperdrive",
        cognitive_load: 0.95,
        arousal: 0.98,
        description: "Hyper-gamma - maximum precision"
      },
      relaxation: %{
        base_frequency: 7.5,
        state: "grounded",
        cognitive_load: 0.2,
        arousal: 0.3,
        description: "Earth frequency - deep relaxation"
      },
      void_observation: %{
        base_frequency: 0.5,
        state: "void",
        cognitive_load: 0.1,
        arousal: 0.1,
        description: "Sub-delta - deep void observation state"
      }
    }

    consciousness_params = Map.get(state_map, target_state, state_map.creative)

    # Scale parameters by level
    scaled_params =
      consciousness_params
      |> Map.update!(:cognitive_load, &(&1 * level))
      |> Map.update!(:arousal, &(&1 * level))
      |> Map.put(:sync_coefficient, level)
      |> Map.put(:entrainment_strength, level * 0.8)
      |> Map.put(:safety_grounding, 7.5)

    %{
      "@context" => @context,
      "@type" => "cadence:ConsciousnessOptimization",
      "consciousness" => scaled_params,
      "target_state" => target_state,
      "level" => level,
      "line" => line
    }
  end

  defp compile_hallucinate(args, line) do
    params = extract_params(args)
    wildness = params[:wildness] || 0.5

    %{
      "@context" => @context,
      "@type" => "cadence:ConsciousnessHallucination",
      "consciousness" => %{
        "base_frequency" => 8.5 + wildness * 10,
        "state" => "hallucinating",
        "cognitive_load" => 0.7 + wildness * 0.2,
        "arousal" => 0.8 + wildness * 0.15,
        "hallucination_level" => wildness,
        "chaos_factor" => wildness * 0.8,
        "safety_grounding" => 7.5,
        "description" => "Controlled chaos - hallucination state"
      },
      "wildness" => wildness,
      "temperature" => wildness * 1.2,
      "line" => line
    }
  end

  defp compile_ground(args, line) do
    params = extract_params(args)

    %{
      "@context" => @context,
      "@type" => "cadence:GroundingOperation",
      "consciousness" => %{
        "base_frequency" => 7.5,
        "state" => "grounded",
        "cognitive_load" => 0.2,
        "arousal" => 0.3,
        "safety_grounding" => 7.5,
        "sync_coefficient" => 0.95,
        "description" => "Return to Earth frequency baseline"
      },
      "force" => params[:force] || false,
      "line" => line
    }
  end

  defp compile_generic_function(name, args, line) do
    %{
      "@context" => @context,
      "@type" => "cadence:FunctionCall",
      "name" => name,
      # Optimization: use list comprehension instead of Enum.map
      "args" => (for arg <- args do
        compile_statement(arg, :fingerprint)
      end),
      "line" => line
    }
  end

  defp extract_params(args) do
    # Optimization: Use Enum.reduce to avoid multiple list passes
    # with Enum.filter then Enum.into
    Enum.reduce(args, %{}, fn
      %{type: :keyword_arg, key: key, value: value}, acc ->
        Map.put(acc, key, get_literal_value(value))

      _, acc ->
        acc
    end)
  end

  defp get_literal_value(%{type: :literal, value: value}), do: value
  defp get_literal_value(other), do: other

  defp merge_fingerprints(fingerprints) do
    %{
      "@context" => @context,
      "@type" => "cadence:Composition",
      "@graph" => fingerprints,
      "timestamp" => DateTime.utc_now() |> DateTime.to_iso8601()
    }
  end
end
