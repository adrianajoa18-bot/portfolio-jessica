<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Mercado asegurador argentino – Jessica Ojeda Arenas</title>
<meta name="description" content="Dashboard interactivo de índices de gestión de 175 aseguradoras argentinas (SSN), 2024-2025.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="../../assets/proyecto.css">
<style>
  .semaforo { display: grid; gap: 4px; margin-top: 10px; font-size: 0.84rem; }
  .sem { display: inline-block; width: 10px; height: 10px; border-radius: 50%; margin-right: 6px; vertical-align: middle; }
  .v { background: #2f855a; } .a { background: #d69e2e; } .r { background: #c53030; }
  td.v, td.a, td.r { background: none; }
  td.cv { color: #2f855a; font-weight: 600; } td.ca { color: #b7791f; font-weight: 600; } td.cr { color: #c53030; font-weight: 600; }
  .ficha-head { display: flex; flex-wrap: wrap; gap: 12px; align-items: center; margin-bottom: 14px; }
  .ficha-head input { flex: 1 1 260px; font-family: inherit; font-size: 0.95rem; padding: 10px 14px; border-radius: 10px; border: 1px solid var(--borde); }
  .pill { font-size: 0.8rem; background: #eef3f9; color: var(--navy-2); padding: 3px 10px; border-radius: 999px; font-weight: 600; }
  .rank li { display: flex; justify-content: space-between; gap: 10px; padding: 8px 0; border-bottom: 1px solid var(--borde); font-size: 0.92rem; }
  .rank { list-style: none; }
  .rank .val { font-weight: 600; font-variant-numeric: tabular-nums; }
  .kpi .delta { font-size: 0.8rem; font-weight: 600; margin-top: 2px; }
</style>
</head>
<body>

<nav class="topbar"><div class="wrap">
  <a class="marca" href="../../index.html">Jessica Ojeda</a>
  <a href="../../index.html#projects">← Volver a proyectos</a>
</div></nav>

<header class="cabecera"><div class="wrap">
  <span class="categoria">Análisis de datos · Mercado asegurador</span>
  <h1>Indicadores de gestión del mercado asegurador argentino</h1>
  <p class="bajada">¿Qué aseguradoras ganan plata, cuáles pierden y por qué? Analizo los índices de gestión que publica la
    Superintendencia de Seguros de la Nación (SSN) para <strong>175 aseguradoras</strong> en cuatro balances de 2024 y 2025.</p>
  <div class="etiquetas"><span>Excel</span><span>Power Query</span><span>Tablas dinámicas</span><span>Dashboard</span><span>Ratios técnicos</span></div>
  <div class="botones">
    <a class="btn lleno" href="#ficha">Buscar una aseguradora</a>
    <a class="btn" href="../../Dashboard%20Jessica%20Ojeda%20FINAL1.xlsb" download>Descargar el Excel original</a>
  </div>
</div></header>

<main class="wrap">

<section>
  <h2>Qué mide cada indicador</h2>
  <p class="intro">Todos los índices están expresados como <strong>porcentaje de las primas</strong>. Definí un semáforo para leerlos rápido:</p>
  <div class="grid g4">
    <div class="card"><h3>Siniestralidad</h3><p class="nota" style="margin-top:0">Siniestros devengados / primas devengadas. Cuánto de lo que cobra se va en pagar siniestros.</p>
      <div class="semaforo"><span><i class="sem v"></i>&lt; 70 % buena gestión del riesgo</span><span><i class="sem a"></i>70 – 100 %</span><span><i class="sem r"></i>&gt; 100 % pérdida técnica</span></div></div>
    <div class="card"><h3>Gastos de producción</h3><p class="nota" style="margin-top:0">Comisiones y costos de venta / primas emitidas.</p>
      <div class="semaforo"><span><i class="sem v"></i>&lt; 20 % eficiente</span><span><i class="sem a"></i>20 – 35 % normal</span><span><i class="sem r"></i>&gt; 35 % estructura comercial cara</span></div></div>
    <div class="card"><h3>Gastos de explotación</h3><p class="nota" style="margin-top:0">Gastos de administración y estructura / primas emitidas.</p>
      <div class="semaforo"><span><i class="sem v"></i>&lt; 30 % buena gestión</span><span><i class="sem a"></i>30 – 50 %</span><span><i class="sem r"></i>&gt; 50 % estructura pesada</span></div></div>
    <div class="card"><h3>Resultado del ejercicio</h3><p class="nota" style="margin-top:0">Ganancia o pérdida final / primas emitidas. Incluye el resultado financiero de las inversiones.</p>
      <div class="semaforo"><span><i class="sem v"></i>Positivo: gana dinero</span><span><i class="sem r"></i>Negativo: pierde dinero</span></div></div>
  </div>
</section>

<section>
  <h2>El mercado en su conjunto</h2>
  <p class="intro">Totales del mercado publicados por la SSN. El ejercicio de las aseguradoras cierra el 30 de junio: el balance de septiembre cubre 3 meses y el de marzo 9, por eso conviene comparar <strong>el mismo mes entre años</strong>.</p>
  <div class="grid g4" id="kpisMercado"></div>
  <div class="card" style="margin-top:18px">
    <div class="grafico"><canvas id="gMercado"></canvas></div>
    <div class="insight"><strong>Lectura:</strong> el mercado en su conjunto <strong>perdió plata en los cuatro balances</strong>. La siniestralidad subió fuerte entre marzo 2024 (36 %) y 2025 (58 %), y la mejora en gastos no alcanzó a compensarla.</div>
  </div>
</section>

<section>
  <h2>¿Qué ramos son rentables?</h2>
  <div class="card">
    <div class="controles"><span class="nota" style="margin:0">Balance:</span><div class="chips" id="chipsPerTipo"></div></div>
    <div class="grafico"><canvas id="gTipo"></canvas></div>
    <div class="insight"><strong>Lectura:</strong> el <strong>transporte público de pasajeros</strong> pierde en todos los períodos: su siniestralidad supera el 160 % de las primas. <strong>Vida</strong> y <strong>patrimoniales</strong> mejoraron en 2025, mientras que <strong>retiro</strong> empeoró en septiembre 2025.</div>
  </div>
</section>

<section>
  <h2>Mapa de aseguradoras</h2>
  <p class="intro">Cada punto es una aseguradora. A la derecha, más siniestros; arriba, más gastos. Las que están lejos del origen tienen menos margen para ganar dinero.</p>
  <div class="card">
    <div class="controles">
      <select id="selPerMapa"></select>
      <select id="selTipoMapa"></select>
    </div>
    <div class="grafico alto"><canvas id="gMapa"></canvas></div>
    <p class="nota">Se muestran los valores entre −50 % y 200 % para que el gráfico sea legible; los casos extremos se ven en la ficha de cada entidad.</p>
  </div>
</section>

<section id="ficha">
  <h2>Ficha de una aseguradora</h2>
  <div class="card">
    <div class="ficha-head">
      <input list="listaEnt" id="buscador" placeholder="Escribí el nombre de una aseguradora…" autocomplete="off">
      <datalist id="listaEnt"></datalist>
      <span class="pill" id="fichaTipo"></span>
    </div>
    <div class="tabla-wrap"><table id="tFicha"></table></div>
    <p class="nota">Colores según el semáforo. "s/d": sin dato en el balance publicado.</p>
  </div>
</section>

<section>
  <h2>Ranking por resultado</h2>
  <div class="card">
    <div class="controles"><select id="selPerRank"></select><select id="selTipoRank"></select></div>
    <div class="grid g2">
      <div><h3>Mejores 5</h3><ol class="rank" id="rankTop"></ol></div>
      <div><h3>Peores 5</h3><ol class="rank" id="rankBot"></ol></div>
    </div>
    <p class="nota">Ojo al leer los extremos: en aseguradoras con primas muy chicas, un resultado moderado en pesos puede representar varias veces sus primas. Por eso el ranking conviene leerlo junto con el tamaño de cada entidad.</p>
  </div>
</section>

<section>
  <h2>Hallazgos y calidad de datos</h2>
  <div class="grid g2">
    <div class="card"><h3>Hallazgos</h3><ul class="lista">
      <li>El mercado total tuvo <strong>resultado negativo</strong> en los cuatro balances, empujado por la suba de la siniestralidad.</li>
      <li>Aun así, la proporción de aseguradoras con ganancia subió de <strong id="pos1"></strong> en septiembre 2024 a <strong id="pos2"></strong> en septiembre 2025.</li>
      <li>El ramo <strong>transporte público de pasajeros</strong> tiene pérdida estructural: los siniestros superan las primas.</li>
      <li>Una siniestralidad alta no siempre implica pérdida: el <strong>resultado financiero</strong> de las inversiones compensa en varias entidades.</li>
    </ul></div>
    <div class="card"><h3>Calidad de datos</h3><ul class="lista">
      <li>Las 15 ART con balance en septiembre 2025 tenían exactamente los mismos valores que en septiembre 2024. Lo traté como un error de carga y excluí ese período para ese ramo.</li>
      <li>Dos entidades aparecían duplicadas en un mismo balance con valores distintos: se excluyeron esas filas.</li>
      <li>Los valores "///" del archivo de la SSN (sin dato) se tratan como faltantes, no como cero.</li>
    </ul></div>
  </div>
  <p class="nota">Fuente: SSN – Indicadores del Mercado Asegurador, Anexo I (índices de gestión). Balances a marzo y septiembre de 2024 y 2025.</p>
</section>

</main>

<footer><div class="wrap">
  <span>© 2026 Jessica Ojeda Arenas</span>
  <a href="../../index.html">Volver al portfolio</a>
</div></footer>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.min.js"></script>
<script src="datos.js"></script>
<script>
const D = window.DATOS;
const C = { navy: '#0a3d62', azul: '#2b6cb0', acento: '#e67e22', rosa: '#c2185b', gris: '#d9e2ec', verde: '#2f855a', rojo: '#c53030', suave: '#5b6b7d' };
Chart.defaults.font.family = "'Poppins', sans-serif";
Chart.defaults.color = C.suave;
Chart.defaults.plugins.legend.labels.boxWidth = 12;

const IDX = { cedida: 0, sinies: 1, gprod: 2, gexpl: 3, gtot: 4, res: 5 };
const NOMBRE = { cedida: 'Primas cedidas', sinies: 'Siniestralidad', gprod: 'Gastos de producción', gexpl: 'Gastos de explotación', gtot: 'Gastos totales', res: 'Resultado del ejercicio' };
const MESES = { '03': 'Mar', '09': 'Sep' };
const etiquetaPer = p => `${MESES[p.slice(5)]} ${p.slice(0, 4)}`;
const fmt = (x, d = 1) => x == null ? 's/d' : x.toLocaleString('es-AR', { minimumFractionDigits: d, maximumFractionDigits: d });
const TIPOS = [...new Set(D.entidades.map(e => e.t))].sort();
const SOC = { A: 'Sociedad anónima', C: 'Cooperativa / mutual', E: 'Sucursal extranjera', O: 'Organismo oficial' };
const ultimo = D.periodos[D.periodos.length - 1];

function color(metrica, v) {
  if (v == null) return '';
  const u = { sinies: [70, 100], gprod: [20, 35], gexpl: [30, 50], gtot: [70, 100] }[metrica];
  if (metrica === 'res') return v > 0 ? 'cv' : 'cr';
  if (!u) return '';
  return v < u[0] ? 'cv' : v <= u[1] ? 'ca' : 'cr';
}
const valor = (e, p, m) => e.d[p] ? e.d[p][IDX[m]] : null;
const opcionesSelect = (el, items, sel) => { el.innerHTML = items.map(([v, t]) => `<option value="${v}" ${v === sel ? 'selected' : ''}>${t}</option>`).join(''); };

// KPIs del mercado (sep 2025 vs sep 2024)
const M = D.mercado, ant = '2024-09';
document.getElementById('kpisMercado').innerHTML = ['sinies', 'gtot', 'gprod', 'res'].map(m => {
  const dif = M[ultimo][m] - M[ant][m];
  const mejor = (m === 'res') ? dif > 0 : dif < 0;
  return `<div class="card kpi"><div class="valor">${fmt(M[ultimo][m])} %</div><div class="nombre">${NOMBRE[m]} · Sep 2025</div>
    <div class="delta" style="color:${mejor ? C.verde : C.rojo}">${dif > 0 ? '+' : ''}${fmt(dif)} p.p. vs. Sep 2024</div></div>`;
}).join('');

new Chart(document.getElementById('gMercado'), {
  type: 'line',
  data: { labels: D.periodos.map(etiquetaPer), datasets: [
    { label: 'Siniestralidad', data: D.periodos.map(p => M[p].sinies), borderColor: C.rosa, backgroundColor: C.rosa, tension: 0.25 },
    { label: 'Gastos totales', data: D.periodos.map(p => M[p].gtot), borderColor: C.azul, backgroundColor: C.azul, tension: 0.25 },
    { label: 'Resultado del ejercicio', data: D.periodos.map(p => M[p].res), borderColor: C.acento, backgroundColor: C.acento, tension: 0.25, borderWidth: 3 },
  ] },
  options: { maintainAspectRatio: false, interaction: { mode: 'index', intersect: false },
    scales: { y: { ticks: { callback: x => x + ' %' } }, x: { grid: { display: false } } },
    plugins: { tooltip: { callbacks: { label: c => ` ${c.dataset.label}: ${fmt(c.raw)} %` } } } },
});

// Por tipo de seguro
const mediana = a => { const s = a.filter(x => x != null).sort((x, y) => x - y); if (!s.length) return null; const k = Math.floor(s.length / 2); return s.length % 2 ? s[k] : (s[k - 1] + s[k]) / 2; };
let gTipo;
function dibujarTipo(p) {
  const filas = TIPOS.map(t => {
    const vals = D.entidades.filter(e => e.t === t).map(e => valor(e, p, 'res')).filter(v => v != null);
    return { t, n: vals.length, pos: vals.length ? vals.filter(v => v > 0).length / vals.length * 100 : null, med: mediana(vals) };
  });
  const data = { labels: filas.map(f => f.t), datasets: [
    { label: '% de aseguradoras con ganancia', data: filas.map(f => f.pos), backgroundColor: filas.map(f => f.pos == null ? C.gris : f.pos >= 50 ? C.verde : C.rojo), borderRadius: 6 },
  ] };
  const opciones = { maintainAspectRatio: false, indexAxis: 'y',
    scales: { x: { min: 0, max: 100, ticks: { callback: x => x + ' %' } }, y: { grid: { display: false } } },
    plugins: { legend: { display: false }, tooltip: { callbacks: { label: c => {
      const f = filas[c.dataIndex]; return f.n ? [` ${fmt(f.pos, 0)} % con ganancia (${f.n} entidades)`, ` Resultado mediano: ${fmt(f.med)} % de las primas`] : ' Sin datos confiables en este período'; } } } } };
  if (gTipo) { gTipo.data = data; gTipo.update(); } else gTipo = new Chart(document.getElementById('gTipo'), { type: 'bar', data, options: opciones });
}
const chipsPer = document.getElementById('chipsPerTipo');
chipsPer.innerHTML = D.periodos.map(p => `<button class="chip ${p === ultimo ? 'activo' : ''}" data-p="${p}">${etiquetaPer(p)}</button>`).join('');
chipsPer.addEventListener('click', e => { const b = e.target.closest('.chip'); if (!b) return; chipsPer.querySelectorAll('.chip').forEach(c => c.classList.toggle('activo', c === b)); dibujarTipo(b.dataset.p); });
dibujarTipo(ultimo);

// Mapa
const selPerMapa = document.getElementById('selPerMapa'), selTipoMapa = document.getElementById('selTipoMapa');
opcionesSelect(selPerMapa, D.periodos.map(p => [p, 'Balance ' + etiquetaPer(p)]), ultimo);
opcionesSelect(selTipoMapa, [['', 'Todos los ramos'], ...TIPOS.map(t => [t, t])], '');
const dentro = v => v != null && v >= -50 && v <= 200;
let gMapa;
function dibujarMapa() {
  const p = selPerMapa.value, t = selTipoMapa.value;
  const pts = D.entidades.filter(e => (!t || e.t === t) && e.d[p]).map(e => ({ x: valor(e, p, 'sinies'), y: valor(e, p, 'gtot'), r: valor(e, p, 'res'), n: e.n }))
    .filter(q => dentro(q.x) && dentro(q.y) && q.r != null);
  const ds = [
    { label: 'Con ganancia', data: pts.filter(q => q.r > 0), backgroundColor: 'rgba(47,133,90,0.65)', pointRadius: 5 },
    { label: 'Con pérdida', data: pts.filter(q => q.r <= 0), backgroundColor: 'rgba(197,48,48,0.65)', pointRadius: 5 },
  ];
  const opciones = { maintainAspectRatio: false,
    scales: { x: { min: -50, max: 200, title: { display: true, text: 'Siniestralidad (% de primas)' }, ticks: { callback: x => x + ' %' } },
              y: { min: -50, max: 200, title: { display: true, text: 'Gastos totales (% de primas)' }, ticks: { callback: x => x + ' %' } } },
    plugins: { tooltip: { callbacks: { label: c => ` ${c.raw.n}: siniestralidad ${fmt(c.raw.x)} %, gastos ${fmt(c.raw.y)} %, resultado ${fmt(c.raw.r)} %` } } } };
  if (gMapa) { gMapa.data.datasets = ds; gMapa.update(); } else gMapa = new Chart(document.getElementById('gMapa'), { type: 'scatter', data: { datasets: ds }, options: opciones });
}
selPerMapa.onchange = selTipoMapa.onchange = dibujarMapa;
dibujarMapa();

// Ficha
const buscador = document.getElementById('buscador');
document.getElementById('listaEnt').innerHTML = D.entidades.map(e => `<option value="${e.n}">`).join('');
function mostrarFicha(nombre) {
  const e = D.entidades.find(x => x.n.toLowerCase() === nombre.trim().toLowerCase());
  if (!e) return;
  document.getElementById('fichaTipo').textContent = `${e.t} · ${SOC[e.s] || e.s}`;
  const ms = ['sinies', 'gprod', 'gexpl', 'gtot', 'res', 'cedida'];
  document.getElementById('tFicha').innerHTML = `<thead><tr><th>Indicador</th>${D.periodos.map(p => `<th>${etiquetaPer(p)}</th>`).join('')}<th>Mercado ${etiquetaPer(ultimo)}</th></tr></thead><tbody>` +
    ms.map(m => `<tr><td>${NOMBRE[m]}</td>${D.periodos.map(p => { const v = valor(e, p, m); return `<td class="${color(m, v)}">${e.d[p] ? fmt(v) + (v == null ? '' : ' %') : '–'}</td>`; }).join('')}<td>${fmt(M[ultimo][m])} %</td></tr>`).join('') + '</tbody>';
}
buscador.addEventListener('input', () => mostrarFicha(buscador.value));
buscador.value = 'FEDERADA'; mostrarFicha('FEDERADA');

// Ranking
const selPerRank = document.getElementById('selPerRank'), selTipoRank = document.getElementById('selTipoRank');
opcionesSelect(selPerRank, D.periodos.map(p => [p, 'Balance ' + etiquetaPer(p)]), ultimo);
opcionesSelect(selTipoRank, [['', 'Todos los ramos'], ...TIPOS.map(t => [t, t])], '');
function dibujarRanking() {
  const p = selPerRank.value, t = selTipoRank.value;
  const l = D.entidades.filter(e => (!t || e.t === t) && valor(e, p, 'res') != null).map(e => ({ n: e.n, t: e.t, v: valor(e, p, 'res') })).sort((a, b) => b.v - a.v);
  const item = x => `<li><span>${x.n}<br><span class="nota" style="margin:0">${x.t}</span></span><span class="val" style="color:${x.v > 0 ? C.verde : C.rojo}">${fmt(x.v)} %</span></li>`;
  const vacio = '<li><span class="nota">Sin datos para esta selección</span></li>';
  document.getElementById('rankTop').innerHTML = l.slice(0, 5).map(item).join('') || vacio;
  document.getElementById('rankBot').innerHTML = l.slice(-5).reverse().map(item).join('') || vacio;
}
selPerRank.onchange = selTipoRank.onchange = dibujarRanking;
dibujarRanking();

// Hallazgos con datos
const pctPos = p => { const v = D.entidades.map(e => valor(e, p, 'res')).filter(x => x != null); return fmt(v.filter(x => x > 0).length / v.length * 100, 0) + ' %'; };
document.getElementById('pos1').textContent = pctPos('2024-09');
document.getElementById('pos2').textContent = pctPos('2025-09');
</script>
</body>
</html>
