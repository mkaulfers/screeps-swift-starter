import fs from "node:fs/promises";
import path from "node:path";
import ts from "typescript";

const root = process.cwd();
const declarationPath = path.join(root, "node_modules", "@types", "screeps", "index.d.ts");
const outputPath = path.join(
  root,
  "Sources",
  "ScreepsKit",
  "Generated",
  "ScreepsBindings.generated.swift"
);
const checkOnly = process.argv.includes("--check");

const declarationSource = await fs.readFile(declarationPath, "utf8");
const sourceFile = ts.createSourceFile(
  declarationPath,
  declarationSource,
  ts.ScriptTarget.Latest,
  true,
  ts.ScriptKind.TS
);

const typeAliases = new Map();
const ambientConsts = [];
const ambientVars = [];
const interfaces = [];

for (const statement of sourceFile.statements) {
  if (ts.isTypeAliasDeclaration(statement)) {
    typeAliases.set(statement.name.text, statement.type);
    continue;
  }

  if (ts.isInterfaceDeclaration(statement)) {
    interfaces.push(statement.name.text);
    continue;
  }

  if (!ts.isVariableStatement(statement)) {
    continue;
  }

  const isConst = (statement.declarationList.flags & ts.NodeFlags.Const) !== 0;
  for (const declaration of statement.declarationList.declarations) {
    if (!ts.isIdentifier(declaration.name)) {
      continue;
    }

    const name = declaration.name.text;
    const typeName =
      declaration.type && ts.isTypeReferenceNode(declaration.type) && ts.isIdentifier(declaration.type.typeName)
        ? declaration.type.typeName.text
        : undefined;

    if (isConst) {
      ambientConsts.push({ name, typeName });
    } else {
      ambientVars.push(name);
    }
  }
}

function literalFromTypeNode(typeNode, seen = new Set()) {
  if (!typeNode) {
    return undefined;
  }

  if (ts.isParenthesizedTypeNode(typeNode)) {
    return literalFromTypeNode(typeNode.type, seen);
  }

  if (ts.isLiteralTypeNode(typeNode)) {
    const literal = typeNode.literal;
    if (ts.isStringLiteral(literal)) {
      return literal.text;
    }
    if (ts.isNumericLiteral(literal)) {
      return Number(literal.text);
    }
    if (literal.kind === ts.SyntaxKind.TrueKeyword) {
      return true;
    }
    if (literal.kind === ts.SyntaxKind.FalseKeyword) {
      return false;
    }
    if (ts.isPrefixUnaryExpression(literal) && ts.isNumericLiteral(literal.operand)) {
      const value = Number(literal.operand.text);
      return literal.operator === ts.SyntaxKind.MinusToken ? -value : value;
    }
  }

  if (ts.isTypeReferenceNode(typeNode) && ts.isIdentifier(typeNode.typeName)) {
    const name = typeNode.typeName.text;
    if (seen.has(name)) {
      return undefined;
    }

    const next = typeAliases.get(name);
    if (!next) {
      return undefined;
    }

    seen.add(name);
    return literalFromTypeNode(next, seen);
  }

  return undefined;
}

function toCamelCase(value) {
  const parts = value
    .replace(/([a-z0-9])([A-Z])/g, "$1_$2")
    .split(/[_\s-]+/)
    .filter(Boolean)
    .map((part) => part.toLowerCase());

  if (parts.length === 0) {
    return "value";
  }

  return parts
    .map((part, index) => (index === 0 ? part : `${part[0].toUpperCase()}${part.slice(1)}`))
    .join("");
}

function sanitizeIdentifier(identifier, fallbackPrefix = "screeps") {
  const reserved = new Set([
    "as",
    "associatedtype",
    "break",
    "case",
    "class",
    "continue",
    "default",
    "defer",
    "deinit",
    "do",
    "else",
    "enum",
    "extension",
    "fallthrough",
    "false",
    "fileprivate",
    "for",
    "func",
    "guard",
    "if",
    "import",
    "in",
    "init",
    "inout",
    "internal",
    "is",
    "let",
    "nil",
    "operator",
    "private",
    "protocol",
    "public",
    "repeat",
    "rethrows",
    "return",
    "self",
    "static",
    "struct",
    "subscript",
    "super",
    "switch",
    "throw",
    "throws",
    "true",
    "try",
    "typealias",
    "var",
    "where",
    "while",
  ]);

  let result = identifier.replace(/[^a-zA-Z0-9_]/g, "");
  if (/^[0-9]/.test(result)) {
    result = `value${result}`;
  }
  if (reserved.has(result)) {
    result = `${fallbackPrefix}${result[0].toUpperCase()}${result.slice(1)}`;
  }
  return result;
}

function enumCaseName(enumName, name, prefix = "") {
  if (enumName === "ReturnCode") {
    if (name === "OK") {
      return "ok";
    }
    return sanitizeIdentifier(toCamelCase(name.replace(/^ERR_/, "")), "returnCode");
  }

  const trimmed = prefix && name.startsWith(prefix) ? name.slice(prefix.length) : name;
  let identifier = sanitizeIdentifier(toCamelCase(trimmed), toCamelCase(enumName));

  if (enumName === "StructureType" && identifier === "structureExtension") {
    return identifier;
  }
  if (enumName === "StructureType" && trimmed === "EXTENSION") {
    return "structureExtension";
  }
  if (enumName === "ResourceType" && trimmed === "SWITCH") {
    return "switchResource";
  }

  return identifier;
}

