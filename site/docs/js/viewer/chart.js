import { fetchSnapshotData } from "./loader.js";

let chartInstance = null;

/**
 * 动态调色板：根据 dataset 数量，每次分配完全独立颜色
 * - 用 HSL 均分色环，去掉透明度
 * - 饱和度 70%，亮度 50%（你可自行调）
 */
function generatePalette(count) {
  const colors = [];
  for (let i = 0; i < count; i++) {
    const hue = (360 * i) / count; 
    colors.push(`hsl(${hue}, 70%, 50%)`);
  }
  return colors;
}

/**
 * 构建 "P2 Coin" 等曲线
 * @param {string} label - e.g. "P2 Coin"
 * @param {Array} dataArr - [ {x, y} ...]
 * @returns {Object} - dataset config
 */
function buildDataset(label, dataArr) {
  return {
    label,
    data: dataArr,
    // 颜色稍后再由 palette 动态赋值
    borderColor: "#aaa",
    // 不再填充点或填充曲线
    backgroundColor: "transparent",
    fill: false,
    // 不需要虚线
    borderDash: [],
    // 不需要点：可将 pointRadius=0, or if you want small points:
    pointRadius: 0,
    pointHoverRadius: 5,
    tension: 0.2   // 稍微顺滑
  };
}

export async function renderResourceChart(trackerData, folder) {
  const container = document.getElementById("tab-chart");
  if (!container) return;

  container.innerHTML = "";
  if (chartInstance) {
    chartInstance.destroy();
    chartInstance = null;
  }

  if (!trackerData || trackerData.length === 0) return;

  // 并发加载 snapshots
  const snapshots = await Promise.all(
    trackerData.map(entry => {
      const path = `/data/games/replays/${folder}/${entry.path}`;
      return fetchSnapshotData(path).then(json => ({
        log_id: entry.log_id,
        snapshot: json
      }));
    })
  );

  // 先聚合 data: playerId => { coin, action, buy } arrays
  const playerMap = new Map();
  // 取实际出现的 players
  const playerIds = [...new Set(trackerData.map(e=> e.player))].sort((a,b)=>a-b);
  // 初始化
  playerIds.forEach(p=> playerMap.set(p, []));
  
  snapshots.forEach(({ log_id, snapshot }) => {
    if (!snapshot.players) return;
    snapshot.players.forEach(p => {
      if (!playerMap.has(p.id)) return;
      playerMap.get(p.id).push({
        log_id,
        coin:   p.coin,
        action: p.action,
        buy:    p.buy
      });
    });
  });

  // 构造 line datasets
  let allDatasets = [];
  playerIds.forEach(pid => {
    const arr = playerMap.get(pid);
    if (!arr || arr.length===0) return;
    // 按 log_id 排序
    arr.sort((a,b)=> a.log_id - b.log_id);

    // 每条资源都独立颜色 => "P2 Coin" "P2 Action" "P2 Buy"
    // 3 条线 => 3 dataset
    const coinData = arr.map(e => ({ x:e.log_id, y:e.coin }));
    const actionData = arr.map(e => ({ x:e.log_id, y:e.action }));
    const buyData = arr.map(e => ({ x:e.log_id, y:e.buy }));

    // 构建3条
    allDatasets.push(buildDataset(`P${pid} Coin`, coinData));
    allDatasets.push(buildDataset(`P${pid} Action`, actionData));
    allDatasets.push(buildDataset(`P${pid} Buy`, buyData));
  });

  // 如果 allDatasets为空 -> 不画
  if (allDatasets.length===0) return;

  // 生成调色板 (每条曲线都分配独立颜色)
  const palette = generatePalette(allDatasets.length);
  // 给每个 dataset 赋一个颜色
  allDatasets.forEach((ds, i) => {
    ds.borderColor = palette[i];
  });

  // 创建 canvas
  const canvas = document.createElement("canvas");
  container.appendChild(canvas);

  const ctx = canvas.getContext("2d");
  chartInstance = new Chart(ctx, {
    type: 'line',
    data: {
      datasets: allDatasets
    },
    options: {
      responsive: true,
      plugins: {
        title: {
          display: true,
          text: "Player Resource Timeline"
        },
        legend: {
          position: 'bottom',
          labels: {
            // 让图例显示小线段: or usePointStyle + pointRadius?
            // usePointStyle: true,
            // 你若要纯线段, 需 chart.js v4 config
            boxWidth: 30,
            boxHeight: 2,
            color: "#333",
            font: { size: 14 },
            padding: 10
          }
        },
        tooltip: {
          mode: 'index',
          intersect: false
        }
      },
      interaction: {
        mode: 'nearest',
        axis: 'x',
        intersect: false
      },
      scales: {
        x: {
          type: "linear",
          title: { display: true, text: "Log ID" }
        },
        y: {
          title: { display: true, text: "Resource Value" }
        }
      }
    }
  });
}