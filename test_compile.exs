
# Script to compile the example
{ok, source} = File.read("docs/examples/zpc-keygen.cadence")
{:ok, ast} = Cantor.Cadence.Parser.parse(source)
json = Cantor.Cadence.Compiler.compile(ast, :fingerprint)
IO.inspect(json, label: "Compiled AMF")
