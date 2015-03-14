defmodule Mix.Tasks.Compile.Bitcask do
  @shortdoc "Compiles Bitcask NIF"

  def run(_) do
    if match? {:win32, _}, :os.type do
      Mix.shell.error "Don't know how to build for Windows"
    else
      {result, _error_code} = System.cmd("make", ["priv/bitcask.so"], stderr_to_stdout: true)
      Mix.shell.info result
    end
  end
end

defmodule ExBitcask.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_bitcask,
      name: "ExBitcask",
      version: "0.1.0",
      source_url: "https://github.com/JonGretar/ExBitcask",
      homepage_url: "http://hexdocs.pm/ex_bitcask",
      compilers: [:bitcask, :erlang, :elixir, :app],
      elixir: "~> 1.0.1",
      deps: deps,
      description: description,
      package: package
    ]
  end

  def application do
    apps = [:logger]
    dev_apps = Mix.env == :dev && [:reprise] || []
    [
      mod: {ExBitcask, []},
      applications: dev_apps ++ apps
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.7.1", only: :docs},
      {:ex_doc_dash, "~> 0.2.1", only: :docs},
      {:reprise, "~> 0.3.0", only: :dev},
    ]
  end

  defp description do
    """
    Elixir wrapper of Basho's Bitcask Key/Value store.
    Bitcask as a Log-Structured Hash Table for Fast Key/Value Data.
    """
  end

  defp package do
    [
      contributors: ["Jón Grétar Borgþórsson"],
      licenses: ["Apache 2.0"],
      files: ["lib", "src", "c_src/*.h", "c_src/*.c", "include", "config", "Makefile", "mix.exs", "README.md"],
      links: %{
        "GitHub": "https://github.com/JonGretar/ExBitcask",
        "Bitcask Info": "https://en.wikipedia.org/wiki/Bitcask",
        "Issues": "https://github.com/JonGretar/ExBitcask/issues"
      }
    ]
  end
end
