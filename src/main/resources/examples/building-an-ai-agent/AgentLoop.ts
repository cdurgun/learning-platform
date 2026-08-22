// This file implements a genuine agent loop: a decision step chooses an
// action, that action is really executed against a real MCP server (through
// a real MCP client's callTool -- the exact same call RunServerWithClient.ts
// in "Building an MCP Server" used), and the real result is fed back into
// the next decision step. None of the tool-calling or MCP communication
// below is faked.
//
// What IS faked, on purpose, is the decision step itself. A real agent uses
// a large language model to read the goal and the conversation so far and
// decide, through open-ended reasoning, what to do next. This lesson has no
// access to a real LLM API, so decideNextAction() below is a small, fully
// deterministic, hand-written function: it recognizes two fixed patterns of
// text ("capital of X" and "sum of ...") and nothing else. It is NOT a
// language model, does not "understand" the goal in any general sense, and
// must never be mistaken for real model behavior -- it exists only so the
// *loop* around it (decide -> act -> observe -> repeat) can be demonstrated
// with a real, running, inspectable agent, calling the real
// get_capital_city and calculate_sum tools from GeoFactsServer.ts.
import type { Client } from "@modelcontextprotocol/sdk/client/index.js";

export interface AgentStep {
  thought: string;
  toolCall?: { name: string; arguments: Record<string, unknown> };
  toolResult?: string;
  toolIsError?: boolean;
}

export interface AgentResult {
  steps: AgentStep[];
  finalAnswer: string;
  stoppedByStepLimit: boolean;
}

interface Decision {
  thought: string;
  toolCall?: { name: string; arguments: Record<string, unknown> };
  finalAnswer?: string;
}

// (Simulated model.) A deterministic, explicitly hand-written stand-in for
// what a language model would do at each turn: look at the goal and what
// has happened so far, and decide on ONE next action. Real agents replace
// this single function with an LLM call -- runAgentLoop() below, and
// everything it does with the result, stays exactly the same either way.
function decideNextAction(goal: string, history: AgentStep[]): Decision {
  const alreadyCalled = (toolName: string) =>
    history.some((step) => step.toolCall?.name === toolName);

  const countryMatch = goal.match(/capital of (\w+)/i);
  if (countryMatch && !alreadyCalled("get_capital_city")) {
    const country = countryMatch[1];
    return {
      thought: `(simulated) Goal asks for the capital of "${country}". Plan: call get_capital_city.`,
      toolCall: { name: "get_capital_city", arguments: { country } },
    };
  }

  const sumMatch = goal.match(/sum of ([0-9, and]+[0-9])/i);
  if (sumMatch && !alreadyCalled("calculate_sum")) {
    const numbers = sumMatch[1]
      .split(/,|and/i)
      .map((part) => part.trim())
      .filter((part) => part.length > 0)
      .map(Number);
    return {
      thought: `(simulated) Goal asks for the sum of [${numbers.join(", ")}]. Plan: call calculate_sum.`,
      toolCall: { name: "calculate_sum", arguments: { numbers } },
    };
  }

  // Both sub-goals this demo cares about are already satisfied (or never
  // matched at all) -- (simulated) combine what the real tool calls
  // returned into a final answer instead of calling anything else.
  const facts = history
    .filter((step) => step.toolResult !== undefined)
    .map((step) => step.toolResult)
    .join(" ");
  return {
    thought: "(simulated) All sub-goals are covered by prior tool results. Plan: answer using them.",
    finalAnswer: facts.length > 0 ? facts : "(no tool results were gathered to answer from)",
  };
}

// The real agent loop: decide, act for real, observe the real result,
// repeat -- bounded by maxSteps so a decision function that never resolves
// to a final answer cannot run forever (see "Controlling Agent Behavior"
// for why a step-limit guardrail like this matters in general).
export async function runAgentLoop(
  client: Client,
  goal: string,
  maxSteps: number
): Promise<AgentResult> {
  const steps: AgentStep[] = [];

  for (let i = 0; i < maxSteps; i++) {
    const decision = decideNextAction(goal, steps);

    if (decision.finalAnswer !== undefined) {
      return { steps, finalAnswer: decision.finalAnswer, stoppedByStepLimit: false };
    }

    if (decision.toolCall) {
      const result = await client.callTool({
        name: decision.toolCall.name,
        arguments: decision.toolCall.arguments,
      });
      const content = result.content as Array<{ type: string; text: string }>;
      const text = content.map((c) => (c.type === "text" ? c.text : "")).join(" ").trim();
      steps.push({
        thought: decision.thought,
        toolCall: decision.toolCall,
        toolResult: text,
        toolIsError: Boolean(result.isError),
      });
    }
  }

  return {
    steps,
    finalAnswer: "(step limit reached before a final answer was produced)",
    stoppedByStepLimit: true,
  };
}
