// Demonstrates a real MCP client talking to the server from
// GeoFactsServer.ts over an in-memory transport (no network/stdio needed --
// ideal for a runnable, self-contained example). A real host application
// would instead connect over stdio or HTTP to a separately running server
// process, but the request/response behavior shown here -- discovering
// tools, then calling them -- is identical either way.
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { InMemoryTransport } from "@modelcontextprotocol/sdk/inMemory.js";
import { createGeoFactsServer } from "./GeoFactsServer.js";

type ToolTextContent = Array<{ type: string; text: string }>;

async function main() {
  const server = createGeoFactsServer();
  const [clientTransport, serverTransport] = InMemoryTransport.createLinkedPair();
  const client = new Client({ name: "demo-client", version: "1.0.0" });

  await Promise.all([
    server.connect(serverTransport),
    client.connect(clientTransport),
  ]);

  const toolList = await client.listTools();
  console.log("Tools discovered by client:", toolList.tools.map((t) => t.name));
  // Tools discovered by client: [ 'get_capital_city', 'calculate_sum' ]

  const capitalResult = await client.callTool({
    name: "get_capital_city",
    arguments: { country: "Japan" },
  });
  console.log("get_capital_city(Japan) ->", (capitalResult.content as ToolTextContent)[0].text);
  // get_capital_city(Japan) -> The capital of Japan is Tokyo.

  const sumResult = await client.callTool({
    name: "calculate_sum",
    arguments: { numbers: [4, 8, 15, 16, 23, 42] },
  });
  console.log("calculate_sum([4,8,15,16,23,42]) ->", (sumResult.content as ToolTextContent)[0].text);
  // calculate_sum([4,8,15,16,23,42]) -> Sum: 108

  const missingResult = await client.callTool({
    name: "get_capital_city",
    arguments: { country: "Wakanda" },
  });
  console.log(
    "get_capital_city(Wakanda) -> isError:",
    missingResult.isError,
    "text:",
    (missingResult.content as ToolTextContent)[0].text
  );
  // get_capital_city(Wakanda) -> isError: true text: No capital known for "Wakanda".

  await client.close();
  await server.close();
}

main();
