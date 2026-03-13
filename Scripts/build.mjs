import { cp, mkdir, readFile, rm, stat, writeFile } from "node:fs/promises";
import path from "node:path";
import { spawnSync } from "node:child_process";
import { resolveScreepsKitBootstrap } from "./lib/resolve-screepskit-bootstrap.mjs";

const root = process.cwd();
const distDir = path.join(root, "dist");
const buildDir = path.join(root, ".build-wasm");
const args = new Set(process.argv.slice(2));

const runtimeSource = path.join(
  root,
  "node_modules",
  "javascript-kit-swift",
  "Runtime",
  "lib",
  "index.js"
);

function run(command, commandArgs, description) {
  const result = spawnSync(command, commandArgs, {
    cwd: root,
    stdio: "inherit",
    env: process.env,
  });

  if (result.status !== 0) {
    throw new Error(`${description} failed with exit code ${result.status ?? 1}`);
  }
}

function sdkArguments() {
  const configuredSdk = process.env.SWIFT_WASM_SDK;
  if (configuredSdk) {
    return {
      sdkName: configuredSdk,
      args: ["--swift-sdk", configuredSdk],
    };
  }

  const sdkList = spawnSync("swift", ["sdk", "list"], {
    cwd: root,
    encoding: "utf8",
    env: process.env,
  });

  const output = `${sdkList.stdout ?? ""}\n${sdkList.stderr ?? ""}`;
  const knownSdk = output
    .split(/\r?\n/)
    .map((line) => line.trim())
    .find(
      (line) =>
        line.startsWith("wasm32-unknown-wasip1") || line.startsWith("wasm32-unknown-wasi")
    );

  if (!knownSdk) {
    throw new Error(
      [
        "No Swift WASM SDK is installed.",
        "Install one first, for example:",
        "  swift sdk install https://github.com/swiftwasm/swift/releases/download/swift-wasm-6.2-RELEASE/swift-wasm-6.2-RELEASE-wasm32-unknown-wasip1.artifactbundle.tar.gz",
        "Then re-run `npm run build`.",
      ].join("\n")
    );
  }

  const sdkName = knownSdk.split(/\s+/)[0];
  return {
    sdkName,
    args: ["--swift-sdk", sdkName],
  };
}

async function pathExists(targetPath) {
  try {
    await stat(targetPath);
    return true;
  } catch {
    return false;
  }
}

async function resolveWasmArtifact(sdkName) {
  const candidates = [
    path.join(buildDir, sdkName, "release", "ScreepsSwift.wasm"),
    path.join(buildDir, "release", "ScreepsSwift.wasm"),
  ];

  for (const candidate of candidates) {
    if (await pathExists(candidate)) {
      return candidate;
    }
  }

  throw new Error(
    `Unable to locate ScreepsSwift.wasm in ${buildDir}. Check the SwiftWasm toolchain output layout.`
  );
}

async function buildSwift() {
  const { sdkName, args: sdkArgs } = sdkArguments();
  console.log(`Building Swift WASM with SDK '${sdkName}'...`);

  run(
    "swift",
    [
      "build",
      ...sdkArgs,
      "--build-path",
      ".build-wasm",
      "-c",
      "release",
      "--product",
      "ScreepsSwift",
      "-Xswiftc",
      "-Xclang-linker",
      "-Xswiftc",
      "-mexec-model=reactor",
    ],
    "Swift WASM build"
  );

  const wasmArtifact = await resolveWasmArtifact(sdkName);
  await cp(wasmArtifact, path.join(distDir, "ScreepsSwift.wasm"));
}

async function buildJavaScriptModules() {
  let bootstrapSource = await resolveScreepsKitBootstrap(root);
  if (!bootstrapSource) {
    run("swift", ["package", "resolve"], "Swift package resolve");
    bootstrapSource = await resolveScreepsKitBootstrap(root);
  }

  if (!bootstrapSource) {
    throw new Error(
      "Unable to locate ScreepsKit bootstrap asset. Resolve package dependencies or ensure ../ScreepsKit exists."
    );
  }

  const bootstrap = await readFile(bootstrapSource, "utf8");
  await writeFile(path.join(distDir, "main.js"), bootstrap);
  await cp(runtimeSource, path.join(distDir, "javascript-kit-swift.js"));
}

await rm(distDir, { recursive: true, force: true });
await mkdir(distDir, { recursive: true });

if (!args.has("--skip-swift")) {
  await buildSwift();
}

await buildJavaScriptModules();
await writeFile(
  path.join(distDir, "manifest.json"),
  `${JSON.stringify(
    {
      generatedAt: new Date().toISOString(),
      modules: ["main", "javascript-kit-swift", "ScreepsSwift"],
    },
    null,
    2
  )}\n`
);

console.log("Built Screeps distribution into dist/.");