function renderEnum(enumName, entries, rawType, prefix = "") {
  const lines = [
    `public enum ${enumName}: ${rawType}, CaseIterable, Sendable {`,
  ];

  for (const entry of entries) {
    const literal = JSON.stringify(entry.literal);
    lines.push(`    case ${enumCaseName(enumName, entry.name, prefix)} = ${literal}`);
  }

  lines.push("}");
  return lines.join("\n");
}

function renderStringEnum(enumName, entries, prefix = "") {
  return renderEnum(enumName, entries, "String", prefix);
}

function renderIntEnum(enumName, entries, prefix = "") {
  const lines = [
    `public enum ${enumName}: Int, CaseIterable, Sendable {`,
  ];

  for (const entry of entries) {
    lines.push(`    case ${enumCaseName(enumName, entry.name, prefix)} = ${entry.literal}`);
  }

  lines.push("}");
  return lines.join("\n");
}

function collectConstEntries(predicate) {
  return ambientConsts
    .map((entry) => ({
      ...entry,
      literal: literalFromTypeNode(typeAliases.get(entry.typeName)),
    }))
    .filter((entry) => entry.literal !== undefined && predicate(entry));
}

const returnCodes = collectConstEntries((entry) => entry.name === "OK" || entry.name.startsWith("ERR_"));
const findConstants = collectConstEntries((entry) => entry.name.startsWith("FIND_"));
const lookConstants = collectConstEntries((entry) => entry.name.startsWith("LOOK_"));
const directions = collectConstEntries((entry) =>
  ["TOP", "TOP_RIGHT", "RIGHT", "BOTTOM_RIGHT", "BOTTOM", "BOTTOM_LEFT", "LEFT", "TOP_LEFT"].includes(entry.name)
);
const colors = collectConstEntries((entry) => entry.name.startsWith("COLOR_"));
const bodyParts = collectConstEntries((entry) =>
  ["MOVE", "WORK", "CARRY", "ATTACK", "RANGED_ATTACK", "TOUGH", "HEAL", "CLAIM"].includes(entry.name)
);
const structureTypes = collectConstEntries((entry) => entry.name.startsWith("STRUCTURE_"));
const resourceTypes = collectConstEntries((entry) => entry.name.startsWith("RESOURCE_"));

const filteredInterfaces = interfaces
  .filter((name) => !name.startsWith("_") && !name.endsWith("Constructor"))
  .sort((left, right) => left.localeCompare(right));

const filteredGlobals = ambientVars
  .filter((name) =>
    ["Game", "Memory", "RawMemory", "InterShardMemory", "PathFinder"].includes(name)
  )
  .sort((left, right) => left.localeCompare(right));

const uniqueReturnCodes = [];
const seenReturnCodeValues = new Set();
for (const entry of returnCodes) {
  if (seenReturnCodeValues.has(entry.literal)) {
    continue;
  }
  seenReturnCodeValues.add(entry.literal);
  uniqueReturnCodes.push(entry);
}

const returnCodeAliases = returnCodes.filter((entry) => !uniqueReturnCodes.includes(entry));

const sections = [
  "// This file is generated from @types/screeps. Do not edit directly.",
  "",
  renderIntEnum("ReturnCode", uniqueReturnCodes),
  "",
  "public extension ReturnCode {",
  ...returnCodeAliases.map(
    (entry) =>
      `    static let ${enumCaseName("ReturnCode", entry.name)} = ReturnCode(rawValue: ${entry.literal})!`
  ),
  "}",
  "",
  renderIntEnum("FindConstant", findConstants, "FIND_"),
  "",
  renderIntEnum("Direction", directions),
  "",
  renderIntEnum("ColorConstant", colors, "COLOR_"),
  "",
  renderStringEnum("BodyPart", bodyParts),
  "",
  renderStringEnum("LookConstant", lookConstants, "LOOK_"),
  "",
  renderStringEnum("StructureType", structureTypes, "STRUCTURE_"),
  "",
  renderStringEnum("ResourceType", resourceTypes, "RESOURCE_"),
  "",
  "public enum GeneratedInterfaceName: String, CaseIterable, Sendable {",
  ...filteredInterfaces.map(
    (name) => `    case ${sanitizeIdentifier(toCamelCase(name), "generatedInterface")} = "${name}"`
  ),
  "}",
  "",
  "public enum GeneratedGlobalName: String, CaseIterable, Sendable {",
  ...filteredGlobals.map(
    (name) => `    case ${sanitizeIdentifier(toCamelCase(name), "generatedGlobal")} = "${name}"`
  ),
  "}",
  "",
];

const rendered = `${sections.join("\n")}\n`;

if (checkOnly) {
  const current = await fs.readFile(outputPath, "utf8");
  if (current !== rendered) {
    throw new Error("Generated bindings are out of date. Run `npm run generate-bindings`.");
  }
  console.log("Generated bindings are up to date.");
} else {
  await fs.mkdir(path.dirname(outputPath), { recursive: true });
  await fs.writeFile(outputPath, rendered);
  console.log(`Generated ${path.relative(root, outputPath)} from @types/screeps.`);
}
