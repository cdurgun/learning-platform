// Wires a real MCP client and the real GeoFactsServer.ts server together
// over an in-memory transport (the same pattern RunServerWithClient.ts used
// in "Building an MCP Server"), then runs a real agent loop against them.
// The (simulated) decision-making in AgentLoop.ts is clearly labeled at
// every step below -- everything else (the tool calls, the MCP messages,
// the results) is genuinely executed.
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { InMemoryTransport } from "@modelcontextprotocol/sdk/inMemory.js";
import { createGeoFactsServer } from "./GeoFactsServer.js";
import { runAgentLoop } from "./AgentLoop.js";

async function main() {
  const server = createGeoFactsServer();
  const [clientTransport, serverTransport] = InMemoryTransport.createLinkedPair();
  const client = new Client({ name: "agent-demo-client", version: "1.0.0" });

  await Promise.all([
    server.connect(serverTransport),
    client.connect(clientTransport),
  ]);

  const goal = "What is the capital of Japan, and what is the sum of 12, 30, and 8?";
  console.log(`Goal: ${goal}\n`);

  const result = await runAgentLoop(client, goal, 5);

  result.steps.forEach((step, i) => {
    console.log(`Step ${i + 1}: ${step.thought}`);
    if (step.toolCall) {
      console.log(`  Tool call:   ${step.toolCall.name}(${JSON.stringify(step.toolCall.arguments)})`);
      console.log(`  Tool result: ${step.toolResult}${step.toolIsError ? " (isError: true)" : ""}`);
    }
    console.log();
  });

  console.log(`Final answer: ${result.finalAnswer}`);
  console.log(`Stopped by step limit: ${result.stoppedByStepLimit}`);

  await client.close();
  await server.close();
}

main();
