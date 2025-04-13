import { fetchSnapshotData } from "./loader.js";

let chartInstance = null;

/**
 * 黄金角度 HSL 为每个 playerId 生成独特颜色
 * e.g. playerId=1 => hue ~ 137°, playerId=2 => hue ~ 275°, etc.
 */
function generatePlayerColor(playerId) {
  const hue = (playerId * 137.508) % 360; 
  return `hsl(${hue}, 80%, 50%)`;  
}

/** 为同一个玩家构建 3 条曲线 (Coin/Action/Buy)，用相同主色，不同 dash/pointStyle */
function buildPlayerDatasets(playerId, entries, baseColor) {
  // 排序
  entries.sort((a, b) => a.log_id - b.log_id);

  // 把 log_id -> coin / action / buy 转为 Chart.js data
  const coinData   = entries.map(e => ({ x: e.log_id, y: e.coin }));
  const actionData = entries.map(e => ({ x: e.log_id, y: e.action }));
  const buyData    = entries.map(e => ({ x: e.log_id, y: e.buy }));

  // 你也可以把 deckSize / handSize 做成更多 dataset
  return [
    {
      label: `P${playerId} Coin`,
      data: coinData,
      borderColor: baseColor,
      backgroundColor: baseColor + "33",  // 透明度
      pointStyle: "circle",
      tension: 0.3
    },
    {
      label: `P${playerId} Action`,
      data: actionData,
      borderColor: baseColor,
      backgroundColor: baseColor + "33",
      borderDash: [4, 4],
      pointStyle: "triangle",
      tension: 0.3
    },
    {
      label: `P${playerId} Buy`,
      data: buyData,
      borderColor: baseColor,
      backgroundColor: baseColor + "33",
      borderDash: [2, 6],
      pointStyle: "rectRot",
      tension: 0.3
    }
  ];
}

/**
 * 主函数：renderResourceChart
 * @param {Array} trackerData - 当前过滤后的 trackerIndex
 * @param {string} folder     - 当前对局文件夹
 */
export async function renderResourceChart(trackerData, folder) {
  const container = document.getElementById("tab-chart");
  if (!container) return;

  // 先清空旧图表
  container.innerHTML = "";
  if (chartInstance) {
    chartInstance.destroy();
    chartInstance = null;
  }

  // 没数据则不画
  if (!trackerData || trackerData.length === 0) {
    return;
  }

  // 先收集「实际出现」的玩家
  const relevantPlayers = new Set(trackerData.map(e => e.player));

  // 并行加载 snapshots
  const snapshots = await Promise.all(
    trackerData.map(entry => {
      const path = `/data/games/replays/${folder}/${entry.path}`;
      return fetchSnapshotData(path).then(json => ({
        log_id: entry.log_id,
        snapshot: json
      }));
    })
  );

  // 建立 playerMap: playerId -> [ {log_id, coin, action, buy}, ... ]
  const playerMap = new Map();
  relevantPlayers.forEach(pid => playerMap.set(pid, []));  // 先初始化

  snapshots.forEach(({ log_id, snapshot }) => {
    if (!snapshot.players) return;
    snapshot.players.forEach(p => {
      // 如果 p.id 在 relevantPlayers 中才收集
      if (!playerMap.has(p.id)) return; 
      playerMap.get(p.id).push({
        log_id,
        coin:   p.coin,
        action: p.action,
        buy:    p.buy
      });
    });
  });

  // 为出现过的玩家构造 datasets
  let datasets = [];
  [...playerMap.keys()].sort((a,b)=>a-b).forEach(pid => {
    const arr = playerMap.get(pid);
    if (!arr || arr.length===0) return; // 该玩家没数据
    const baseColor = generatePlayerColor(pid);
    const subSets = buildPlayerDatasets(pid, arr, baseColor);
    datasets = datasets.concat(subSets);
  });

  if (datasets.length === 0) {
    return;
  }

  // 创建 canvas
  const canvas = document.createElement("canvas");
  container.appendChild(canvas);

  // 构建图表
  const ctx = canvas.getContext("2d");
  chartInstance = new Chart(ctx, {
    type: "line",
    data: { datasets },
    options: {
      responsive: true,
      plugins: {
        title: {
          display: true,
          text: "Player Resource Timeline"
        },
        tooltip: {
          mode: "index",
          intersect: false
        },
        legend: {
          position: "bottom",
          labels: {
            usePointStyle: true,    // 用点样式代替大方块
            boxWidth: 8,
            boxHeight: 8,
            padding: 12,
            color: "#333",
            font: {
              size: 14
            }
          }
        }
      },
      interaction: {
        mode: "nearest",
        axis: "x",
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