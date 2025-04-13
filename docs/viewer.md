# DomiNyan Viewer

<!-- 
  这里是 Markdown + HTML 混合区域，用于布局页面 
  以及引用外部脚本 
-->

## Select a Game Session
<select id="gameSelect" class="md-typeset" style="margin-left: 0.5em;"></select>

## Select a Tracker Snapshot
<select id="snapshotSelect" class="md-typeset" style="margin-left: 0.5em;"></select>

<!-- Filter Options -->
<div>
  <label><strong>Turn Filter</strong></label>
  <select id="turnFilter" class="md-typeset" style="margin-left: 0.5em;"></select>
</div>
<div>
  <label><strong>Player Filter</strong></label>
  <select id="playerFilter" class="md-typeset" style="margin-left: 0.5em;"></select>
</div>
<div>
  <label><strong>Phase Filter</strong></label>
  <select id="phaseFilter" class="md-typeset" style="margin-left: 0.5em;"></select>
</div>

<!-- Tab Navigation -->
<div style="display: flex; gap: 2rem;">
  <aside style="min-width: 180px;">
    <nav class="md-nav">
      <ul class="md-nav__list">
        <li><button class="md-button tab-button" data-tab="snapshot">📄 Snapshot JSON</button></li>
        <li><button class="md-button tab-button" data-tab="players">🧑 Players</button></li>
        <li><button class="md-button tab-button" data-tab="chart">📊 Resource Chart</button></li>
        <li><button class="md-button tab-button" data-tab="supply">📦 Supply & Trash</button></li>
      </ul>
    </nav>
  </aside>

  <main style="flex: 1;">
    <div id="tab-snapshot" class="tab-content"></div>
    <div id="tab-players" class="tab-content" style="display: none;"></div>
    <div id="tab-chart" class="tab-content" style="display: none;">
      <p>(Chart Placeholder...)</p>
    </div>
    <div id="tab-supply" class="tab-content" style="display: none;">
      <p>(Supply Placeholder...)</p>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script type="module" src="/docs/js/viewer/index.js"></script>