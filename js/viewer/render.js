export function renderSnapshotRaw(data) {
  const box = document.getElementById("tab-snapshot");
  if (!box) return;
  box.innerHTML = "";
  const pre = document.createElement("pre");
  pre.textContent = JSON.stringify(data, null, 2);
  pre.className = "md-typeset";
  pre.style.background = "#f6f8fa";
  pre.style.padding = "1em";
  pre.style.borderRadius = "6px";
  pre.style.overflowX = "auto";
  box.appendChild(pre);
}

export function renderPlayers(players) {
  const container = document.getElementById("tab-players");
  if (!container) return;
  container.innerHTML = "";

  if (!players || players.length === 0) {
    container.textContent = "No player data available.";
    return;
  }

  players.forEach(player => {
    const section = document.createElement("section");
    section.className = "player-block";
    section.style.marginBottom = "1em";
    section.style.borderBottom = "1px solid #ccc";
    section.style.paddingBottom = "1em";

    const title = document.createElement("h3");
    title.textContent = `Player ${player.id}`;
    title.style.marginBottom = "0.25em";
    section.appendChild(title);

    const info = document.createElement("p");
    info.innerHTML = `<strong>Actions:</strong> ${player.action} | <strong>Buys:</strong> ${player.buy} | <strong>Coins:</strong> ${player.coin}`;
    section.appendChild(info);

    const zones = ["hand", "deck", "discard", "played"];
    zones.forEach(zone => {
      const label = document.createElement("p");
      label.innerHTML = `<strong>${zone.charAt(0).toUpperCase() + zone.slice(1)}:</strong>`;
      section.appendChild(label);

      const row = document.createElement("div");
      row.style.display = "flex";
      row.style.flexWrap = "wrap";
      row.style.gap = "0.5em";

      (player[zone] || []).forEach(card => {
        const tag = document.createElement("span");
        tag.className = "md-typeset";
        tag.textContent = card;
        tag.style.background = "#e2e8f0";
        tag.style.padding = "0.25em 0.5em";
        tag.style.borderRadius = "4px";
        tag.style.fontSize = "0.85em";
        row.appendChild(tag);
      });

      section.appendChild(row);
    });

    container.appendChild(section);
  });
}

export function renderSupplyAndTrash(game) {
  const container = document.getElementById("tab-supply");
  if (!container) return;
  container.innerHTML = "";

  const supplySection = document.createElement("section");
  const trashSection = document.createElement("section");

  const supplyTitle = document.createElement("h3");
  supplyTitle.textContent = "Supply";
  supplySection.appendChild(supplyTitle);

  const supplyGrid = document.createElement("div");
  supplyGrid.style.display = "flex";
  supplyGrid.style.flexWrap = "wrap";
  supplyGrid.style.gap = "0.5em";

  Object.entries(game.supply || {}).forEach(([card, count]) => {
    const tag = document.createElement("span");
    tag.textContent = `${card} × ${count}`;
    tag.style.background = "#def";
    tag.style.padding = "0.25em 0.5em";
    tag.style.borderRadius = "4px";
    tag.style.fontSize = "0.85em";
    supplyGrid.appendChild(tag);
  });

  supplySection.appendChild(supplyGrid);

  const trashTitle = document.createElement("h3");
  trashTitle.textContent = "Trash";
  trashSection.appendChild(trashTitle);

  const trashGrid = document.createElement("div");
  trashGrid.style.display = "flex";
  trashGrid.style.flexWrap = "wrap";
  trashGrid.style.gap = "0.5em";

  (game.trash || []).forEach(card => {
    const tag = document.createElement("span");
    tag.textContent = card;
    tag.style.background = "#fcdcdc";
    tag.style.padding = "0.25em 0.5em";
    tag.style.borderRadius = "4px";
    tag.style.fontSize = "0.85em";
    trashGrid.appendChild(tag);
  });

  trashSection.appendChild(trashGrid);

  container.appendChild(supplySection);
  container.appendChild(trashSection);
}