// index.js
import { fetchReplaysIndex, fetchTrackerIndex, fetchSnapshotData } from './loader.js';
import { renderPlayers, renderSnapshotRaw, renderSupplyAndTrash } from './render.js';
import { renderResourceChart } from './chart.js';

// 缓存及全局变量
const trackerCache = new Map();  
let allTrackerEntries = [];
let currentFiltered = [];

document.addEventListener("DOMContentLoaded", async () => {
  const gameSelect = document.getElementById("gameSelect");
  const snapshotSelect = document.getElementById("snapshotSelect");
  const turnFilter = document.getElementById("turnFilter");
  const playerFilter = document.getElementById("playerFilter");
  const phaseFilter = document.getElementById("phaseFilter");

  const tabMap = {
    snapshot: document.getElementById("tab-snapshot"),
    players: document.getElementById("tab-players"),
    chart: document.getElementById("tab-chart"),
    supply: document.getElementById("tab-supply")
  };

  // Tab 切换
  document.querySelectorAll(".tab-button").forEach(btn => {
    btn.addEventListener("click", () => {
      const tab = btn.dataset.tab;
      Object.entries(tabMap).forEach(([key, el]) => {
        el.style.display = (key === tab) ? "block" : "none";
      });
    });
  });

  try {
    // 加载游戏列表
    const replays = await fetchReplaysIndex();
    replays.forEach(replay => {
      const option = document.createElement("option");
      option.value = replay.folder;
      option.textContent = replay.timestamp || replay.folder;
      gameSelect.appendChild(option);
    });

    // 切换游戏
    gameSelect.addEventListener("change", async () => {
      const folder = gameSelect.value;
      if (!folder) return;

      let trackerList;
      // 优先用缓存
      if (trackerCache.has(folder)) {
        trackerList = trackerCache.get(folder);
      } else {
        trackerList = await fetchTrackerIndex(folder);
        trackerCache.set(folder, trackerList);  
      }

      allTrackerEntries = trackerList;
      renderFilters(trackerList);
      renderSnapshotOptions(trackerList);

      // 初始全部数据，无过滤
      currentFiltered = trackerList;
      // 初次加载图表
      renderResourceChart(currentFiltered, folder);
    });

    // 切换特定快照
    snapshotSelect.addEventListener("change", async () => {
      const path = snapshotSelect.value;
      if (!path) return;

      try {
        // 懒加载 snapshot
        const data = await fetchSnapshotData(path);
        renderPlayers(data.players || []);
        renderSnapshotRaw(data);
        renderSupplyAndTrash(data.game || {});
      } catch (e) {
        console.error("Failed to load snapshot data:", e);
      }
    });

    // 绑定过滤器
    [turnFilter, playerFilter, phaseFilter].forEach(select => {
      select.addEventListener("change", applyFilters);
    });

    // 如果有游戏列表，先默认加载第一个
    if (replays.length > 0) {
      gameSelect.value = replays[0].folder;
      gameSelect.dispatchEvent(new Event("change"));
    }

  } catch (e) {
    console.error("Initialization error:", e);
  }
});

// 渲染过滤选项
function renderFilters(trackerList) {
  const turnFilter = document.getElementById("turnFilter");
  const playerFilter = document.getElementById("playerFilter");
  const phaseFilter = document.getElementById("phaseFilter");

  const uniqueTurns = [...new Set(trackerList.map(e => e.turn))].sort((a, b) => a - b);
  const uniquePlayers = [...new Set(trackerList.map(e => e.player))].sort((a, b) => a - b);
  const uniquePhases = [...new Set(trackerList.map(e => e.phase))];

  turnFilter.innerHTML = `<option value="">All</option>`;
  playerFilter.innerHTML = `<option value="">All</option>`;
  phaseFilter.innerHTML = `<option value="">All</option>`;

  uniqueTurns.forEach(t => {
    turnFilter.innerHTML += `<option value="${t}">${t}</option>`;
  });
  uniquePlayers.forEach(p => {
    playerFilter.innerHTML += `<option value="${p}">P${p}</option>`;
  });
  uniquePhases.forEach(ph => {
    phaseFilter.innerHTML += `<option value="${ph}">${ph}</option>`;
  });
}

// 更新快照下拉选项
function renderSnapshotOptions(trackerList) {
  const snapshotSelect = document.getElementById("snapshotSelect");
  const folder = document.getElementById("gameSelect").value;
  const turnVal = document.getElementById("turnFilter").value;
  const playerVal = document.getElementById("playerFilter").value;
  const phaseVal = document.getElementById("phaseFilter").value;

  const filtered = trackerList.filter(entry => {
    return (!turnVal || entry.turn == turnVal) &&
           (!playerVal || entry.player == playerVal) &&
           (!phaseVal || entry.phase == phaseVal);
  });

  snapshotSelect.innerHTML = "";
  filtered.forEach(entry => {
    const option = document.createElement("option");
    option.value = `data/games/replays/${folder}/${entry.path}`;
    option.textContent = `${entry.log_id} | Turn ${entry.turn} | P${entry.player} | ${entry.phase}`;
    snapshotSelect.appendChild(option);
  });

  // 默认选第一个
  if (filtered.length > 0) {
    snapshotSelect.value = snapshotSelect.options[0].value;
    snapshotSelect.dispatchEvent(new Event("change"));
  }
}

// 实时过滤器
function applyFilters() {
  const folder = document.getElementById("gameSelect").value;
  const turnVal = document.getElementById("turnFilter").value;
  const playerVal = document.getElementById("playerFilter").value;
  const phaseVal = document.getElementById("phaseFilter").value;

  currentFiltered = allTrackerEntries.filter(entry => {
    return (!turnVal || entry.turn == turnVal) &&
           (!playerVal || entry.player == playerVal) &&
           (!phaseVal || entry.phase == phaseVal);
  });

  renderSnapshotOptions(currentFiltered);
  renderSnapshotOptions(currentFiltered);
  // 只把 currentFiltered 传给 chart
  renderResourceChart(currentFiltered, folder);
}