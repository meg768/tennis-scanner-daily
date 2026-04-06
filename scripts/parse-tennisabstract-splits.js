#!/usr/bin/env node

let input = "";
process.stdin.setEncoding("utf8");
process.stdin.on("data", (chunk) => {
  input += chunk;
});

function parseArgs(argv) {
  const result = {
    format: "json",
  };

  for (let i = 0; i < argv.length; i += 1) {
    const token = argv[i];
    if (token === "--format") {
      result.format = argv[i + 1] || "json";
      i += 1;
    }
  }

  return result;
}

function stripTags(value) {
  return String(value || "")
    .replace(/<[^>]+>/g, "")
    .replace(/&nbsp;/g, " ")
    .replace(/&amp;/g, "&")
    .trim();
}

function extractTable(html, headingId) {
  const headingToken = `<h1 id="${headingId}"`;
  const headingIndex = html.indexOf(headingToken);
  if (headingIndex === -1) {
    return "";
  }

  const tableStart = html.indexOf("<table", headingIndex);
  if (tableStart === -1) {
    return "";
  }

  const tableEnd = html.indexOf("</table>", tableStart);
  if (tableEnd === -1) {
    return "";
  }

  return html.slice(tableStart, tableEnd + "</table>".length);
}

function extractRow(tableHtml, label) {
  const rows = [...String(tableHtml || "").matchAll(/<tr>(.*?)<\/tr>/gs)];
  for (const [, rowHtml] of rows) {
    const cells = [...rowHtml.matchAll(/<t[dh][^>]*>(.*?)<\/t[dh]>/gs)].map((cell) => stripTags(cell[1]));
    if (!cells.length) {
      continue;
    }
    if (cells[0] === label || cells[0].includes(label)) {
      return {
        label,
        matches: cells[1] || "",
        wins: cells[2] || "",
        losses: cells[3] || "",
        winPct: cells[4] || "",
      };
    }
  }
  return null;
}

function compact(row) {
  if (!row) {
    return "";
  }
  return `${row.wins}-${row.losses} (${row.winPct})`;
}

function combineRows(rows) {
  const validRows = rows.filter(Boolean);
  if (!validRows.length) {
    return null;
  }

  const matches = validRows.reduce((sum, row) => sum + Number.parseInt(row.matches || "0", 10), 0);
  const wins = validRows.reduce((sum, row) => sum + Number.parseInt(row.wins || "0", 10), 0);
  const losses = validRows.reduce((sum, row) => sum + Number.parseInt(row.losses || "0", 10), 0);
  const winPct = matches ? `${((wins / matches) * 100).toFixed(1)}%` : "";

  return {
    matches: String(matches),
    wins: String(wins),
    losses: String(losses),
    winPct,
  };
}

function extractCareerRow(html) {
  const match = html.match(/<tr><td><b>Career<\/b><\/td>(.*?)<\/tr>/s);
  if (!match) {
    return null;
  }

  const cells = [...match[1].matchAll(/<td[^>]*>(.*?)<\/td>/gs)].map((cell) => stripTags(cell[1]));
  return {
    matches: cells[0] || "",
    wins: cells[1] || "",
    losses: cells[2] || "",
    winPct: cells[3] || "",
  };
}

process.stdin.on("end", () => {
  const { format } = parseArgs(process.argv.slice(2));

  const careerTable = extractTable(input, "career-splits-h");
  const last52Table = extractTable(input, "last52-splits-h");
  const last52Overall = combineRows([
    extractRow(last52Table, "Hard"),
    extractRow(last52Table, "Clay"),
    extractRow(last52Table, "Grass"),
    extractRow(last52Table, "Carpet"),
  ]);

  const payload = {
    career: compact(extractCareerRow(input)),
    last52: compact(last52Overall),
    clay52: compact(extractRow(last52Table, "Clay")),
    top1052: compact(extractRow(last52Table, "vs Top 10")),
  };

  if (format === "tsv") {
    process.stdout.write(`${payload.last52}\t${payload.clay52}\t${payload.top1052}\t${payload.career}\n`);
    return;
  }

  process.stdout.write(`${JSON.stringify(payload, null, 2)}\n`);
});
