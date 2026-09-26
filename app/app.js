/* FIFA Control Room
 * Aplicación web local, sin dependencias, para demostrar la funcionalidad
 * de la Entrega 3. En producción, las colecciones de este archivo se
 * reemplazan por llamadas a las vistas y procedimientos Oracle de /sql.
 */

const STORAGE_KEY = "fifa-entrega-3-demo-v1";
const PHASES = [
  "FASE DE GRUPOS",
  "DIECISEISAVOS",
  "OCTAVOS",
  "CUARTOS",
  "SEMIFINALES",
  "TERCER PUESTO",
  "FINAL"
];

const TITLES = {
  dashboard: "Resumen del torneo",
  catalogs: "Catálogos del torneo",
  matches: "Partidos y estadísticas",
  reports: "Reportes del torneo",
  incidents: "Incidencias"
};

const CATALOG_SINGULAR = {
  editions: "edición",
  venues: "sede",
  cities: "ciudad",
  stadiums: "estadio",
  teams: "selección",
  groups: "grupo",
  players: "jugador",
  staff: "integrante del cuerpo técnico"
};

const state = loadState();
let currentView = "dashboard";
let editingCatalog = null;

const $ = (selector, root = document) => root.querySelector(selector);
const $$ = (selector, root = document) => [...root.querySelectorAll(selector)];

function seedState() {
  return {
    editions: [
      { id: 1, year: 2026, name: "Mundial 2026", host: "Canadá, Estados Unidos y México", motto: "El fútbol nos une" },
      { id: 2, year: 2030, name: "Mundial 2030", host: "España, Portugal y Marruecos", motto: "Un siglo de fútbol" }
    ],
    venues: [
      { id: 1, name: "Sede Norteamérica", country: "México / Estados Unidos / Canadá" },
      { id: 2, name: "Sede Iberia", country: "España / Portugal / Marruecos" }
    ],
    cities: [
      { id: 1, name: "Ciudad de México", venueId: 1 },
      { id: 2, name: "Monterrey", venueId: 1 },
      { id: 3, name: "Madrid", venueId: 2 },
      { id: 4, name: "Lisboa", venueId: 2 }
    ],
    stadiums: [
      { id: 1, name: "Estadio Central", cityId: 1, capacity: 72000 },
      { id: 2, name: "Arena del Norte", cityId: 2, capacity: 58000 },
      { id: 3, name: "Estadio Ibérico", cityId: 3, capacity: 68000 },
      { id: 4, name: "Arena Atlántica", cityId: 4, capacity: 54000 }
    ],
    teams: [
      { id: 101, name: "Colombia", editionId: 1, confederation: "CONMEBOL" },
      { id: 102, name: "Argentina", editionId: 1, confederation: "CONMEBOL" },
      { id: 103, name: "Brasil", editionId: 1, confederation: "CONMEBOL" },
      { id: 104, name: "México", editionId: 1, confederation: "CONCACAF" },
      { id: 105, name: "España", editionId: 1, confederation: "UEFA" },
      { id: 106, name: "Francia", editionId: 1, confederation: "UEFA" },
      { id: 201, name: "España", editionId: 2, confederation: "UEFA" },
      { id: 202, name: "Portugal", editionId: 2, confederation: "UEFA" },
      { id: 203, name: "Marruecos", editionId: 2, confederation: "CAF" }
    ],
    groups: [
      { id: 11, code: "A", editionId: 1 },
      { id: 12, code: "B", editionId: 1 },
      { id: 21, code: "A", editionId: 2 }
    ],
    players: [
      { id: 1001, name: "Andrés Gómez", teamId: 101, position: "DELANTERO" },
      { id: 1002, name: "Mateo Ríos", teamId: 101, position: "MEDIOCAMPISTA" },
      { id: 1101, name: "Tomás Vega", teamId: 102, position: "DELANTERO" },
      { id: 1102, name: "Bruno Acosta", teamId: 102, position: "MEDIOCAMPISTA" },
      { id: 1201, name: "Rafael Costa", teamId: 103, position: "DELANTERO" },
      { id: 1202, name: "Lucas Lima", teamId: 103, position: "MEDIOCAMPISTA" },
      { id: 1301, name: "Diego Solís", teamId: 104, position: "DELANTERO" },
      { id: 1302, name: "Nicolás Cruz", teamId: 104, position: "DEFENSA" },
      { id: 1401, name: "Álvaro Ruiz", teamId: 105, position: "DELANTERO" },
      { id: 1501, name: "Hugo Martin", teamId: 106, position: "DELANTERO" },
      { id: 2001, name: "João Silva", teamId: 201, position: "DELANTERO" },
      { id: 2101, name: "Tiago Santos", teamId: 202, position: "DELANTERO" },
      { id: 2201, name: "Youssef Amrani", teamId: 203, position: "DELANTERO" }
    ],
    staff: [
      { id: 1, name: "Carlos Méndez", teamId: 101, role: "DIRECTOR TÉCNICO" },
      { id: 2, name: "Lucía Herrera", teamId: 102, role: "ASISTENTE" },
      { id: 3, name: "Pablo Duarte", teamId: 103, role: "PREPARADOR FÍSICO" },
      { id: 4, name: "Marta León", teamId: 201, role: "DIRECTOR TÉCNICO" }
    ],
    matches: [
      { id: 1, editionId: 1, date: "2026-06-11T18:00", phase: "FASE DE GRUPOS", groupId: 11, stadiumId: 1, localTeamId: 101, visitorTeamId: 102, localGoals: 2, visitorGoals: 1, attendance: 68000, status: "FINALIZADO" },
      { id: 2, editionId: 1, date: "2026-06-12T18:00", phase: "FASE DE GRUPOS", groupId: 11, stadiumId: 2, localTeamId: 103, visitorTeamId: 104, localGoals: 1, visitorGoals: 1, attendance: 54000, status: "FINALIZADO" },
      { id: 3, editionId: 1, date: "2026-06-16T18:00", phase: "FASE DE GRUPOS", groupId: 11, stadiumId: 1, localTeamId: 101, visitorTeamId: 103, localGoals: 0, visitorGoals: 0, attendance: 70000, status: "FINALIZADO" },
      { id: 4, editionId: 1, date: "2026-06-17T18:00", phase: "FASE DE GRUPOS", groupId: 11, stadiumId: 2, localTeamId: 102, visitorTeamId: 104, localGoals: 3, visitorGoals: 2, attendance: 52000, status: "FINALIZADO" },
      { id: 5, editionId: 1, date: "2026-06-22T20:00", phase: "OCTAVOS", groupId: null, stadiumId: 1, localTeamId: 105, visitorTeamId: 106, localGoals: 2, visitorGoals: 0, attendance: 71000, status: "FINALIZADO" },
      { id: 6, editionId: 2, date: "2030-06-08T18:00", phase: "FASE DE GRUPOS", groupId: 21, stadiumId: 3, localTeamId: 201, visitorTeamId: 202, localGoals: 2, visitorGoals: 0, attendance: 62000, status: "FINALIZADO" }
    ],
    stats: [
      { id: 1, matchId: 1, playerId: 1001, minutes: 90, goals: 2, assists: 1, yellow: 0, red: 0, starter: true },
      { id: 2, matchId: 1, playerId: 1101, minutes: 90, goals: 1, assists: 0, yellow: 1, red: 0, starter: true },
      { id: 3, matchId: 2, playerId: 1201, minutes: 90, goals: 1, assists: 1, yellow: 0, red: 0, starter: true },
      { id: 4, matchId: 2, playerId: 1301, minutes: 80, goals: 1, assists: 0, yellow: 1, red: 0, starter: true },
      { id: 5, matchId: 4, playerId: 1101, minutes: 90, goals: 2, assists: 1, yellow: 0, red: 0, starter: true },
      { id: 6, matchId: 4, playerId: 1301, minutes: 90, goals: 2, assists: 0, yellow: 0, red: 0, starter: true },
      { id: 7, matchId: 5, playerId: 1401, minutes: 90, goals: 2, assists: 1, yellow: 0, red: 0, starter: true },
      { id: 8, matchId: 6, playerId: 2001, minutes: 90, goals: 2, assists: 1, yellow: 0, red: 0, starter: true }
    ],
    incidentTypes: [
      { id: 1, name: "GOL", category: "DEPORTIVA" },
      { id: 2, name: "TARJETA AMARILLA", category: "DISCIPLINARIA" },
      { id: 3, name: "TARJETA ROJA", category: "DISCIPLINARIA" },
      { id: 4, name: "CAMBIO", category: "DEPORTIVA" },
      { id: 5, name: "REVISIÓN VAR", category: "TECNOLÓGICA" },
      { id: 6, name: "LESIÓN", category: "OPERATIVA" }
    ],
    incidents: [
      { id: 1, matchId: 1, typeId: 1, minute: 18, teamId: 101, playerId: 1001, description: "Gol de Colombia tras remate desde el área.", reviewed: true },
      { id: 2, matchId: 1, typeId: 5, minute: 44, teamId: null, playerId: null, description: "Revisión de posible fuera de juego.", reviewed: true },
      { id: 3, matchId: 2, typeId: 2, minute: 55, teamId: 104, playerId: 1302, description: "Amonestación por falta táctica.", reviewed: true },
      { id: 4, matchId: 4, typeId: 1, minute: 76, teamId: 102, playerId: 1101, description: "Gol de Argentina para ampliar la ventaja.", reviewed: true },
      { id: 5, matchId: 5, typeId: 4, minute: 64, teamId: 105, playerId: null, description: "Cambio táctico de España.", reviewed: false }
    ]
  };
}

