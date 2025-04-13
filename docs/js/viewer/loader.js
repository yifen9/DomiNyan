export async function fetchJSON(path) {
  const res = await fetch(path);
  if (!res.ok) throw new Error("Failed to load " + path);
  return res.json();
}

export async function fetchReplaysIndex() {
  return await fetchJSON("../data/games/replays/replays_index.json");
}

export async function fetchTrackerIndex(folder) {
  return await fetchJSON(`../data/games/replays/${folder}/tracker_index.json`);
}

export async function fetchSnapshotData(path) {
  return await fetchJSON(path);
}