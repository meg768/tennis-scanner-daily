#!/usr/bin/env node

let input = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => {
  input += chunk;
});

function parseArgs(argv) {
  const result = {
    surface: "",
    format: "json",
  };

  for (let i = 0; i < argv.length; i += 1) {
    const token = argv[i];
    if (token === "--surface") {
      result.surface = argv[i + 1] || "";
      i += 1;
      continue;
    }
    if (token === "--format") {
      result.format = argv[i + 1] || "json";
      i += 1;
    }
  }

  return result;
}

function extractRow(html, label) {
  const safeLabel = label.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const match = html.match(new RegExp(`<td align="left">${safeLabel}</td>(.*?)</tr>`, "s"));
  return match ? match[1] : "";
}

function extractJsVar(html, name) {
  const match = html.match(new RegExp(`var ${name} = '(.*?)';`, "s"));
  return match ? match[1] : "";
}

function extractPairs(rowHtml) {
  return [...String(rowHtml || "").matchAll(/<span title="([^"]*)">[\s\S]*?\(([0-9]+%)\)<\/span>/g)].map(
    ([, title, shown]) => ({ title, shown }),
  );
}

function pickPct(pair, surface) {
  if (!pair) {
    return "";
  }
  if (surface) {
    const match = pair.title.match(new RegExp(`${surface} Average: ([0-9]+%)`));
    if (match) {
      return match[1];
    }
  }
  return pair.shown;
}

process.stdin.on("end", () => {
  const { surface, format } = parseArgs(process.argv.slice(2));

  const servePairs = extractPairs(extractRow(input, "All Serves"));
  const returnPairs = extractPairs(extractRow(extractJsVar(input, "return1"), "Total"));
  const netPairs = extractPairs(extractRow(extractJsVar(input, "netpts1"), "All Net Approaches"));

  const payload = {
    surface: surface || null,
    serveWon: pickPct(servePairs[0], surface),
    aceRate: pickPct(servePairs[1], surface),
    returnWon: pickPct(returnPairs[0], surface),
    netApproachWon: pickPct(netPairs[0], surface),
  };

  if (format === "tsv") {
    process.stdout.write(
      `${payload.serveWon}\t${payload.aceRate}\t${payload.returnWon}\t${payload.netApproachWon}\n`,
    );
    return;
  }

  process.stdout.write(`${JSON.stringify(payload, null, 2)}\n`);
});