function loadState() {
  try {
    const saved = JSON.parse(localStorage.getItem(STORAGE_KEY));
    if (saved && Array.isArray(saved.matches) && Array.isArray(saved.teams)) {
      const fresh = seedState();
      return Object.fromEntries(Object.keys(fresh).map(key => [
        key,
        Array.isArray(saved[key]) ? saved[key] : fresh[key]
      ]));
    }
  } catch (error) {
    console.warn("No se pudo leer el estado local.", error);
  }
  return seedState();
}

function persist() {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
}

function escapeHtml(value) {
  return String(value ?? "")
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function idOf(value) {
  return Number(value);
}

function findById(collection, id) {
  return state[collection].find(item => Number(item.id) === Number(id));
}

function nextId(collection) {
  return state[collection].reduce((max, item) => Math.max(max, Number(item.id) || 0), 0) + 1;
}

function editionLabel(id) {
  const edition = findById("editions", id);
  return edition ? `${edition.year} · ${edition.name}` : "Sin edición";
}

function teamLabel(id) {
  return findById("teams", id)?.name || "Sin selección";
}

function groupLabel(id) {
  return findById("groups", id)?.code ? `Grupo ${findById("groups", id).code}` : "—";
}

function matchLabel(match) {
  return `${teamLabel(match.localTeamId)} ${match.localGoals}–${match.visitorGoals} ${teamLabel(match.visitorTeamId)}`;
}

function formatDate(value, withTime = true) {
  if (!value) return "—";
  const date = new Date(value);
  if (Number.isNaN(date.valueOf())) return value;
  return new Intl.DateTimeFormat("es-CO", {
    day: "2-digit",
    month: "short",
    year: "numeric",
    ...(withTime ? { hour: "2-digit", minute: "2-digit" } : {})
  }).format(date);
}

function formatNumber(value) {
  return new Intl.NumberFormat("es-CO").format(Number(value) || 0);
}

function statusClass(status) {
  if (status === "CANCELADO") return "cancelled";
  if (status !== "FINALIZADO") return "pending";
  return "";
}

function statusText(status) {
  return status === "FINALIZADO" ? "Finalizado" : status === "CANCELADO" ? "Cancelado" : "Programado";
}

function optionsFor(items, valueKey = "id", labelFn = item => item.name, selected = "") {
  return items.map(item => {
    const value = item[valueKey];
    const isSelected = String(value) === String(selected) ? " selected" : "";
    return `<option value="${escapeHtml(value)}"${isSelected}>${escapeHtml(labelFn(item))}</option>`;
  }).join("");
}

function emptyRow(columns, message = "No hay registros para mostrar.") {
  return `<tr><td colspan="${columns}"><div class="empty-state">${escapeHtml(message)}</div></td></tr>`;
}

function notify(message, type = "success") {
  const toast = $("#toast");
  toast.textContent = message;
  toast.className = `toast visible${type === "error" ? " error" : ""}`;
  window.clearTimeout(notify.timer);
  notify.timer = window.setTimeout(() => {
    toast.className = "toast";
  }, 3000);
}

function setView(view) {
  currentView = view;
  $$(".view").forEach(section => section.classList.toggle("active", section.id === `view-${view}`));
  $$(".nav-link").forEach(button => button.classList.toggle("active", button.dataset.view === view));
  $("#pageTitle").textContent = TITLES[view];
  if (view === "dashboard") renderDashboard();
  if (view === "catalogs") renderCatalogs();
  if (view === "matches") renderMatches();
  if (view === "reports") renderReports();
  if (view === "incidents") renderIncidents();
}

function refreshFilterOptions() {
  const editionOptions = state.editions
    .slice()
    .sort((a, b) => a.year - b.year)
    .map(item => `<option value="${item.id}">${escapeHtml(item.year)} · ${escapeHtml(item.name)}</option>`)
    .join("");
  const teamOptions = state.teams
    .slice()
    .sort((a, b) => a.name.localeCompare(b.name))
    .map(item => `<option value="${item.id}">${escapeHtml(item.name)} · ${escapeHtml(editionLabel(item.editionId))}</option>`)
    .join("");
  const groupOptions = state.groups
    .slice()
    .sort((a, b) => `${a.editionId}${a.code}`.localeCompare(`${b.editionId}${b.code}`))
    .map(item => `<option value="${item.id}">${escapeHtml(groupLabel(item.id))} · ${escapeHtml(editionLabel(item.editionId))}</option>`)
    .join("");

  ["filterEdition", "reportEdition"].forEach(id => {
    const select = $(`#${id}`);
    const old = select.value;
    select.innerHTML = `<option value="all">${id === "filterEdition" ? "Todas" : "Todas"}</option>${editionOptions}`;
    select.value = [...select.options].some(option => option.value === old) ? old : "all";
  });
  ["filterTeam", "reportTeam"].forEach(id => {
    const select = $(`#${id}`);
    const old = select.value;
    select.innerHTML = `<option value="all">Todas</option>${teamOptions}`;
    select.value = [...select.options].some(option => option.value === old) ? old : "all";
  });
  ["filterGroup", "reportGroup"].forEach(id => {
    const select = $(`#${id}`);
    const old = select.value;
    select.innerHTML = `<option value="all">Todos</option>${groupOptions}`;
    select.value = [...select.options].some(option => option.value === old) ? old : "all";
  });
  const phaseOptions = PHASES.map(phase => `<option value="${escapeHtml(phase)}">${escapeHtml(phase)}</option>`).join("");
  ["reportPhase"].forEach(id => {
    const select = $(`#${id}`);
    const old = select.value;
    select.innerHTML = `<option value="all">Todas</option>${phaseOptions}`;
    select.value = [...select.options].some(option => option.value === old) ? old : "all";
  });
}

function readFilters(prefix = "filter") {
  return {
    edition: $(`#${prefix}Edition`).value,
    team: $(`#${prefix}Team`).value,
    group: $(`#${prefix}Group`).value,
    phase: prefix === "filter" ? $(`#${prefix}Phase`).value : $(`#${prefix}Phase`).value
  };
}

function matchesFilters(match, filters) {
  if (filters.edition !== "all" && Number(match.editionId) !== Number(filters.edition)) return false;
  if (filters.team !== "all" && ![match.localTeamId, match.visitorTeamId].includes(Number(filters.team))) return false;
  if (filters.group !== "all" && Number(match.groupId) !== Number(filters.group)) return false;
  if (filters.phase !== "all" && match.phase !== filters.phase) return false;
  return true;
}

function filteredMatches(prefix = "filter") {
  const filters = readFilters(prefix);
  return state.matches
    .filter(match => matchesFilters(match, filters))
    .filter(match => match.status !== "CANCELADO")
    .sort((a, b) => new Date(a.date) - new Date(b.date));
}

function calculateStandings(matches) {
  const rows = new Map();
  const ensure = teamId => {
    const id = Number(teamId);
    if (!rows.has(id)) {
      rows.set(id, {
        teamId: id, played: 0, wins: 0, draws: 0, losses: 0,
        goalsFor: 0, goalsAgainst: 0, points: 0
      });
    }
    return rows.get(id);
  };
  matches.forEach(match => {
    const local = ensure(match.localTeamId);
    const visitor = ensure(match.visitorTeamId);
    if (match.status !== "FINALIZADO") return;
    const localGoals = Number(match.localGoals) || 0;
    const visitorGoals = Number(match.visitorGoals) || 0;
    local.played += 1;
    visitor.played += 1;
    local.goalsFor += localGoals;
    local.goalsAgainst += visitorGoals;
    visitor.goalsFor += visitorGoals;
    visitor.goalsAgainst += localGoals;
    if (localGoals > visitorGoals) {
      local.wins += 1;
      local.points += 3;
      visitor.losses += 1;
    } else if (localGoals < visitorGoals) {
      visitor.wins += 1;
      visitor.points += 3;
      local.losses += 1;
    } else {
      local.draws += 1;
      visitor.draws += 1;
      local.points += 1;
      visitor.points += 1;
    }
  });
  return [...rows.values()]
    .map(row => ({ ...row, difference: row.goalsFor - row.goalsAgainst }))
    .sort((a, b) =>
      b.points - a.points ||
      b.difference - a.difference ||
      b.goalsFor - a.goalsFor ||
      teamLabel(a.teamId).localeCompare(teamLabel(b.teamId))
    );
}

function calculateScorers(matches) {
  const matchIds = new Set(matches.map(match => Number(match.id)));
  const rows = new Map();
  state.stats.forEach(stat => {
    if (!matchIds.has(Number(stat.matchId))) return;
    const player = findById("players", stat.playerId);
    if (!player) return;
    const team = findById("teams", player.teamId);
    if (!rows.has(player.id)) {
      rows.set(player.id, {
        playerId: player.id,
        name: player.name,
        team: team?.name || "—",
        goals: 0,
        assists: 0,
        matches: 0
      });
    }
    const row = rows.get(player.id);
    row.goals += Number(stat.goals) || 0;
    row.assists += Number(stat.assists) || 0;
    row.matches += 1;
  });
  return [...rows.values()].sort((a, b) => b.goals - a.goals || b.assists - a.assists || a.name.localeCompare(b.name));
}

function calculateIncidents(matches) {
  const ids = new Set(matches.map(match => Number(match.id)));
  return state.incidents
    .filter(incident => ids.has(Number(incident.matchId)))
    .sort((a, b) => Number(b.id) - Number(a.id));
}

function renderDashboard() {
  refreshFilterOptions();
  const matches = filteredMatches("filter");
  const standings = calculateStandings(matches);
  const scorers = calculateScorers(matches);
  const incidents = calculateIncidents(matches);
  const goals = matches.reduce((total, match) => total + (Number(match.localGoals) || 0) + (Number(match.visitorGoals) || 0), 0);
  const attendance = matches.filter(match => Number(match.attendance) > 0);
  const averageAttendance = attendance.length
    ? Math.round(attendance.reduce((total, match) => total + Number(match.attendance), 0) / attendance.length)
    : 0;

  $("#kpiGrid").innerHTML = [
    ["Partidos", formatNumber(matches.length), `${matches.filter(match => match.status === "FINALIZADO").length} finalizados`],
    ["Goles", formatNumber(goals), "En el rango filtrado"],
    ["Asistencia media", formatNumber(averageAttendance), "Espectadores por partido"],
    ["Incidencias", formatNumber(incidents.length), "Eventos registrados"]
  ].map(([label, value, detail]) => `
    <article class="kpi-card">
      <div class="kpi-label">${escapeHtml(label)}</div>
      <div class="kpi-value">${escapeHtml(value)}</div>
      <div class="kpi-detail">${escapeHtml(detail)}</div>
    </article>
  `).join("");

  const teamFilter = readFilters("filter").team;
  const visibleStandings = teamFilter === "all"
    ? standings
    : standings.filter(row => row.teamId === Number(teamFilter));
  $("#standingsTable").innerHTML = visibleStandings.length
    ? visibleStandings.map((row, index) => `
      <tr>
        <td class="rank-cell">${index + 1}</td>
        <td><span class="team-cell"><span class="team-dot"></span>${escapeHtml(teamLabel(row.teamId))}</span></td>
        <td>${row.played}</td><td>${row.wins}</td><td>${row.draws}</td><td>${row.losses}</td>
        <td>${row.goalsFor}</td><td>${row.difference > 0 ? "+" : ""}${row.difference}</td>
        <td class="points-cell">${row.points}</td>
      </tr>
    `).join("")
    : emptyRow(9, "No hay posiciones para los filtros seleccionados.");

  $("#scorersList").innerHTML = scorers.length
    ? scorers.slice(0, 5).map((row, index) => `
      <div class="scorer-row">
        <span class="scorer-position">${index + 1}</span>
        <span><span class="scorer-name">${escapeHtml(row.name)}</span><span class="scorer-team">${escapeHtml(row.team)}</span></span>
        <span class="scorer-goals">${row.goals}</span>
      </div>
    `).join("")
    : `<div class="empty-state">No hay estadísticas para este filtro.</div>`;

  const phaseTotals = PHASES.map(phase => ({
    phase,
    goals: matches.filter(match => match.phase === phase)
      .reduce((total, match) => total + Number(match.localGoals || 0) + Number(match.visitorGoals || 0), 0)
  })).filter(item => item.goals > 0 || matches.some(match => match.phase === item.phase));
  const maxGoals = Math.max(...phaseTotals.map(item => item.goals), 1);
  $("#phaseBars").innerHTML = phaseTotals.length
    ? phaseTotals.map(item => `
      <div class="phase-row">
        <span class="phase-name" title="${escapeHtml(item.phase)}">${escapeHtml(item.phase)}</span>
        <span class="phase-track"><span class="phase-fill" style="width:${Math.max(3, item.goals / maxGoals * 100)}%"></span></span>
        <span class="phase-total">${item.goals}</span>
      </div>
    `).join("")
    : `<div class="empty-state">No hay fases para este filtro.</div>`;

  $("#recentIncidents").innerHTML = incidents.length
    ? incidents.slice(0, 5).map(renderIncidentCompact).join("")
    : `<div class="empty-state">No hay incidencias para este filtro.</div>`;
}

function renderIncidentCompact(incident) {
  const type = state.incidentTypes.find(item => Number(item.id) === Number(incident.typeId));
  const match = findById("matches", incident.matchId);
  return `
    <div class="incident-item">
      <span class="incident-minute">${escapeHtml(incident.minute)}'</span>
      <span><span class="incident-title">${escapeHtml(type?.name || "Incidencia")}</span><span class="incident-meta">${escapeHtml(match ? matchLabel(match) : "Partido eliminado")} · ${escapeHtml(incident.description)}</span></span>
      <span class="status-pill${incident.reviewed ? "" : " pending"}">${incident.reviewed ? "Revisada" : "Pendiente"}</span>
    </div>
  `;
}

const catalogDefinitions = {
  editions: {
    title: "Ediciones",
    collection: "editions",
    fields: [
      { key: "year", label: "Año", type: "number", required: true },
      { key: "name", label: "Nombre", required: true },
      { key: "host", label: "Países sede", required: true },
      { key: "motto", label: "Lema", required: true }
    ],
    columns: [
      ["year", "Año"],
      ["name", "Edición"],
      ["host", "Sede"],
      ["motto", "Lema"]
    ]
  },
  venues: {
    title: "Sedes",
    collection: "venues",
    fields: [
      { key: "name", label: "Nombre", required: true },
      { key: "country", label: "País / región", required: true }
    ],
    columns: [["name", "Sede"], ["country", "País / región"]]
  },
  cities: {
    title: "Ciudades",
    collection: "cities",
    fields: [
      { key: "name", label: "Nombre", required: true },
      { key: "venueId", label: "Sede", type: "select", source: "venues", required: true }
    ],
    columns: [["name", "Ciudad"], ["venueId", "Sede"]]
  },
  stadiums: {
    title: "Estadios",
    collection: "stadiums",
    fields: [
      { key: "name", label: "Nombre", required: true },
      { key: "cityId", label: "Ciudad", type: "select", source: "cities", required: true },
      { key: "capacity", label: "Capacidad", type: "number", required: true }
    ],
    columns: [["name", "Estadio"], ["cityId", "Ciudad"], ["capacity", "Aforo"]]
  },
  teams: {
    title: "Selecciones",
    collection: "teams",
    fields: [
      { key: "name", label: "País / selección", required: true },
      { key: "editionId", label: "Edición", type: "select", source: "editions", required: true },
      { key: "confederation", label: "Confederación", type: "select", values: ["AFC", "CAF", "CONCACAF", "CONMEBOL", "OFC", "UEFA", "OTRA"], required: true }
    ],
    columns: [["name", "Selección"], ["editionId", "Edición"], ["confederation", "Confederación"]]
  },
  groups: {
    title: "Grupos",
    collection: "groups",
    fields: [
      { key: "code", label: "Código", required: true },
      { key: "editionId", label: "Edición", type: "select", source: "editions", required: true }
    ],
    columns: [["code", "Código"], ["editionId", "Edición"]]
  },
  players: {
    title: "Jugadores",
    collection: "players",
    fields: [
      { key: "name", label: "Nombre completo", required: true },
      { key: "teamId", label: "Selección", type: "select", source: "teams", required: true },
      { key: "position", label: "Posición", type: "select", values: ["ARQUERO", "DEFENSA", "MEDIOCAMPISTA", "DELANTERO"], required: true }
    ],
    columns: [["name", "Jugador"], ["teamId", "Selección"], ["position", "Posición"]]
  },
  staff: {
    title: "Cuerpo técnico",
    collection: "staff",
    fields: [
      { key: "name", label: "Nombre completo", required: true },
      { key: "teamId", label: "Selección", type: "select", source: "teams", required: true },
      { key: "role", label: "Cargo", type: "select", values: ["DIRECTOR TÉCNICO", "ASISTENTE", "PREPARADOR FÍSICO", "ENTRENADOR DE ARQUEROS", "MÉDICO"], required: true }
    ],
    columns: [["name", "Responsable"], ["teamId", "Selección"], ["role", "Cargo"]]
  }
};

function sourceItems(field) {
  return state[field.source] || [];
}

function labelForField(field, value) {
  if (field.source === "editions") return editionLabel(value);
  if (field.source === "venues") return findById("venues", value)?.name || "—";
  if (field.source === "cities") return findById("cities", value)?.name || "—";
  if (field.source === "teams") return teamLabel(value);
  return value ?? "—";
}

function renderCatalogs() {
  const type = $("#catalogType").value;
  const definition = catalogDefinitions[type];
  const singular = CATALOG_SINGULAR[type];
  $("#catalogFormTitle").textContent = editingCatalog?.type === type ? `Editar ${singular}` : `Nueva ${singular}`;
  $("#catalogTableTitle").textContent = definition.title;
  $("#catalogCount").textContent = `${state[definition.collection].length} registros`;
  $("#cancelCatalogEdit").classList.toggle("hidden", editingCatalog?.type !== type);
  renderCatalogForm(type, definition);
  renderCatalogTable(type, definition);
}

function renderCatalogForm(type, definition) {
  const existing = editingCatalog?.type === type ? findById(definition.collection, editingCatalog.id) : null;
  const fields = definition.fields.map(field => {
    const value = existing?.[field.key] ?? "";
    let control;
    if (field.type === "select") {
      const items = field.source
        ? sourceItems(field).slice().sort((a, b) => labelForField(field, a.id).localeCompare(labelForField(field, b.id)))
        : field.values.map(item => ({ id: item, name: item }));
      control = `<select id="catalog-${field.key}" name="${field.key}" ${field.required ? "required" : ""}>
        <option value="">Seleccionar…</option>
        ${optionsFor(items, "id", item => field.source ? labelForField(field, item.id) : item.name, value)}
      </select>`;
    } else {
      control = `<input id="catalog-${field.key}" name="${field.key}" type="${field.type || "text"}" value="${escapeHtml(value)}" ${field.required ? "required" : ""}${field.type === "number" ? ' min="0"' : ""}>`;
    }
    return `<label>${escapeHtml(field.label)}${control}</label>`;
  }).join("");
  $("#catalogForm").innerHTML = `
    <div class="form-grid">${fields}</div>
    <div class="form-actions">
      <button class="button" type="submit">${existing ? "Guardar cambios" : "Crear registro"}</button>
      ${existing ? '<button id="cancelInlineEdit" class="button button-secondary" type="button">Cancelar</button>' : ""}
    </div>
  `;
  $("#catalogForm").onsubmit = event => {
    event.preventDefault();
    saveCatalog(type, new FormData(event.currentTarget));
  };
  $("#cancelInlineEdit")?.addEventListener("click", cancelCatalogEdit);
}

function saveCatalog(type, formData) {
  const definition = catalogDefinitions[type];
  const item = {};
  definition.fields.forEach(field => {
    const raw = formData.get(field.key);
    item[field.key] = field.type === "number" ? Number(raw) : raw;
  });
  const editing = editingCatalog?.type === type ? findById(definition.collection, editingCatalog.id) : null;
  if (editing) {
    Object.assign(editing, item);
    notify(`${CATALOG_SINGULAR[type]} actualizado.`);
  } else {
    item.id = nextId(definition.collection);
    state[definition.collection].push(item);
    notify(`${CATALOG_SINGULAR[type]} creado.`);
  }
  editingCatalog = null;
  persist();
  refreshFilterOptions();
  renderCatalogs();
  renderDashboard();
}

function renderCatalogTable(type, definition) {
  $("#catalogTableHead").innerHTML = `<tr>${definition.columns.map(([, label]) => `<th>${escapeHtml(label)}</th>`).join("")}<th></th></tr>`;
  const rows = state[definition.collection];
  $("#catalogTableBody").innerHTML = rows.length
    ? rows.map(item => `
      <tr>
        ${definition.columns.map(([key]) => `<td>${escapeHtml(displayCatalogValue(definition.fields.find(field => field.key === key), item[key]))}</td>`).join("")}
        <td><div class="action-buttons">
          <button class="row-action" data-action="edit-catalog" data-type="${type}" data-id="${item.id}" type="button">Editar</button>
          <button class="row-action delete" data-action="delete-catalog" data-type="${type}" data-id="${item.id}" type="button">Borrar</button>
        </div></td>
      </tr>
    `).join("")
    : emptyRow(definition.columns.length + 1);
}

function displayCatalogValue(field, value) {
  if (field?.source) return labelForField(field, value);
  if (field?.key === "capacity") return formatNumber(value);
  return value;
}

function dependencyMessage(type, id) {
  const numericId = Number(id);
  if (type === "editions" && (state.teams.some(item => item.editionId === numericId) || state.groups.some(item => item.editionId === numericId))) {
    return "La edición tiene selecciones o grupos asociados.";
  }
  if (type === "venues" && state.cities.some(item => item.venueId === numericId)) return "La sede tiene ciudades asociadas.";
  if (type === "cities" && state.stadiums.some(item => item.cityId === numericId)) return "La ciudad tiene estadios asociados.";
  if (type === "stadiums" && state.matches.some(item => item.stadiumId === numericId)) return "El estadio tiene partidos asociados.";
  if (type === "teams" && (state.matches.some(item => item.localTeamId === numericId || item.visitorTeamId === numericId) || state.players.some(item => item.teamId === numericId))) {
    return "La selección tiene partidos o jugadores asociados.";
  }
  if (type === "groups" && state.matches.some(item => item.groupId === numericId)) return "El grupo tiene partidos asociados.";
  if (type === "players" && (state.stats.some(item => item.playerId === numericId) || state.incidents.some(item => item.playerId === numericId))) {
    return "El jugador tiene estadísticas o incidencias asociadas.";
  }
  return "";
}

function handleCatalogAction(button) {
  const { action, type, id } = button.dataset;
  const definition = catalogDefinitions[type];
  if (action === "edit-catalog") {
    editingCatalog = { type, id: Number(id) };
    renderCatalogs();
    return;
  }
  if (action === "delete-catalog") {
    const dependency = dependencyMessage(type, id);
    if (dependency) {
      notify(dependency, "error");
      return;
    }
    state[definition.collection] = state[definition.collection].filter(item => Number(item.id) !== Number(id));
    editingCatalog = null;
    persist();
    refreshFilterOptions();
    renderCatalogs();
    renderDashboard();
    notify("Registro eliminado.");
  }
}

function cancelCatalogEdit() {
  editingCatalog = null;
  renderCatalogs();
}

function renderMatchForm() {
  const editionOptions = optionsFor(state.editions, "id", item => editionLabel(item.id), 1);
  const stadiumOptions = optionsFor(state.stadiums, "id", item => `${item.name} · ${findById("cities", item.cityId)?.name || ""}`);
  const teamOptions = optionsFor(state.teams, "id", item => `${item.name} · ${editionLabel(item.editionId)}`);
  const groupOptions = optionsFor(state.groups, "id", item => `${groupLabel(item.id)} · ${editionLabel(item.editionId)}`);
  $("#matchForm").innerHTML = `
    <div class="form-grid">
      <label>Edición<select name="editionId" required><option value="">Seleccionar…</option>${editionOptions}</select></label>
      <label>Fecha y hora<input name="date" type="datetime-local" value="2026-07-01T18:00" required></label>
      <label>Fase<select name="phase" required>${PHASES.map(phase => `<option>${escapeHtml(phase)}</option>`).join("")}</select></label>
      <label>Grupo<select name="groupId"><option value="">Sin grupo</option>${groupOptions}</select></label>
      <label>Estadio<select name="stadiumId" required><option value="">Seleccionar…</option>${stadiumOptions}</select></label>
      <label>Local<select name="localTeamId" required><option value="">Seleccionar…</option>${teamOptions}</select></label>
      <label>Visitante<select name="visitorTeamId" required><option value="">Seleccionar…</option>${teamOptions}</select></label>
      <div class="form-grid" style="grid-template-columns:1fr 1fr;gap:8px">
        <label>Goles local<input name="localGoals" type="number" min="0" value="0" required></label>
        <label>Goles visitante<input name="visitorGoals" type="number" min="0" value="0" required></label>
      </div>
      <label>Asistencia<input name="attendance" type="number" min="0" value="0" required></label>
      <label>Estado<select name="status"><option>PROGRAMADO</option><option selected>FINALIZADO</option><option>EN JUEGO</option><option>CANCELADO</option></select></label>
      <button class="button" type="submit">Registrar partido</button>
    </div>
  `;
  $("#matchForm").onsubmit = event => {
    event.preventDefault();
    saveMatch(new FormData(event.currentTarget));
  };
}

function saveMatch(formData) {
  const match = {
    id: nextId("matches"),
    editionId: Number(formData.get("editionId")),
    date: formData.get("date"),
    phase: formData.get("phase"),
    groupId: formData.get("groupId") ? Number(formData.get("groupId")) : null,
    stadiumId: Number(formData.get("stadiumId")),
    localTeamId: Number(formData.get("localTeamId")),
    visitorTeamId: Number(formData.get("visitorTeamId")),
    localGoals: Number(formData.get("localGoals")),
    visitorGoals: Number(formData.get("visitorGoals")),
    attendance: Number(formData.get("attendance")),
    status: formData.get("status")
  };
  if (!match.editionId || !match.localTeamId || !match.visitorTeamId || match.localTeamId === match.visitorTeamId) {
    notify("Selecciona dos equipos distintos de la misma edición.", "error");
    return;
  }
  const local = findById("teams", match.localTeamId);
  const visitor = findById("teams", match.visitorTeamId);
  if (!local || !visitor || local.editionId !== match.editionId || visitor.editionId !== match.editionId) {
    notify("Los equipos deben pertenecer a la edición del partido.", "error");
    return;
  }
  const stadium = findById("stadiums", match.stadiumId);
  if (!stadium || Number(match.attendance) > Number(stadium.capacity)) {
    notify("La asistencia no puede superar el aforo del estadio.", "error");
    return;
  }
  if (match.groupId && findById("groups", match.groupId)?.editionId !== match.editionId) {
    notify("El grupo debe pertenecer a la edición del partido.", "error");
    return;
  }
  state.matches.push(match);
  persist();
  renderMatches();
  refreshFilterOptions();
  renderDashboard();
  notify("Partido registrado correctamente.");
}

function renderMatches() {
  renderMatchForm();
  const matches = state.matches.slice().sort((a, b) => new Date(b.date) - new Date(a.date));
  $("#matchCount").textContent = `${matches.length} partidos`;
  $("#matchesTable").innerHTML = matches.length
    ? matches.map(match => `
      <tr>
        <td>${escapeHtml(formatDate(match.date))}</td>
        <td>${escapeHtml(match.phase)}</td>
        <td><strong>${escapeHtml(teamLabel(match.localTeamId))}</strong></td>
        <td><span class="match-score">${match.localGoals}<span class="score-separator">–</span>${match.visitorGoals}</span></td>
        <td><strong>${escapeHtml(teamLabel(match.visitorTeamId))}</strong></td>
        <td><span class="status-pill ${statusClass(match.status)}">${escapeHtml(statusText(match.status))}</span></td>
        <td><button class="row-action delete" data-action="delete-match" data-id="${match.id}" type="button">Borrar</button></td>
      </tr>
    `).join("")
    : emptyRow(7, "Todavía no hay partidos registrados.");
  renderStatsForm();
  renderStatsTable();
}

function renderStatsForm() {
  const matchOptions = optionsFor(state.matches.filter(match => match.status !== "CANCELADO"), "id", match => matchLabel(match));
  const playerOptions = optionsFor(state.players, "id", item => `${item.name} · ${teamLabel(item.teamId)}`);
  $("#statsForm").innerHTML = `
    <label>Partido<select name="matchId" required><option value="">Seleccionar…</option>${matchOptions}</select></label>
    <label>Jugador<select name="playerId" required><option value="">Seleccionar…</option>${playerOptions}</select></label>
    <label>Minutos<input name="minutes" type="number" min="0" max="130" value="90" required></label>
    <label>Goles<input name="goals" type="number" min="0" value="0" required></label>
    <label>Asistencias<input name="assists" type="number" min="0" value="0" required></label>
    <label>TA<input name="yellow" type="number" min="0" max="2" value="0" required></label>
    <label>TR<input name="red" type="number" min="0" max="1" value="0" required></label>
    <button class="button" type="submit">Guardar estadística</button>
  `;
  $("#statsForm").onsubmit = event => {
    event.preventDefault();
    saveStats(new FormData(event.currentTarget));
  };
}

function saveStats(formData) {
  const matchId = Number(formData.get("matchId"));
  const playerId = Number(formData.get("playerId"));
  const player = findById("players", playerId);
  const match = findById("matches", matchId);
  if (!match || !player || ![match.localTeamId, match.visitorTeamId].includes(player.teamId)) {
    notify("El jugador debe pertenecer a una selección del partido.", "error");
    return;
  }
  if (state.stats.some(item => Number(item.matchId) === matchId && Number(item.playerId) === playerId)) {
    notify("Ese jugador ya tiene una estadística para el partido.", "error");
    return;
  }
  state.stats.push({
    id: nextId("stats"),
    matchId,
    playerId,
    minutes: Number(formData.get("minutes")),
    goals: Number(formData.get("goals")),
    assists: Number(formData.get("assists")),
    yellow: Number(formData.get("yellow")),
    red: Number(formData.get("red")),
    starter: true
  });
  persist();
  renderMatches();
  renderDashboard();
  notify("Estadística guardada.");
}

function renderStatsTable() {
  const rows = state.stats.slice().sort((a, b) => b.id - a.id);
  $("#statsTable").innerHTML = rows.length
    ? rows.map(stat => {
      const player = findById("players", stat.playerId);
      const match = findById("matches", stat.matchId);
      return `<tr>
        <td><strong>${escapeHtml(player?.name || "—")}</strong></td>
        <td>${escapeHtml(match ? matchLabel(match) : "—")}</td>
        <td>${stat.minutes}</td><td>${stat.goals}</td><td>${stat.assists}</td><td>${stat.yellow}</td><td>${stat.red}</td>
        <td><button class="row-action delete" data-action="delete-stat" data-id="${stat.id}" type="button">Borrar</button></td>
      </tr>`;
    }).join("")
    : emptyRow(8, "Todavía no hay estadísticas registradas.");
}

function handleMatchAction(button) {
  const id = Number(button.dataset.id);
  if (button.dataset.action === "delete-stat") {
    state.stats = state.stats.filter(item => Number(item.id) !== id);
    persist();
    renderMatches();
    renderDashboard();
    notify("Estadística eliminada.");
    return;
  }
  if (button.dataset.action === "delete-match") {
    if (state.stats.some(item => Number(item.matchId) === id) || state.incidents.some(item => Number(item.matchId) === id)) {
      notify("No se puede borrar un partido con estadísticas o incidencias.", "error");
      return;
    }
    state.matches = state.matches.filter(item => Number(item.id) !== id);
    persist();
    renderMatches();
    refreshFilterOptions();
    renderDashboard();
    notify("Partido eliminado.");
  }
}

function renderIncidentForm() {
  const matchOptions = optionsFor(state.matches, "id", match => matchLabel(match));
  const typeOptions = optionsFor(state.incidentTypes, "id", item => item.name);
  const teamOptions = optionsFor(state.teams, "id", item => item.name);
  const playerOptions = optionsFor(state.players, "id", item => `${item.name} · ${teamLabel(item.teamId)}`);
  $("#incidentForm").innerHTML = `
    <div class="form-grid">
      <label>Partido<select name="matchId" required><option value="">Seleccionar…</option>${matchOptions}</select></label>
      <label>Tipo<select name="typeId" required><option value="">Seleccionar…</option>${typeOptions}</select></label>
      <label>Minuto<input name="minute" type="number" min="0" max="130" value="1" required></label>
      <label>Selección<select name="teamId"><option value="">No aplica</option>${teamOptions}</select></label>
      <label>Jugador<select name="playerId"><option value="">No aplica</option>${playerOptions}</select></label>
      <label>Descripción<textarea name="description" required placeholder="Describe la incidencia…"></textarea></label>
      <label>Estado<select name="reviewed"><option value="false">Pendiente</option><option value="true">Revisada</option></select></label>
      <button class="button" type="submit">Registrar incidencia</button>
    </div>
  `;
  $("#incidentForm").onsubmit = event => {
    event.preventDefault();
    saveIncident(new FormData(event.currentTarget));
  };
}

function saveIncident(formData) {
  const matchId = Number(formData.get("matchId"));
  const teamId = formData.get("teamId") ? Number(formData.get("teamId")) : null;
  const playerId = formData.get("playerId") ? Number(formData.get("playerId")) : null;
  const match = findById("matches", matchId);
  if (!match) {
    notify("Selecciona un partido válido.", "error");
    return;
  }
  if (teamId && ![match.localTeamId, match.visitorTeamId].includes(teamId)) {
    notify("La selección no participa en el partido.", "error");
    return;
  }
  if (playerId && teamId && findById("players", playerId)?.teamId !== teamId) {
    notify("El jugador no pertenece a la selección elegida.", "error");
    return;
  }
  state.incidents.push({
    id: nextId("incidents"),
    matchId,
    typeId: Number(formData.get("typeId")),
    minute: Number(formData.get("minute")),
    teamId,
    playerId,
    description: formData.get("description").trim(),
    reviewed: formData.get("reviewed") === "true"
  });
  persist();
  renderIncidents();
  renderDashboard();
  renderReports();
  notify("Incidencia registrada.");
}

function renderIncidents() {
  renderIncidentForm();
  const incidents = calculateIncidents(state.matches);
  $("#incidentCount").textContent = `${incidents.length} registros`;
  $("#incidentsTable").innerHTML = incidents.length
    ? incidents.map(incident => {
      const type = state.incidentTypes.find(item => Number(item.id) === Number(incident.typeId));
      const match = findById("matches", incident.matchId);
      return `<tr>
        <td><strong>${incident.minute}'</strong></td>
        <td>${escapeHtml(type?.name || "—")}</td>
        <td>${escapeHtml(match ? matchLabel(match) : "—")}</td>
        <td>${escapeHtml(incident.teamId ? teamLabel(incident.teamId) : "—")}</td>
        <td>${escapeHtml(incident.description)}</td>
        <td><span class="status-pill${incident.reviewed ? "" : " pending"}">${incident.reviewed ? "Revisada" : "Pendiente"}</span></td>
        <td><button class="row-action delete" data-action="delete-incident" data-id="${incident.id}" type="button">Borrar</button></td>
      </tr>`;
    }).join("")
    : emptyRow(7, "Todavía no hay incidencias registradas.");
}

function handleIncidentAction(button) {
  if (button.dataset.action !== "delete-incident") return;
  state.incidents = state.incidents.filter(item => Number(item.id) !== Number(button.dataset.id));
  persist();
  renderIncidents();
  renderDashboard();
  renderReports();
  notify("Incidencia eliminada.");
}

function renderReports() {
  refreshFilterOptions();
  const matches = filteredMatches("report");
  const scorers = calculateScorers(matches);
  const incidents = calculateIncidents(matches);
  $("#reportResults").innerHTML = matches.length
    ? matches.map(match => `
      <tr>
        <td>${escapeHtml(formatDate(match.date))}</td>
        <td>${escapeHtml(match.phase)}</td>
        <td>${escapeHtml(groupLabel(match.groupId))}</td>
        <td><strong>${escapeHtml(teamLabel(match.localTeamId))}</strong></td>
        <td><span class="match-score">${match.localGoals}–${match.visitorGoals}</span></td>
        <td><strong>${escapeHtml(teamLabel(match.visitorTeamId))}</strong></td>
        <td>${incidents.filter(item => Number(item.matchId) === Number(match.id)).length}</td>
      </tr>
    `).join("")
    : emptyRow(7, "No hay resultados para los filtros seleccionados.");
  $("#reportScorers").innerHTML = scorers.length
    ? scorers.slice(0, 12).map(row => `<tr><td><strong>${escapeHtml(row.name)}</strong></td><td>${escapeHtml(row.team)}</td><td class="points-cell">${row.goals}</td></tr>`).join("")
    : emptyRow(3, "No hay goleadores.");
  $("#reportIncidents").innerHTML = incidents.length
    ? incidents.slice(0, 12).map(renderIncidentCompact).join("")
    : `<div class="empty-state">No hay incidencias para este filtro.</div>`;
}

function handleGlobalAction(event) {
  const button = event.target.closest("button[data-action]");
  if (!button) return;
  if (button.dataset.action.includes("catalog")) {
    handleCatalogAction(button);
  } else if (button.dataset.action.includes("match") || button.dataset.action === "delete-stat") {
    handleMatchAction(button);
  } else if (button.dataset.action.includes("incident")) {
    handleIncidentAction(button);
  }
}

function exportData() {
  const blob = new Blob([JSON.stringify(state, null, 2)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = "fifa-entrega-3-datos.json";
  link.click();
  URL.revokeObjectURL(url);
  notify("Datos exportados.");
}

function resetData() {
  if (!window.confirm("¿Restablecer los datos de demostración?")) return;
  const fresh = seedState();
  Object.keys(state).forEach(key => delete state[key]);
  Object.assign(state, fresh);
  editingCatalog = null;
  persist();
  refreshFilterOptions();
  renderAll();
  notify("Datos de demostración restablecidos.");
}

function renderAll() {
  $("#currentDate").textContent = new Intl.DateTimeFormat("es-CO", { dateStyle: "medium" }).format(new Date());
  refreshFilterOptions();
  renderDashboard();
  renderCatalogs();
  renderMatches();
  renderIncidents();
  renderReports();
  setView(currentView);
}

function init() {
  $$(".nav-link").forEach(button => button.addEventListener("click", () => setView(button.dataset.view)));
  $$("[data-view-link]").forEach(button => button.addEventListener("click", () => setView(button.dataset.viewLink)));
  $$("[data-filter]").forEach(select => select.addEventListener("change", renderDashboard));
  $$("[data-report-filter]").forEach(select => select.addEventListener("change", renderReports));
  $("#catalogType").addEventListener("change", () => {
    editingCatalog = null;
    renderCatalogs();
  });
  $("#cancelCatalogEdit").addEventListener("click", cancelCatalogEdit);
  $("#exportData").addEventListener("click", exportData);
  $("#resetData").addEventListener("click", resetData);
  document.addEventListener("click", handleGlobalAction);
  renderAll();
}

init();
