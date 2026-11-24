<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Urban Architecture Studio — Isometric</title>
<style>
  @font-face{
    font-family:'Ostrich Sans';
    src:url(data:font/woff2;base64,__FONT_WOFF2_B64__) format('woff2');
    font-weight:400 700;font-display:block;
  }
  :root{
    --bg:#EAF3EE;            /* canvas / app background */
    --ink:#174A3A;           /* primary elements */
    --ink-2:#2C5F4E;
    --ink-soft:#5C7D71;
    --line:#174A3A26;        /* thin borders */
    --line-soft:#174A3A14;
    --panel:#FBFDFB;
    --panel-2:#F2F8F4;
    --sel:#C9892F;           /* warm accent for selection / measurement */
    --sel-soft:#C9892F1f;
    --shadow:0 1px 2px rgba(23,74,58,.06), 0 8px 24px rgba(23,74,58,.10);
    --shadow-sm:0 1px 2px rgba(23,74,58,.08), 0 3px 10px rgba(23,74,58,.07);
    --r-lg:22px; --r-md:15px; --r-sm:10px;
    /* district tints */
    --d-core:#DCEBE1; --d-core-l:#CFE3D6;
    --d-resi:#E4EEDC; --d-resi-l:#D7E6CC;
    --d-water:#D4E6E8; --d-water-l:#C2DBDE;
    --d-civic:#EDE7DA; --d-civic-l:#E2D9C6;
    --d-ind:#E7E3DE;  --d-ind-l:#DAD4CC;
  }
  *{box-sizing:border-box;}
  html,body{height:100%;}
  body{
    margin:0;background:var(--bg);color:var(--ink);
    font-family:'Ostrich Sans',system-ui,sans-serif;
    font-size:16px;letter-spacing:.03em;-webkit-font-smoothing:antialiased;
    overflow:hidden;
  }
  button{font-family:inherit;color:inherit;cursor:pointer;border:none;background:none;letter-spacing:.06em;}
  input,select{font-family:inherit;color:inherit;}
  ::selection{background:var(--sel);color:#fff;}
  .cap{text-transform:uppercase;letter-spacing:.22em;}
  .muted{color:var(--ink-soft);}
  .hairline{border:1px solid var(--line);}

  /* ============ VIEW SWITCHING ============ */
  .view{position:fixed;inset:0;opacity:0;visibility:hidden;transition:opacity .45s ease, transform .45s ease;}
  .view.active{opacity:1;visibility:visible;}
  body[data-view="auth"]     #view-auth,
  body[data-view="studio"]   #view-studio,
  body[data-view="profile"]  #view-profile,
  body[data-view="settings"] #view-settings{opacity:1;visibility:visible;}
  #view-profile{transform:translateY(14px);} body[data-view="profile"] #view-profile{transform:none;}
  #view-settings{transform:translateY(14px);} body[data-view="settings"] #view-settings{transform:none;}

  /* ============ AUTH ============ */
  #view-auth{display:grid;place-items:center;background:
     radial-gradient(1200px 720px at 82% -10%, #DCEBE1 0%, transparent 60%),
     radial-gradient(900px 620px at -8% 108%, #E4EEDC 0%, transparent 55%), var(--bg);}
  .auth-card{width:min(920px,92vw);display:grid;grid-template-columns:1.05fr .95fr;
     background:var(--panel);border:1px solid var(--line);border-radius:var(--r-lg);
     box-shadow:var(--shadow);overflow:hidden;}
  .auth-art{position:relative;background:linear-gradient(160deg,#174A3A,#11372B);color:#EAF3EE;padding:40px 38px;overflow:hidden;}
  .auth-art h1{font-size:40px;line-height:.96;margin:0 0 10px;letter-spacing:.01em;}
  .auth-art p{max-width:34ch;color:#EAF3EE;opacity:.75;font-size:14px;line-height:1.5;letter-spacing:.04em;}
  .auth-art .mk{position:absolute;right:-40px;bottom:-40px;width:340px;height:340px;opacity:.9;}
  .auth-art .seal{position:absolute;left:38px;bottom:34px;font-size:11px;letter-spacing:.34em;opacity:.6;}
  .auth-form{padding:40px 40px 34px;}
  .tabs{display:flex;gap:4px;background:var(--panel-2);border:1px solid var(--line);border-radius:999px;padding:4px;margin-bottom:26px;}
  .tabs button{flex:1;padding:9px 0;border-radius:999px;font-size:12px;letter-spacing:.2em;text-transform:uppercase;color:var(--ink-soft);}
  .tabs button.on{background:var(--ink);color:#EAF3EE;box-shadow:var(--shadow-sm);}
  .field{margin-bottom:14px;}
  .field label{display:block;font-size:10.5px;letter-spacing:.26em;text-transform:uppercase;color:var(--ink-soft);margin-bottom:6px;}
  .field input{width:100%;padding:11px 13px;background:var(--panel-2);border:1px solid var(--line);border-radius:var(--r-sm);
     font-size:15px;letter-spacing:.05em;outline:none;transition:border-color .2s, box-shadow .2s;}
  .field input:focus{border-color:var(--ink);box-shadow:0 0 0 3px var(--sel-soft);}
  .btn{display:inline-flex;align-items:center;justify-content:center;gap:9px;padding:12px 20px;border-radius:var(--r-sm);
     background:var(--ink);color:#EAF3EE;font-size:12.5px;letter-spacing:.2em;text-transform:uppercase;box-shadow:var(--shadow-sm);
     transition:transform .16s ease, filter .16s ease;}
  .btn:hover{filter:brightness(1.08);} .btn:active{transform:translateY(1px);}
  .btn.block{width:100%;margin-top:8px;}
  .btn.ghost{background:transparent;color:var(--ink);border:1px solid var(--line);box-shadow:none;}
  .btn.ghost:hover{background:var(--panel-2);filter:none;}
  .auth-alt{margin-top:16px;font-size:11px;letter-spacing:.18em;text-transform:uppercase;color:var(--ink-soft);text-align:center;}

  /* ============ STUDIO SHELL ============ */
  #view-studio{display:grid;grid-template-rows:56px 1fr;}
  .topbar{display:flex;align-items:center;gap:18px;padding:0 18px;background:var(--panel);border-bottom:1px solid var(--line);z-index:40;}
  .brand{display:flex;align-items:center;gap:10px;font-size:15px;letter-spacing:.17em;text-transform:uppercase;}
  .brand .logo{width:26px;height:26px;}
  .proj-name{display:flex;align-items:center;gap:8px;padding:6px 12px;border:1px solid var(--line);border-radius:999px;background:var(--panel-2);
     font-size:12.5px;letter-spacing:.16em;text-transform:uppercase;color:var(--ink-2);}
  .proj-name input{width:200px;border:none;background:transparent;font-size:12.5px;letter-spacing:.16em;text-transform:uppercase;outline:none;}
  .top-spacer{flex:1;}
  .top-actions{display:flex;align-items:center;gap:8px;}
  .tbtn{display:inline-flex;align-items:center;gap:8px;padding:8px 13px;border-radius:999px;border:1px solid var(--line);
     font-size:11px;letter-spacing:.2em;text-transform:uppercase;color:var(--ink-2);background:var(--panel);transition:background .18s, border-color .18s;}
  .tbtn:hover{background:var(--panel-2);} .tbtn.on{background:var(--ink);color:#EAF3EE;border-color:var(--ink);}
  .tbtn svg{width:15px;height:15px;}
  .avatar{width:34px;height:34px;border-radius:50%;border:1px solid var(--line);background:var(--d-civic);display:grid;place-items:center;
     font-size:13px;letter-spacing:.08em;color:var(--ink);overflow:hidden;}
  .save-dot{width:6px;height:6px;border-radius:50%;background:var(--sel);box-shadow:0 0 0 3px var(--sel-soft);}
  .save-dot.clean{background:#7FA68F;box-shadow:none;}

  .workspace{position:relative;overflow:hidden;}

  /* ---- left: library + tools ---- */
  .library{position:absolute;left:16px;top:16px;bottom:16px;width:248px;z-index:20;display:flex;flex-direction:column;
     background:var(--panel);border:1px solid var(--line);border-radius:var(--r-md);box-shadow:var(--shadow);overflow:hidden;}
  .panel-head{display:flex;align-items:center;justify-content:space-between;padding:13px 15px;border-bottom:1px solid var(--line);}
  .panel-head h3{margin:0;font-size:13px;letter-spacing:.13em;text-transform:uppercase;}
  .panel-head .cnt{font-size:10px;letter-spacing:.2em;color:var(--ink-soft);}
  .lib-cats{display:flex;gap:5px;padding:11px 13px 4px;flex-wrap:wrap;}
  .lib-cats button{padding:5px 9px;border-radius:999px;border:1px solid var(--line);font-size:9.5px;letter-spacing:.16em;
     text-transform:uppercase;color:var(--ink-soft);}
  .lib-cats button.on{background:var(--ink);color:#EAF3EE;border-color:var(--ink);}
  .lib-scroll{overflow-y:auto;padding:8px 13px 14px;flex:1;}
  .lib-grid{display:grid;grid-template-columns:1fr 1fr;gap:9px;}
  .lib-card{border:1px solid var(--line);border-radius:var(--r-sm);background:var(--panel-2);padding:8px 7px 7px;text-align:center;
     transition:transform .16s ease, box-shadow .16s ease, border-color .16s;}
  .lib-card:hover{transform:translateY(-2px);box-shadow:var(--shadow-sm);border-color:#174A3A44;}
  .lib-card.armed{border-color:var(--ink);box-shadow:0 0 0 2px var(--sel-soft);}
  .lib-card svg{width:100%;height:52px;display:block;}
  .lib-card .nm{font-size:9.5px;letter-spacing:.13em;text-transform:uppercase;color:var(--ink-2);margin-top:4px;}
  .lib-hint{font-size:9.5px;letter-spacing:.14em;text-transform:uppercase;color:var(--ink-soft);padding:10px 15px;border-top:1px solid var(--line);background:var(--panel-2);}

  .toolbar{position:absolute;left:50%;bottom:18px;transform:translateX(-50%);z-index:25;display:flex;gap:4px;padding:6px;
     background:var(--panel);border:1px solid var(--line);border-radius:999px;box-shadow:var(--shadow);}
  .tool{position:relative;width:40px;height:40px;border-radius:50%;display:grid;place-items:center;color:var(--ink-2);
     transition:background .16s ease, color .16s ease, transform .16s ease;}
  .tool:hover{background:var(--panel-2);} .tool.on{background:var(--ink);color:#EAF3EE;}
  .tool svg{width:19px;height:19px;}
  .tool[data-tip]:hover::after{content:attr(data-tip);position:absolute;bottom:50px;left:50%;transform:translateX(-50%);
     background:var(--ink);color:#EAF3EE;font-size:9px;letter-spacing:.2em;text-transform:uppercase;padding:5px 9px;border-radius:6px;white-space:nowrap;}
  .tool-sep{width:1px;align-self:stretch;margin:6px 3px;background:var(--line);}

  .zoombar{position:absolute;right:16px;bottom:18px;z-index:20;display:flex;flex-direction:column;gap:1px;
     background:var(--panel);border:1px solid var(--line);border-radius:var(--r-sm);box-shadow:var(--shadow-sm);overflow:hidden;}
  .zoombar button{width:38px;height:34px;display:grid;place-items:center;font-size:15px;color:var(--ink-2);}
  .zoombar button:hover{background:var(--panel-2);}
  .zoombar .zlvl{font-size:9px;letter-spacing:.12em;color:var(--ink-soft);height:26px;display:grid;place-items:center;border-top:1px solid var(--line);border-bottom:1px solid var(--line);}

  /* ---- right: floating stacked panels ---- */
  .right-rail{position:absolute;right:16px;top:16px;width:262px;z-index:20;display:flex;flex-direction:column;gap:14px;
     max-height:calc(100% - 84px);overflow:visible;}
  .fpanel{background:var(--panel);border:1px solid var(--line);border-radius:var(--r-md);box-shadow:var(--shadow);overflow:hidden;}
  .fpanel .body{padding:13px 15px;}
  .layer-row{display:flex;align-items:center;gap:10px;padding:7px 0;font-size:11px;letter-spacing:.14em;text-transform:uppercase;color:var(--ink-2);}
  .layer-row + .layer-row{border-top:1px solid var(--line-soft);}
  .layer-row .sw{flex:1;}
  .toggle{width:34px;height:19px;border-radius:999px;background:#C3D6CB;position:relative;transition:background .22s ease;flex:none;}
  .toggle::after{content:"";position:absolute;top:2px;left:2px;width:15px;height:15px;border-radius:50%;background:#fff;box-shadow:0 1px 2px rgba(0,0,0,.2);transition:left .22s ease;}
  .toggle.on{background:var(--ink);} .toggle.on::after{left:17px;}
  .layer-dot{width:9px;height:9px;border-radius:2px;flex:none;}

  .prop-empty{font-size:11px;letter-spacing:.12em;text-transform:uppercase;color:var(--ink-soft);line-height:1.7;}
  .prow{display:flex;align-items:center;justify-content:space-between;gap:8px;padding:8px 0;border-top:1px solid var(--line-soft);}
  .prow:first-of-type{border-top:none;}
  .prow label{font-size:10px;letter-spacing:.2em;text-transform:uppercase;color:var(--ink-soft);}
  .prow .val{font-size:13px;letter-spacing:.08em;}
  .prop-field{width:118px;padding:6px 9px;background:var(--panel-2);border:1px solid var(--line);border-radius:7px;font-size:12px;letter-spacing:.06em;outline:none;}
  .prop-field:focus{border-color:var(--ink);}
  .stepper{display:flex;align-items:center;border:1px solid var(--line);border-radius:7px;overflow:hidden;background:var(--panel-2);}
  .stepper button{width:24px;height:26px;display:grid;place-items:center;font-size:13px;color:var(--ink-2);}
  .stepper button:hover{background:#E3EEE7;}
  .stepper .n{width:40px;text-align:center;font-size:12px;letter-spacing:.05em;}
  .prop-actions{display:flex;gap:7px;margin-top:13px;}
  .prop-actions .btn{flex:1;padding:9px 0;font-size:10px;}
  .mini-legend{display:flex;gap:6px;align-items:center;font-size:9.5px;letter-spacing:.14em;text-transform:uppercase;color:var(--ink-soft);margin-top:4px;}

  .measure-list{font-size:11px;letter-spacing:.1em;color:var(--ink-2);}
  .measure-list .mrow{display:flex;justify-content:space-between;padding:5px 0;border-top:1px solid var(--line-soft);}
  .measure-list .mrow:first-child{border-top:none;}

  /* ---- canvas ---- */
  .canvas-wrap{position:absolute;inset:0;overflow:auto;cursor:default;}
  .canvas-wrap.pan{cursor:grab;} .canvas-wrap.panning{cursor:grabbing;}
  .canvas-wrap.tool-road,.canvas-wrap.tool-park,.canvas-wrap.tool-measure,.canvas-wrap.armed{cursor:crosshair;}
  .stage{transform-origin:0 0;transition:transform .26s cubic-bezier(.2,.7,.2,1);}
  #scene{display:block;}
  #scene .hover-face{transition:fill .12s ease;}
  .sel-outline{fill:none;stroke:var(--sel);stroke-width:2.5;stroke-linejoin:round;
     filter:drop-shadow(0 2px 5px rgba(201,137,47,.35));animation:selpop .28s ease;}
  @keyframes selpop{from{opacity:0;stroke-dasharray:4 5;}to{opacity:1;}}
  .sel-handle{fill:var(--panel);stroke:var(--sel);stroke-width:2;}
  .sel-handle.rot{fill:var(--sel);}
  .dim-label{font-family:'Ostrich Sans';font-size:11px;letter-spacing:.14em;fill:var(--ink);text-transform:uppercase;}
  .dim-pill{fill:var(--panel);stroke:var(--sel);stroke-width:1;}
  .district-label{font-family:'Ostrich Sans';font-size:13px;letter-spacing:.34em;fill:var(--ink);opacity:.42;text-transform:uppercase;}
  .spot-label{font-family:'Ostrich Sans';font-size:9.5px;letter-spacing:.2em;fill:var(--ink-2);opacity:.78;text-transform:uppercase;}
  .measure-line{stroke:var(--sel);stroke-width:1.6;stroke-dasharray:2 4;}
  .measure-cap{fill:var(--sel);}
  .ghost{opacity:.5;}

  /* ============ PROFILE ============ */
  .page{position:absolute;inset:0;overflow-y:auto;background:
     radial-gradient(1100px 640px at 88% -12%, #DCEBE1 0%, transparent 58%), var(--bg);}
  .page-inner{max-width:1180px;margin:0 auto;padding:30px 34px 70px;}
  .page-top{display:flex;align-items:center;gap:16px;margin-bottom:8px;}
  .page-top .back{display:inline-flex;align-items:center;gap:8px;font-size:11px;letter-spacing:.22em;text-transform:uppercase;color:var(--ink-soft);}
  .page-top .back:hover{color:var(--ink);}
  .profile-hero{display:flex;align-items:flex-end;justify-content:space-between;gap:24px;padding:22px 0 26px;border-bottom:1px solid var(--line);margin-bottom:26px;}
  .profile-id{display:flex;align-items:center;gap:18px;}
  .profile-id .ava{width:72px;height:72px;border-radius:20px;border:1px solid var(--line);background:var(--d-civic);display:grid;place-items:center;font-size:26px;box-shadow:var(--shadow-sm);}
  .profile-id h1{margin:0;font-size:34px;letter-spacing:.02em;}
  .profile-id .sub{font-size:11px;letter-spacing:.24em;text-transform:uppercase;color:var(--ink-soft);margin-top:2px;}
  .profile-stats{display:flex;gap:30px;}
  .profile-stats .st{text-align:right;}
  .profile-stats .st b{display:block;font-size:26px;font-weight:400;}
  .profile-stats .st span{font-size:9.5px;letter-spacing:.22em;text-transform:uppercase;color:var(--ink-soft);}
  .gallery-bar{display:flex;align-items:center;gap:10px;margin-bottom:20px;flex-wrap:wrap;}
  .gallery-bar h2{margin:0;font-size:14px;letter-spacing:.26em;text-transform:uppercase;}
  .folder-tabs{display:flex;gap:5px;margin-left:6px;}
  .folder-tabs button{padding:6px 11px;border-radius:999px;border:1px solid var(--line);font-size:9.5px;letter-spacing:.18em;text-transform:uppercase;color:var(--ink-soft);}
  .folder-tabs button.on{background:var(--ink);color:#EAF3EE;border-color:var(--ink);}
  .gallery-bar .spacer{flex:1;}
  .gallery{display:grid;grid-template-columns:repeat(auto-fill,minmax(270px,1fr));gap:20px;}
  .pcard{background:var(--panel);border:1px solid var(--line);border-radius:var(--r-md);box-shadow:var(--shadow-sm);overflow:hidden;
     transition:transform .2s ease, box-shadow .2s ease;cursor:pointer;}
  .pcard:hover{transform:translateY(-4px);box-shadow:var(--shadow);}
  .pcard .prev{position:relative;aspect-ratio:16/10;overflow:hidden;border-bottom:1px solid var(--line);}
  .pcard .prev svg{width:100%;height:100%;display:block;}
  .pcard .tagline{position:absolute;left:11px;top:10px;font-size:8.5px;letter-spacing:.2em;text-transform:uppercase;
     color:var(--ink);background:#FFFFFFcc;border:1px solid var(--line);border-radius:999px;padding:3px 8px;backdrop-filter:blur(2px);}
  .pcard .meta{padding:13px 15px 15px;}
  .pcard .meta h3{margin:0 0 3px;font-size:16px;letter-spacing:.04em;}
  .pcard .meta .ln{font-size:10px;letter-spacing:.16em;text-transform:uppercase;color:var(--ink-soft);}
  .pcard .meta .stat-line{display:flex;gap:14px;margin-top:9px;font-size:10px;letter-spacing:.12em;text-transform:uppercase;color:var(--ink-2);}
  .pcard .acts{display:flex;gap:6px;margin-top:12px;opacity:.62;transition:opacity .2s;}
  .pcard:hover .acts{opacity:1;}
  .pcard .acts button{flex:1;padding:7px 0;border:1px solid var(--line);border-radius:7px;font-size:9px;letter-spacing:.14em;text-transform:uppercase;color:var(--ink-2);background:var(--panel-2);transition:background .15s;}
  .pcard .acts button:hover{background:#E3EEE7;} .pcard .acts button.danger:hover{background:#F3E0DE;color:#8a3a30;}
  .pcard.new{border-style:dashed;display:grid;place-items:center;min-height:260px;color:var(--ink-soft);}
  .pcard.new:hover{color:var(--ink);}
  .pcard.new .plus{font-size:34px;margin-bottom:8px;}
  .pcard.new span{font-size:10px;letter-spacing:.24em;text-transform:uppercase;}

  /* ============ SETTINGS ============ */
  .settings-grid{display:grid;grid-template-columns:210px 1fr;gap:34px;margin-top:8px;}
  .settings-nav{display:flex;flex-direction:column;gap:2px;position:sticky;top:10px;align-self:start;}
  .settings-nav button{text-align:left;padding:10px 13px;border-radius:var(--r-sm);font-size:11px;letter-spacing:.2em;text-transform:uppercase;color:var(--ink-soft);}
  .settings-nav button.on{background:var(--panel);border:1px solid var(--line);color:var(--ink);box-shadow:var(--shadow-sm);}
  .sblock{background:var(--panel);border:1px solid var(--line);border-radius:var(--r-md);box-shadow:var(--shadow-sm);padding:8px 22px;margin-bottom:20px;}
  .sblock h3{font-size:12px;letter-spacing:.26em;text-transform:uppercase;padding:16px 0 12px;margin:0;border-bottom:1px solid var(--line);}
  .srow{display:flex;align-items:center;justify-content:space-between;gap:20px;padding:16px 0;border-top:1px solid var(--line-soft);}
  .srow:first-of-type{border-top:none;}
  .srow .lbl b{display:block;font-size:13.5px;letter-spacing:.06em;font-weight:400;}
  .srow .lbl span{font-size:10.5px;letter-spacing:.1em;text-transform:uppercase;color:var(--ink-soft);}
  .seg{display:flex;border:1px solid var(--line);border-radius:999px;overflow:hidden;}
  .seg button{padding:6px 14px;font-size:9.5px;letter-spacing:.16em;text-transform:uppercase;color:var(--ink-soft);}
  .seg button.on{background:var(--ink);color:#EAF3EE;}
  .swatches{display:flex;gap:7px;}
  .swatches .sw{width:24px;height:24px;border-radius:50%;border:2px solid transparent;cursor:pointer;}
  .swatches .sw.on{border-color:var(--ink);}

  /* scrollbars */
  .lib-scroll::-webkit-scrollbar,.canvas-wrap::-webkit-scrollbar,.page::-webkit-scrollbar{width:9px;height:9px;}
  .lib-scroll::-webkit-scrollbar-thumb,.canvas-wrap::-webkit-scrollbar-thumb,.page::-webkit-scrollbar-thumb{background:#174A3A2e;border-radius:9px;}
  .canvas-wrap::-webkit-scrollbar-track{background:transparent;}

  .toast{position:fixed;left:50%;bottom:auto;top:70px;transform:translate(-50%,-16px);background:var(--ink);color:#EAF3EE;
     padding:10px 20px;border-radius:999px;font-size:10.5px;letter-spacing:.22em;text-transform:uppercase;box-shadow:var(--shadow);
     opacity:0;transition:opacity .3s, transform .3s;z-index:100;pointer-events:none;}
  .toast.show{opacity:1;transform:translate(-50%,0);}
</style>
</head>
<body data-view="auth">

<!-- ================= AUTH ================= -->
<section id="view-auth" class="view">
  <div class="auth-card">
    <div class="auth-art">
      <div style="font-size:10px;letter-spacing:.4em;opacity:.7;margin-bottom:26px;">EST. MMXXV · ATELIER No. 04</div>
      <h1>URBAN<br>ARCHITECTURE<br>STUDIO</h1>
      <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Draft isometric districts, trace boulevards, and keep every masterplan on a single bench.</p>
      <div class="seal">ISOMETRIC PLANNING SUITE</div>
      <svg class="mk" viewBox="0 0 200 200" aria-hidden="true">
        <g stroke="#EAF3EE" stroke-width="1.4" fill="none" opacity="0.55">
          <path d="M20 120 L100 80 L180 120 L100 160 Z"/>
          <path d="M100 80 L100 20 M60 100 L60 50 L100 32 M140 100 L140 50 L100 32"/>
          <path d="M46 128 L46 104 L70 92 L70 116 Z" fill="#EAF3EE" fill-opacity=".12"/>
          <path d="M86 146 L86 110 L104 101 L104 137 Z" fill="#EAF3EE" fill-opacity=".16"/>
          <path d="M122 140 L122 108 L150 122 L150 132 Z" fill="#EAF3EE" fill-opacity=".1"/>
        </g>
      </svg>
    </div>
    <div class="auth-form">
      <div class="tabs">
        <button id="tab-register" class="on">Register</button>
        <button id="tab-signin">Sign in</button>
      </div>
      <div class="field" data-reg><label>Studio / Architect name</label><input id="f-name" value="Atelier Vega" /></div>
      <div class="field"><label>Email</label><input id="f-email" type="email" value="architect@studio.city" /></div>
      <div class="field"><label>Password</label><input id="f-pass" type="password" value="blueprint" /></div>
      <div class="field" data-reg><label>License / Registration No.</label><input id="f-lic" value="RA-2025-0041" /></div>
      <button class="btn block" id="auth-go">Enter the studio</button>
      <div class="auth-alt">Lorem ipsum · single sign-on · magic link</div>
    </div>
  </div>
</section>

<!-- ================= STUDIO ================= -->
<section id="view-studio" class="view">
  <header class="topbar">
    <div class="brand">
      <svg class="logo" viewBox="0 0 32 32"><g fill="none" stroke="#174A3A" stroke-width="1.6">
        <path d="M3 20 L16 13 L29 20 L16 27 Z"/><path d="M16 13 L16 5 M9 16.5 L9 9 L16 5.5 M23 16.5 L23 9 L16 5.5"/>
      </g></svg>
      Urban Architecture Studio
    </div>
    <div class="proj-name">
      <span class="save-dot clean" id="save-dot"></span>
      <input id="proj-title" value="Rivermouth Masterplan" spellcheck="false" />
    </div>
    <div class="top-spacer"></div>
    <div class="top-actions">
      <button class="tbtn" id="btn-snapshot"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7"><path d="M4 8h4l1.5-2h5L16 8h4v11H4z"/><circle cx="12" cy="13" r="3.3"/></svg>Add to gallery</button>
      <button class="tbtn" id="btn-save"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7"><path d="M5 4h11l3 3v13H5z"/><path d="M8 4v5h7V4M8 20v-6h8v6"/></svg>Save</button>
      <button class="tbtn" id="btn-profile"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7"><rect x="4" y="5" width="7" height="7" rx="1"/><rect x="13" y="5" width="7" height="4" rx="1"/><rect x="13" y="11" width="7" height="8" rx="1"/><rect x="4" y="14" width="7" height="5" rx="1"/></svg>Gallery</button>
      <button class="tbtn" id="btn-settings"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7"><circle cx="12" cy="12" r="3.2"/><path d="M12 3v3M12 18v3M3 12h3M18 12h3M5.5 5.5l2.1 2.1M16.4 16.4l2.1 2.1M18.5 5.5l-2.1 2.1M7.6 16.4l-2.1 2.1"/></svg>Settings</button>
      <div class="avatar" id="avatar-top">AV</div>
    </div>
  </header>

  <div class="workspace">
    <div class="canvas-wrap" id="canvas-wrap">
      <div class="stage" id="stage">
        <svg id="scene" xmlns="http://www.w3.org/2000/svg"></svg>
      </div>
    </div>

    <!-- LIBRARY -->
    <aside class="library">
      <div class="panel-head"><h3>Building Library</h3><span class="cnt" id="lib-count">—</span></div>
      <div class="lib-cats" id="lib-cats"></div>
      <div class="lib-scroll"><div class="lib-grid" id="lib-grid"></div></div>
      <div class="lib-hint">Pick a form, then click the canvas to place.</div>
    </aside>

    <!-- TOOLBAR -->
    <div class="toolbar" id="toolbar">
      <button class="tool on" data-tool="select" data-tip="Select · V"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M5 3l14 7-6 2-2 6z"/></svg></button>
      <button class="tool" data-tool="pan" data-tip="Pan · H"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M9 11V5.5a1.5 1.5 0 013 0V10m0-1.5a1.5 1.5 0 013 0V11m0-1a1.5 1.5 0 013 0v5a6 6 0 01-6 6h-1.5a6 6 0 01-5-2.7L6 18c-1.2-1.6-.3-2.8 1-2.3l2 1V7a1.5 1.5 0 013 0"/></svg></button>
      <span class="tool-sep"></span>
      <button class="tool" data-tool="road" data-tip="Road · R"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M7 21L10 3M17 21L14 3M12 6v2M12 11v2M12 16v2"/></svg></button>
      <button class="tool" data-tool="park" data-tip="Park · P"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M12 21v-5M12 16c-3 0-5-2-5-5s2-6 5-6 5 3 5 6-2 5-5 5z"/></svg></button>
      <button class="tool" data-tool="measure" data-tip="Measure · M"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M3 14L14 3l7 7L10 21z"/><path d="M7 10l2 2M10 7l2 2M13 10l2 2"/></svg></button>
      <span class="tool-sep"></span>
      <button class="tool" data-tool="delete" data-tip="Delete · ⌫"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"><path d="M5 7h14M10 7V4h4v3M7 7l1 13h8l1-13"/></svg></button>
    </div>

    <div class="zoombar">
      <button id="zoom-in">+</button>
      <div class="zlvl" id="zoom-lvl">100%</div>
      <button id="zoom-out">−</button>
      <button id="zoom-fit" title="Fit" style="border-top:1px solid var(--line);font-size:10px;letter-spacing:.12em;">FIT</button>
    </div>

    <!-- RIGHT RAIL -->
    <div class="right-rail">
      <div class="fpanel" id="panel-props">
        <div class="panel-head"><h3>Properties</h3><span class="cnt" id="prop-id">—</span></div>
        <div class="body" id="prop-body">
          <div class="prop-empty">No object selected.<br>Pick a building, road or park on the canvas to edit its measurements and placement.</div>
        </div>
      </div>
      <div class="fpanel">
        <div class="panel-head"><h3>Map Layers</h3><span class="cnt">06</span></div>
        <div class="body" id="layer-body"></div>
      </div>
      <div class="fpanel">
        <div class="panel-head"><h3>Measurements</h3><button id="clear-measure" style="font-size:9px;letter-spacing:.16em;text-transform:uppercase;color:var(--ink-soft);">Clear</button></div>
        <div class="body"><div class="measure-list" id="measure-list"><div class="muted" style="font-size:10.5px;letter-spacing:.14em;text-transform:uppercase;">No measurements yet</div></div>
          <div class="mini-legend">Scale · 1 cell ≈ 6 metres</div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ================= PROFILE ================= -->
<section id="view-profile" class="view">
  <div class="page"><div class="page-inner">
    <div class="page-top"><button class="back" id="profile-back">← Back to studio</button></div>
    <div class="profile-hero">
      <div class="profile-id">
        <div class="ava">◳</div>
        <div><h1 id="profile-name">Atelier Vega</h1><div class="sub">Registered Architect · RA-2025-0041 · Lorem Ipsum District</div></div>
      </div>
      <div class="profile-stats">
        <div class="st"><b id="st-projects">0</b><span>Saved cities</span></div>
        <div class="st"><b id="st-buildings">0</b><span>Structures drawn</span></div>
        <div class="st"><b>12</b><span>Shared reviews</span></div>
      </div>
    </div>
    <div class="gallery-bar">
      <h2>Project Gallery</h2>
      <div class="folder-tabs" id="folder-tabs">
        <button class="on" data-folder="all">All</button>
        <button data-folder="Masterplans">Masterplans</button>
        <button data-folder="Studies">Studies</button>
        <button data-folder="Competitions">Competitions</button>
      </div>
      <div class="spacer"></div>
      <button class="btn ghost" id="profile-sort">Sort · Recent</button>
    </div>
    <div class="gallery" id="gallery"></div>
  </div></div>
</section>

<!-- ================= SETTINGS ================= -->
<section id="view-settings" class="view">
  <div class="page"><div class="page-inner">
    <div class="page-top"><button class="back" id="settings-back">← Back to studio</button></div>
    <h1 style="font-size:34px;margin:10px 0 4px;">Studio Settings</h1>
    <div class="sub" style="font-size:11px;letter-spacing:.24em;text-transform:uppercase;color:var(--ink-soft);margin-bottom:18px;">Account · Canvas · Units · Appearance</div>
    <div class="settings-grid">
      <nav class="settings-nav">
        <button class="on">Account</button><button>Canvas</button><button>Units &amp; scale</button>
        <button>Appearance</button><button>Collaboration</button><button>Notifications</button>
      </nav>
      <div>
        <div class="sblock">
          <h3>Account</h3>
          <div class="srow"><div class="lbl"><b>Atelier Vega</b><span>architect@studio.city</span></div><button class="btn ghost">Edit profile</button></div>
          <div class="srow"><div class="lbl"><b>License number</b><span>Lorem ipsum registration body</span></div><input class="prop-field" style="width:150px" value="RA-2025-0041" /></div>
          <div class="srow"><div class="lbl"><b>Two-factor authentication</b><span>Lorem ipsum dolor sit amet</span></div><div class="toggle on" data-toggle></div></div>
        </div>
        <div class="sblock">
          <h3>Canvas</h3>
          <div class="srow"><div class="lbl"><b>Snap to grid</b><span>Align footprints to the isometric lattice</span></div><div class="toggle on" data-toggle></div></div>
          <div class="srow"><div class="lbl"><b>Show district tints</b><span>Soft colour fills behind each zone</span></div><div class="toggle on" data-toggle></div></div>
          <div class="srow"><div class="lbl"><b>Default zoom</b><span>Opening magnification for new plans</span></div>
            <div class="seg"><button>80%</button><button class="on">100%</button><button>120%</button></div></div>
        </div>
        <div class="sblock">
          <h3>Units &amp; scale</h3>
          <div class="srow"><div class="lbl"><b>Measurement system</b><span>Applies to every dimension label</span></div>
            <div class="seg" id="unit-seg"><button class="on" data-unit="m">Metric</button><button data-unit="ft">Imperial</button></div></div>
          <div class="srow"><div class="lbl"><b>Grid cell size</b><span>Lorem ipsum real-world span</span></div>
            <div class="seg"><button>4 m</button><button class="on">6 m</button><button>8 m</button></div></div>
        </div>
        <div class="sblock">
          <h3>Appearance</h3>
          <div class="srow"><div class="lbl"><b>Selection accent</b><span>Highlight colour for handles &amp; measurements</span></div>
            <div class="swatches" id="accent-swatches">
              <div class="sw on" style="background:#C9892F" data-accent="#C9892F"></div>
              <div class="sw" style="background:#174A3A" data-accent="#174A3A"></div>
              <div class="sw" style="background:#3E6BB5" data-accent="#3E6BB5"></div>
              <div class="sw" style="background:#B5543E" data-accent="#B5543E"></div>
            </div></div>
          <div class="srow"><div class="lbl"><b>Canvas paper grid</b><span>Fine isometric guideline density</span></div>
            <div class="seg"><button>Sparse</button><button class="on">Standard</button><button>Dense</button></div></div>
        </div>
      </div>
    </div>
  </div></div>
</section>

<div class="toast" id="toast"></div>

<script>
(()=>{
"use strict";
const $=(s,r=document)=>r.querySelector(s);
const $$=(s,r=document)=>[...r.querySelectorAll(s)];
const SVGNS="http://www.w3.org/2000/svg";
const el=(n,a={})=>{const e=document.createElementNS(SVGNS,n);for(const k in a)e.setAttribute(k,a[k]);return e;};
const clamp=(v,a,b)=>Math.max(a,Math.min(b,v));
const toast=(()=>{let t;const n=$("#toast");return m=>{n.textContent=m;n.classList.add("show");clearTimeout(t);t=setTimeout(()=>n.classList.remove("show"),1900);};})();

/* ---------- isometric geometry ---------- */
const TW=62, TH=31, PAD=90, GRID_W=24, GRID_H=22;
const originX=GRID_H*TW/2 + PAD;
const iso=(gx,gy)=>({x:originX+(gx-gy)*TW/2, y:PAD+(gx+gy)*TH/2});
const SceneW=(GRID_W+GRID_H)*TW/2 + PAD*2;
const SceneH=(GRID_W+GRID_H)*TH/2 + PAD*2;
const UNIT_M=6; // metres per cell
let units="m";
const fmtLen=cells=>{const m=cells*UNIT_M; return units==="m"? Math.round(m)+" M" : Math.round(m*3.28084)+" FT";};

/* ---------- shade helpers ---------- */
const hex2rgb=h=>[1,3,5].map(i=>parseInt(h.slice(i,i+2),16));
const shade=(h,f)=>{const[r,g,b]=hex2rgb(h);const m=c=>Math.round(clamp(f>=0?c+(255-c)*f:c*(1+f),0,255));return`rgb(${m(r)},${m(g)},${m(b)})`;};

/* ---------- building catalogue ---------- */
const CATS=["All","Civic","Residential","Commercial","Landscape","Infrastructure"];
const BTYPES=[
  {id:"tower",   name:"Glass Tower",   cat:"Commercial",  w:2,d:2,fl:14,col:"#6E8FA6",roof:"antenna"},
  {id:"office",  name:"Office Block",  cat:"Commercial",  w:3,d:2,fl:7, col:"#7E93A0",roof:"units"},
  {id:"retail",  name:"Retail Arcade", cat:"Commercial",  w:3,d:2,fl:2, col:"#C0A46B",roof:"saw"},
  {id:"apt",     name:"Apartments",    cat:"Residential", w:3,d:2,fl:6, col:"#C98F6B",roof:"parapet"},
  {id:"rowhouse",name:"Row Houses",    cat:"Residential", w:3,d:1,fl:3, col:"#D3A98A",roof:"pitch"},
  {id:"villa",   name:"Courtyard Villa",cat:"Residential",w:2,d:2,fl:2, col:"#D8BC96",roof:"pitch"},
  {id:"cityhall",name:"City Hall",     cat:"Civic",       w:3,d:3,fl:4, col:"#B7BDC2",roof:"dome"},
  {id:"library", name:"Library",       cat:"Civic",       w:3,d:2,fl:3, col:"#AEB7AE",roof:"parapet"},
  {id:"museum",  name:"Museum",        cat:"Civic",       w:3,d:2,fl:2, col:"#C4C1B4",roof:"skylight"},
  {id:"station", name:"Transit Hall",  cat:"Infrastructure",w:4,d:2,fl:2,col:"#9AA7A1",roof:"vault"},
  {id:"bridge",  name:"River Bridge",  cat:"Infrastructure",w:4,d:1,fl:1,col:"#8C9A94",roof:"deck"},
  {id:"tower2",  name:"Water Tower",   cat:"Infrastructure",w:1,d:1,fl:5,col:"#8FA0A8",roof:"tank"},
  {id:"park",    name:"City Park",     cat:"Landscape",   w:3,d:3,fl:0, col:"#78A071",roof:"trees"},
  {id:"plaza",   name:"Public Plaza",  cat:"Landscape",   w:3,d:2,fl:0, col:"#D7CEB6",roof:"fountain"},
  {id:"garden",  name:"Pocket Garden", cat:"Landscape",   w:2,d:2,fl:0, col:"#8BAE7E",roof:"hedge"},
];
const BY=Object.fromEntries(BTYPES.map(b=>[b.id,b]));

/* ---------- project state ---------- */
let accent="#C9892F";
const DISTRICTS=[
  {name:"Parkside Belt",  x:0, y:0, w:13, h:3, fill:"var(--d-resi)",  hl:"var(--d-resi-l)"},
  {name:"Civic Spine",    x:0, y:3, w:13, h:7, fill:"var(--d-civic)", hl:"var(--d-civic-l)"},
  {name:"Rivermouth Core",x:13,y:3, w:9,  h:7, fill:"var(--d-core)",  hl:"var(--d-core-l)"},
  {name:"Garden Quarter", x:0, y:10,w:22, h:7, fill:"var(--d-resi)",  hl:"var(--d-resi-l)"},
  {name:"Wharf Works",    x:0, y:17,w:22, h:5, fill:"var(--d-ind)",   hl:"var(--d-ind-l)"},
];
const RIVER=[{gx:20.4,gy:0},{gx:21.6,gy:7},{gx:20.8,gy:14},{gx:21.8,gy:22}]; // polyline band (centre-line)
const RIVER_W=2.6;
const SPOTS=[
  {x:6.5,y:3, t:"Civic Axis"},  {x:13,y:3, t:"River Gate"},
  {x:6.5,y:10,t:"Linden Walk"}, {x:13,y:10,t:"Orchard Cross"},
  {x:5,y:17, t:"Dry Dock 3"},   {x:13,y:17,t:"South Pier"},
];

function seedCity(){
  return {
    title:"Rivermouth Masterplan",
    buildings:[
      // Parkside Belt
      {id:uid(),type:"park",    gx:1, gy:0, rot:0,name:"Council Park",fl:0,cw:4,cd:3},
      {id:uid(),type:"garden",  gx:8, gy:0, rot:0,name:"Belt Garden",fl:0},
      // Civic Spine
      {id:uid(),type:"cityhall",gx:1, gy:4, rot:0,name:"City Hall",fl:4},
      {id:uid(),type:"library", gx:5, gy:4, rot:0,name:"Central Library",fl:3},
      {id:uid(),type:"museum",  gx:9, gy:4, rot:2,name:"Maritime Museum",fl:2},
      {id:uid(),type:"plaza",   gx:1, gy:8, rot:0,name:"Grand Axis Plaza",fl:0},
      {id:uid(),type:"garden",  gx:5, gy:8, rot:0,name:"Cloister Garden",fl:0},
      {id:uid(),type:"rowhouse",gx:9, gy:8, rot:0,name:"Chapter Terrace",fl:3},
      // Rivermouth Core
      {id:uid(),type:"tower",   gx:14,gy:4, rot:0,name:"Vega Tower",fl:15},
      {id:uid(),type:"office",  gx:17,gy:4, rot:0,name:"Harbour Exchange",fl:8},
      {id:uid(),type:"retail",  gx:14,gy:7, rot:0,name:"Arcade Row",fl:2},
      {id:uid(),type:"office",  gx:18,gy:7, rot:0,name:"Clerkenwell House",fl:6},
      {id:uid(),type:"bridge",  gx:20,gy:5, rot:0,name:"Old River Bridge",fl:1},
      // Garden Quarter — tall back row (y11), low front row (y15)
      {id:uid(),type:"tower",   gx:1, gy:11,rot:0,name:"Linden Tower",fl:12},
      {id:uid(),type:"apt",     gx:4, gy:11,rot:0,name:"Parkside Flats",fl:7},
      {id:uid(),type:"office",  gx:8, gy:11,rot:0,name:"Meridian Office",fl:6},
      {id:uid(),type:"apt",     gx:14,gy:11,rot:0,name:"Orchard Apartments",fl:6},
      {id:uid(),type:"tower",   gx:18,gy:11,rot:0,name:"Weaver Tower",fl:10},
      {id:uid(),type:"rowhouse",gx:1, gy:15,rot:0,name:"Garden Terrace",fl:3},
      {id:uid(),type:"villa",   gx:5, gy:15,rot:0,name:"Court Villa",fl:2},
      {id:uid(),type:"garden",  gx:8, gy:15,rot:0,name:"Pocket Garden",fl:0},
      {id:uid(),type:"rowhouse",gx:11,gy:15,rot:0,name:"Orchard Mews",fl:3},
      {id:uid(),type:"park",    gx:15,gy:15,rot:0,name:"Linden Green",fl:0,cw:5,cd:2},
      // Wharf Works — single wharf-front row
      {id:uid(),type:"station", gx:1, gy:18,rot:0,name:"Wharf Transit Hall",fl:2},
      {id:uid(),type:"tower2",  gx:6, gy:18,rot:0,name:"Dock Water Tower",fl:5},
      {id:uid(),type:"retail",  gx:8, gy:18,rot:0,name:"Wharf Market",fl:2},
      {id:uid(),type:"office",  gx:12,gy:18,rot:0,name:"Customs House",fl:5},
      {id:uid(),type:"garden",  gx:16,gy:18,rot:0,name:"Dockers' Green",fl:0},
      {id:uid(),type:"villa",   gx:18,gy:18,rot:0,name:"Pilot's Cottage",fl:2},
    ],
    roads:[
      [{gx:0,gy:3},{gx:23,gy:3}], [{gx:0,gy:10},{gx:23,gy:10}], [{gx:0,gy:17},{gx:23,gy:17}],
      [{gx:4,gy:0},{gx:4,gy:22}], [{gx:13,gy:0},{gx:13,gy:22}],
      [{gx:8,gy:10},{gx:8,gy:17}], [{gx:11,gy:3},{gx:11,gy:10}],
    ],
    measures:[],
  };
}
let city=seedCity();
let SELECTED=null, TOOL="select", ARMED=null, zoom=1;
const LAYERS={grid:true,zoning:true,green:true,roads:true,labels:true,shadows:true};
function uid(){return "o"+Math.random().toString(36).slice(2,8);}
let dirty=false;
const markDirty=()=>{dirty=true;$("#save-dot").classList.remove("clean");};
const markClean=()=>{dirty=false;$("#save-dot").classList.add("clean");};

/* ======================================================= *
 *  SVG SCENE RENDERING
 * ======================================================= */
const scene=$("#scene");
scene.setAttribute("viewBox",`0 0 ${SceneW} ${SceneH}`);
scene.setAttribute("width",SceneW); scene.setAttribute("height",SceneH);

function footprint(b){ // returns {w,d} accounting for 90° rotations
  const t=BY[b.type]; const r=((b.rot%4)+4)%4;
  return (r%2)? {w:t.d,d:t.w} : {w:t.w,d:t.d};
}
function quad(gx,gy,w,d){const a=iso(gx,gy),b=iso(gx+w,gy),c=iso(gx+w,gy+d),e=iso(gx,gy+d);
  return `${a.x},${a.y} ${b.x},${b.y} ${c.x},${c.y} ${e.x},${e.y}`;}

function drawScene(){
  scene.innerHTML="";
  const defs=el("defs");
  defs.innerHTML=`
   <pattern id="isoGrid" width="${TW}" height="${TH}" patternUnits="userSpaceOnUse" patternTransform="translate(${originX} ${PAD})">
     <path d="M0 ${TH/2} L${TW/2} 0 L${TW} ${TH/2} L${TW/2} ${TH} Z" fill="none" stroke="#174A3A" stroke-opacity="0.10" stroke-width="1"/>
   </pattern>
   <filter id="softdrop" x="-40%" y="-40%" width="180%" height="180%">
     <feDropShadow dx="0" dy="10" stdDeviation="9" flood-color="#174A3A" flood-opacity="0.16"/>
   </filter>`;
  scene.appendChild(defs);

  const gBase=el("g"), gGrid=el("g"), gDist=el("g"), gWater=el("g"),
        gRoad=el("g"), gObj=el("g"), gLabel=el("g"),
        gOverlay=el("g",{id:"overlay"});
  scene.append(gBase,gDist,gWater,gGrid,gRoad,gObj,gLabel,gOverlay);

  // paper base
  gBase.appendChild(el("polygon",{points:quad(0,0,GRID_W,GRID_H),fill:"#E2EFE6"}));

  // districts (soft tints)
  gDist.style.transition="opacity .4s ease"; gDist.style.opacity=LAYERS.zoning?1:0;
  DISTRICTS.forEach(dz=>{
    gDist.appendChild(el("polygon",{points:quad(dz.x,dz.y,dz.w,dz.h),fill:dz.fill,stroke:"#174A3A",
      "stroke-opacity":.14,"stroke-width":1,"stroke-dasharray":"1 5"}));
    const a=iso(dz.x,dz.y),b=iso(dz.x+dz.w,dz.y);
    gDist.appendChild(el("line",{x1:a.x,y1:a.y,x2:b.x,y2:b.y,stroke:dz.hl,"stroke-width":3,opacity:.6}));
  });

  // water band (offset polyline around centre-line) + quayside trim
  const rpA=RIVER.map(p=>iso(p.gx-RIVER_W/2,p.gy));
  const rpB=RIVER.slice().reverse().map(p=>iso(p.gx+RIVER_W/2,p.gy));
  gWater.appendChild(el("polygon",{points:[...RIVER.map(p=>iso(p.gx-RIVER_W/2-0.22,p.gy)),
    ...RIVER.slice().reverse().map(p=>iso(p.gx+RIVER_W/2+0.22,p.gy))].map(p=>p.x+","+p.y).join(" "),
    fill:"#CBBFA6"}));
  gWater.appendChild(el("polygon",{points:[...rpA,...rpB].map(p=>p.x+","+p.y).join(" "),
    fill:"#BADDE0",stroke:"#174A3A","stroke-opacity":.16,"stroke-width":1}));
  for(let k=0.16;k<1;k+=0.19){
    const pp=RIVER.map(p=>iso(p.gx-RIVER_W/2+RIVER_W*k,p.gy));
    gWater.appendChild(el("polyline",{points:pp.map(p=>p.x+","+p.y).join(" "),fill:"none",
      stroke:k<0.3||k>0.8?"#A6CDD0":"#C9E3E5","stroke-width":k<0.5?1.3:1,opacity:.65}));
  }

  // grid
  gGrid.appendChild(el("polygon",{points:quad(0,0,GRID_W,GRID_H),fill:"url(#isoGrid)"}));
  gGrid.style.transition="opacity .4s ease"; gGrid.style.opacity=LAYERS.grid?1:0;

  // roads
  gRoad.style.transition="opacity .4s ease"; gRoad.style.opacity=LAYERS.roads?1:0;
  city.roads.forEach((path,ri)=>drawRoad(gRoad,path,ri));

  // buildings + green, drawn back-to-front in one depth-sorted pass
  const order=[...city.buildings].sort((p,q)=>{
    const fp=footprint(p),fq=footprint(q);
    return (p.gx+p.gy+(fp.w+fp.d)/2)-(q.gx+q.gy+(fq.w+fq.d)/2);
  });
  order.forEach(b=>{ (BY[b.type].fl===0) ? drawGreen(gObj,b) : drawBuilding(gObj,b); });

  // on-canvas labels
  gLabel.style.transition="opacity .4s ease"; gLabel.style.opacity=LAYERS.labels?1:0;
  // district names sit in the road gutter along each zone's leading (upper) edge
  const DLAB=[   // anchored on road / road-crossings so volumes never sit on them
    {n:"PARKSIDE BELT",   gx:4.35, gy:0.4},
    {n:"CIVIC SPINE",     gx:4.35, gy:5.6},
    {n:"RIVERMOUTH CORE", gx:13.35,gy:5.6},
    {n:"GARDEN QUARTER",  gx:8.35, gy:12.6},
    {n:"WHARF WORKS",     gx:4.35, gy:19.6},
  ];
  DLAB.forEach(d=>{const c=iso(d.gx,d.gy), w=d.n.length*8.2+26;
    gLabel.appendChild(el("rect",{x:c.x-9,y:c.y-9.5,width:w,height:19,rx:9.5,fill:"#FBFDFBee","stroke":"var(--ink)","stroke-opacity":.2}));
    gLabel.appendChild(el("circle",{cx:c.x,cy:c.y,r:2.6,fill:"var(--ink)",opacity:.55}));
    gLabel.appendChild(el("circle",{cx:c.x,cy:c.y,r:5,fill:"none",stroke:"var(--ink)","stroke-opacity":.3}));
    const tx=el("text",{x:c.x+12,y:c.y+4,class:"district-label"});tx.textContent=d.n;tx.setAttribute("opacity",".74");
    gLabel.appendChild(tx);
  });
  SPOTS.forEach(s=>{const c=iso(s.x,s.y);
    const tx=el("text",{x:c.x,y:c.y+3,"text-anchor":"middle",class:"spot-label"});tx.textContent=s.t.toUpperCase();
    const w=s.t.length*5.8+14;
    gLabel.appendChild(el("rect",{x:c.x-w/2,y:c.y-8,width:w,height:16,rx:8,fill:"#FBFDFBd9",stroke:"var(--ink)","stroke-opacity":.14}));
    gLabel.appendChild(el("circle",{cx:c.x-w/2+7,cy:c.y,r:1.6,fill:accent}));
    tx.setAttribute("x",c.x+4); gLabel.appendChild(tx);});

  drawMeasures(gOverlay);
  drawSelection(gOverlay);
}

function drawRoad(g,path,ri){
  const W=0.34;
  for(let i=0;i<path.length-1;i++){
    const a=path[i],b=path[i+1];
    const horiz = a.gy===b.gy;
    const x0=Math.min(a.gx,b.gx), x1=Math.max(a.gx,b.gx);
    const y0=Math.min(a.gy,b.gy), y1=Math.max(a.gy,b.gy);
    const pts = horiz ? quad(x0,y0-W/2,x1-x0,W) : quad(x0-W/2,y0,W,y1-y0);
    const poly=el("polygon",{points:pts,fill:"#C9BBA0",stroke:"#174A3A","stroke-opacity":.14,"stroke-width":1,
      "data-kind":"road","data-ri":ri,class:"pick"});
    g.appendChild(poly);
    // centre dash
    const ca = horiz? iso(x0,y0):iso(x0,y0), cb = horiz? iso(x1,y1):iso(x1,y1);
    g.appendChild(el("line",{x1:ca.x,y1:ca.y,x2:cb.x,y2:cb.y,stroke:"#FBFDFB","stroke-width":1.4,"stroke-dasharray":"5 7",opacity:.85}));
  }
}

function treeSVG(g,cx,cy,s=1){
  g.appendChild(el("ellipse",{cx:cx,cy:cy+6*s,rx:8*s,ry:3.4*s,fill:"#174A3A","fill-opacity":.12}));
  g.appendChild(el("rect",{x:cx-1.1*s,y:cy,width:2.2*s,height:6*s,fill:"#7A5A3A"}));
  g.appendChild(el("circle",{cx:cx,cy:cy-3*s,r:6.5*s,fill:"#5E8D57"}));
  g.appendChild(el("circle",{cx:cx-3*s,cy:cy+0.5*s,r:4.6*s,fill:"#6E9E65"}));
  g.appendChild(el("circle",{cx:cx+3.3*s,cy:cy-1*s,r:4.2*s,fill:"#6E9E65"}));
}

function drawGreen(g,b){
  const fp=footprint(b), t=BY[b.type];
  const grp=el("g",{class:"pick","data-kind":"building","data-id":b.id,
    style:"cursor:pointer;transition:opacity .4s ease;opacity:"+(LAYERS.green?1:.28)});
  grp.appendChild(el("polygon",{points:quad(b.gx,b.gy,fp.w,fp.d),fill:t.col,"fill-opacity":.9}));
  grp.appendChild(el("polygon",{points:quad(b.gx+.12,b.gy+.12,fp.w-.24,fp.d-.24),fill:"none",stroke:"#FBFDFB","stroke-opacity":.5,"stroke-width":1}));
  if(t.roof==="fountain"){
    const c=iso(b.gx+fp.w/2,b.gy+fp.d/2);
    grp.appendChild(el("ellipse",{cx:c.x,cy:c.y,rx:TW*0.55,ry:TH*0.55,fill:"#C2DBDE",stroke:"#174A3A","stroke-opacity":.2}));
    grp.appendChild(el("ellipse",{cx:c.x,cy:c.y,rx:6,ry:3,fill:"#9CC4C6"}));
    // promenade paving
    for(let i=1;i<fp.w;i++){const A=iso(b.gx+i,b.gy),B=iso(b.gx+i,b.gy+fp.d);grp.appendChild(el("line",{x1:A.x,y1:A.y,x2:B.x,y2:B.y,stroke:"#174A3A","stroke-opacity":.1}));}
  } else {
    // lawn + scattered trees deterministically
    let n=0;
    for(let x=0;x<fp.w;x++)for(let y=0;y<fp.d;y++){
      if((x*7+y*5+b.gx+b.gy)%3!==0) continue;
      const c=iso(b.gx+x+.5,b.gy+y+.5); treeSVG(grp,c.x,c.y-4,t.roof==="hedge"?0.7:0.95); n++;
    }
    if(n===0){const c=iso(b.gx+fp.w/2,b.gy+fp.d/2);treeSVG(grp,c.x,c.y-4,1);}
    // winding path
    const p0=iso(b.gx,b.gy+fp.d-0.5),p1=iso(b.gx+fp.w/2,b.gy+fp.d/2-0.2),p2=iso(b.gx+fp.w,b.gy+0.5);
    grp.appendChild(el("path",{d:`M${p0.x} ${p0.y} Q ${p1.x} ${p1.y} ${p2.x} ${p2.y}`,fill:"none",stroke:"#D8CEB4","stroke-width":3.4,"stroke-linecap":"round"}));
  }
  g.appendChild(grp);
}

function floorsToH(fl){ return fl<=4 ? fl*10+6 : 46+(fl-4)*6.2; }

function drawBridge(g,b){
  const fp=footprint(b);
  const grp=el("g",{class:"pick","data-kind":"building","data-id":b.id,style:"cursor:pointer"});
  const D=10; // deck thickness/height
  const A0=iso(b.gx,b.gy+0.5), A1=iso(b.gx+fp.w,b.gy+0.5);
  // stone arches under the deck
  const span=fp.w;
  for(let s=0;s<span;s++){
    const l=iso(b.gx+s+0.12,b.gy+0.5), r=iso(b.gx+s+0.88,b.gy+0.5);
    grp.appendChild(el("path",{d:`M ${l.x} ${l.y} L ${l.x} ${l.y-D} Q ${(l.x+r.x)/2} ${(l.y+r.y)/2-D-9} ${r.x} ${r.y-D} L ${r.x} ${r.y} Q ${(l.x+r.x)/2} ${(l.y+r.y)/2} ${l.x} ${l.y} Z`,
      fill:"#B7AE9E",stroke:"#13382C","stroke-opacity":.4}));
    grp.appendChild(el("path",{d:`M ${l.x} ${l.y-D} Q ${(l.x+r.x)/2} ${(l.y+r.y)/2-D-9} ${r.x} ${r.y-D}`,fill:"none",stroke:"#EAF3EE","stroke-opacity":.5}));
  }
  // deck slab
  const dl=iso(b.gx,b.gy), dr=iso(b.gx+fp.w,b.gy), db=iso(b.gx+fp.w,b.gy+fp.d), df=iso(b.gx,b.gy+fp.d);
  const up=p=>({x:p.x,y:p.y-D});
  grp.appendChild(el("polygon",{points:`${df.x},${df.y} ${up(df).x},${up(df).y} ${up(dl).x},${up(dl).y} ${dl.x},${dl.y}`,fill:"#9E958480"}));
  grp.appendChild(el("polygon",{points:`${up(dl).x},${up(dl).y} ${up(dr).x},${up(dr).y} ${up(db).x},${up(db).y} ${up(df).x},${up(df).y}`,
    fill:"#C6BBA6",stroke:"#13382C","stroke-opacity":.4}));
  for(let k=1;k<fp.w;k++){const a=up(iso(b.gx+k,b.gy)),c=up(iso(b.gx+k,b.gy+fp.d));grp.appendChild(el("line",{x1:a.x,y1:a.y,x2:c.x,y2:c.y,stroke:"#13382C","stroke-opacity":.25}));}
  // parapets
  [[dl,dr],[df,db]].forEach(([p,q])=>grp.appendChild(el("line",{x1:up(p).x,y1:up(p).y-3,x2:up(q).x,y2:up(q).y-3,stroke:"#13382C","stroke-opacity":.45,"stroke-width":2})));
  g.appendChild(grp);
}

function drawBuilding(g,b){
  if(b.type==="bridge"){ drawBridge(g,b); return; }
  const t=BY[b.type], fp=footprint(b);
  const H=floorsToH(Math.max(1,b.fl));
  const bl=iso(b.gx,b.gy+fp.d), br=iso(b.gx+fp.w,b.gy+fp.d),
        bb=iso(b.gx+fp.w,b.gy),  bt=iso(b.gx,b.gy);
  const up=p=>({x:p.x,y:p.y-H});
  const tL=up(iso(b.gx,b.gy)), tR=up(iso(b.gx+fp.w,b.gy)), tB=up(iso(b.gx+fp.w,b.gy+fp.d)), tF=up(iso(b.gx,b.gy+fp.d));
  const grp=el("g",{class:"pick","data-kind":"building","data-id":b.id,style:"cursor:pointer"});
  if(LAYERS.shadows){
    const sx=H*0.5;
    grp.appendChild(el("polygon",{points:`${bt.x},${bt.y} ${bb.x},${bb.y} ${br.x},${br.y} ${bl.x},${bl.y}`,
      fill:"#174A3A","fill-opacity":.13,transform:`translate(${sx} ${sx*0.5})`}));
  }
  const base=t.col;
  const fLeft=el("polygon",{points:`${bt.x},${bt.y} ${tL.x},${tL.y} ${tF.x},${tF.y} ${bl.x},${bl.y}`,fill:shade(base,-0.36)});
  const fRight=el("polygon",{points:`${bl.x},${bl.y} ${tF.x},${tF.y} ${tB.x},${tB.y} ${br.x},${br.y}`,fill:shade(base,-0.14)});
  const roof=el("polygon",{points:`${tL.x},${tL.y} ${tR.x},${tR.y} ${tB.x},${tB.y} ${tF.x},${tF.y}`,fill:shade(base,0.14)});
  [fLeft,fRight,roof].forEach(p=>{p.setAttribute("stroke","#15402F");p.setAttribute("stroke-opacity",".4");p.setAttribute("stroke-width","0.9");p.setAttribute("stroke-linejoin","round");});
  grp.append(fLeft,fRight,roof);
  // floor seams (subtle, only on multi-storey blocks)
  if(b.fl>=3){
    const rows=Math.min(b.fl,12), step=1/(rows);
    for(let r=1;r<rows;r++){
      const y=r*step;
      grp.appendChild(el("line",{x1:bt.x+(tL.x-bt.x)*y,y1:bt.y+(tL.y-bt.y)*y,x2:bl.x+(tF.x-bl.x)*y,y2:bl.y+(tF.y-bl.y)*y,stroke:shade(base,-0.26),"stroke-width":0.8,opacity:.35}));
      grp.appendChild(el("line",{x1:bl.x+(tF.x-bl.x)*y,y1:bl.y+(tF.y-bl.y)*y,x2:br.x+(tB.x-br.x)*y,y2:br.y+(tB.y-br.y)*y,stroke:shade(base,-0.1),"stroke-width":0.8,opacity:.35}));
    }
  }
  // a single bright glazing band near the top for depth
  const gy=0.14;
  grp.appendChild(el("line",{x1:bt.x+(tL.x-bt.x)*gy,y1:bt.y+(tL.y-bt.y)*gy,x2:bl.x+(tF.x-bl.x)*gy,y2:bl.y+(tF.y-bl.y)*gy,stroke:shade(base,0.26),"stroke-width":1.4,opacity:.7}));
  grp.appendChild(el("line",{x1:bl.x+(tF.x-bl.x)*gy,y1:bl.y+(tF.y-bl.y)*gy,x2:br.x+(tB.x-br.x)*gy,y2:br.y+(tB.y-br.y)*gy,stroke:shade(base,0.12),"stroke-width":1.4,opacity:.7}));
  // vertical bay divisions
  for(let c=1;c<fp.w;c++){const a={x:bt.x+(bl.x-bt.x)*(c/fp.w),y:bt.y+(bl.y-bt.y)*(c/fp.w)};grp.appendChild(el("line",{x1:a.x,y1:a.y,x2:a.x,y2:a.y-H,stroke:shade(base,-0.22),"stroke-width":0.8,opacity:.4}));}
  for(let c=1;c<fp.d;c++){const a={x:bl.x+(br.x-bl.x)*(c/fp.d),y:bl.y+(br.y-bl.y)*(c/fp.d)};grp.appendChild(el("line",{x1:a.x,y1:a.y,x2:a.x,y2:a.y-H,stroke:shade(base,-0.08),"stroke-width":0.8,opacity:.35}));}
  roofDetail(grp,t.roof,tL,tR,tB,tF,H,base);
  g.appendChild(grp);
}

function roofDetail(g,kind,tL,tR,tB,tF,H,base){
  const cx=(tL.x+tB.x)/2, cy=(tL.y+tB.y)/2;
  const half=Math.abs(tR.x-tL.x)/2 || 24;
  const inset=(f)=>({
    L:{x:tL.x+(cx-tL.x)*f,y:tL.y+(cy-tL.y)*f}, R:{x:tR.x+(cx-tR.x)*f,y:tR.y+(cy-tR.y)*f},
    B:{x:tB.x+(cx-tB.x)*f,y:tB.y+(cy-tB.y)*f}, F:{x:tF.x+(cx-tF.x)*f,y:tF.y+(cy-tF.y)*f}});
  const lift=(p,h)=>({x:p.x,y:p.y-h});
  const box=(p,wx,wy,wh,c)=>{ // small iso cuboid centred near p
    const bl=lift(p,0); const corners=[{x:-wx,y:-wy},{x:wx,y:-wy},{x:wx,y:wy},{x:-wx,y:wy}]
      .map(d=>({x:p.x+ (d.x - d.y), y:p.y + (d.x + d.y)*0.5}));
    g.append(el("polygon",{points:corners.map(q=>`${q.x},${q.y-wh}`).join(" "),fill:shade(c,0.14),stroke:"#13382C","stroke-opacity":.4}));
    g.append(el("polygon",{points:`${corners[3].x},${corners[3].y} ${corners[2].x},${corners[2].y} ${corners[2].x},${corners[2].y-wh} ${corners[3].x},${corners[3].y-wh}`,fill:shade(c,-0.12)}));
    g.append(el("polygon",{points:`${corners[1].x},${corners[1].y} ${corners[2].x},${corners[2].y} ${corners[2].x},${corners[2].y-wh} ${corners[1].x},${corners[1].y-wh}`,fill:shade(c,-0.24)}));
  };
  if(kind==="pitch"){
    // hip roof; ridge runs parallel to the longer pair of eaves
    const eLR=Math.hypot(tR.x-tL.x,tR.y-tL.y), eFL=Math.hypot(tF.x-tL.x,tF.y-tL.y);
    const rh=11;
    const mid=(a,b)=>({x:(a.x+b.x)/2,y:(a.y+b.y)/2-rh});
    let rA,rB, hipA,hipB, slopeL,slopeR;
    if(eLR>=eFL){ // ridge between mid(tL,tF) and mid(tR,tB)
      rA=mid(tL,tF); rB=mid(tR,tB);
      hipA=[tL,tF,rA]; hipB=[tR,tB,rB];
      slopeL=[tL,tR,rB,rA]; slopeR=[tF,tB,rB,rA];
    } else { // ridge between mid(tL,tR) and mid(tF,tB)
      rA=mid(tL,tR); rB=mid(tF,tB);
      hipA=[tL,tR,rA]; hipB=[tF,tB,rB];
      slopeL=[tL,tF,rB,rA]; slopeR=[tR,tB,rB,rA];
    }
    const poly=(pts,sh)=>el("polygon",{points:pts.map(p=>p.x+","+p.y).join(" "),fill:shade(base,sh),stroke:"#15402F","stroke-opacity":.36,"stroke-linejoin":"round"});
    g.append(poly(hipA,0.04), poly(hipB,-0.22), poly(slopeL,0.18), poly(slopeR,-0.1),
      el("line",{x1:rA.x,y1:rA.y,x2:rB.x,y2:rB.y,stroke:"#15402F","stroke-opacity":.5,"stroke-width":1.1}));
  } else if(kind==="dome"){
    const dr=Math.min(half*0.62,18);
    // square drum
    box({x:cx,y:cy},dr*0.92,dr*0.46,9,base);
    const top=cy-9;
    g.append(
      el("ellipse",{cx,cy:top,rx:dr,ry:dr*0.5,fill:shade(base,-0.06),stroke:"#13382C","stroke-opacity":.4}),
      el("path",{d:`M ${cx-dr} ${top} Q ${cx-dr} ${top-dr*1.15} ${cx} ${top-dr*1.25} Q ${cx+dr} ${top-dr*1.15} ${cx+dr} ${top} Z`,
        fill:shade(base,0.2),stroke:"#13382C","stroke-opacity":.45}),
      el("path",{d:`M ${cx} ${top} Q ${cx-dr*0.4} ${top-dr*0.7} ${cx} ${top-dr*1.25}`,fill:"none",stroke:"#13382C","stroke-opacity":.25}),
      el("path",{d:`M ${cx} ${top} Q ${cx+dr*0.4} ${top-dr*0.7} ${cx} ${top-dr*1.25}`,fill:"none",stroke:"#13382C","stroke-opacity":.25}),
      el("circle",{cx,cy:top-dr*1.25,r:2.3,fill:shade(base,0.28),stroke:"#13382C","stroke-opacity":.4}),
      el("line",{x1:cx,y1:top-dr*1.25-2,x2:cx,y2:top-dr*1.25-9,stroke:"#13382C","stroke-width":1.2}));
  } else if(kind==="antenna"){
    const i=inset(.5);
    g.append(el("polygon",{points:`${i.L.x},${i.L.y} ${i.R.x},${i.R.y} ${i.B.x},${i.B.y} ${i.F.x},${i.F.y}`,fill:shade(base,0.06),stroke:"#13382C","stroke-opacity":.35}));
    box({x:cx-half*0.32,y:cy+half*0.16},5,2.6,7,base);   // plant room
    box({x:cx+half*0.28,y:cy-half*0.12},3,1.6,4,base);   // lift overrun
    g.append(el("line",{x1:cx+half*0.28,y1:cy-half*0.12-4,x2:cx+half*0.28,y2:cy-half*0.12-16,stroke:"#13382C","stroke-width":1,"stroke-opacity":.6}));
  } else if(kind==="units"){
    const i=inset(.6);
    g.append(el("polygon",{points:`${i.L.x},${i.L.y} ${i.R.x},${i.R.y} ${i.B.x},${i.B.y} ${i.F.x},${i.F.y}`,fill:shade(base,0.1),stroke:"#13382C","stroke-opacity":.35}));
    box({x:cx,y:cy},6,3,6,base);
    box({x:cx-half*0.45,y:cy+half*0.22},3,1.6,3.5,base);
  } else if(kind==="saw"){
    const bays=Math.max(3,Math.round((Math.hypot(tR.x-tL.x,tR.y-tL.y))/16));
    const ux=(tR.x-tL.x)/bays, uy=(tR.y-tL.y)/bays;
    const fx=tF.x-tL.x, fy=tF.y-tL.y;
    for(let k=0;k<bays;k++){
      const a={x:tL.x+ux*k,y:tL.y+uy*k}, b={x:tL.x+ux*(k+1),y:tL.y+uy*(k+1)};
      const ridge=10;
      // low flat then a glazed slope rising to a ridge
      g.append(el("polygon",{points:`${a.x},${a.y} ${b.x},${b.y} ${b.x+fx},${b.y+fy} ${a.x+fx},${a.y+fy}`,fill:shade(base,0.08)}));
      g.append(el("polygon",{points:`${a.x+fx*.5},${a.y+fy*.5} ${b.x+fx*.5},${b.y+fy*.5} ${b.x+fx},${b.y+fy-ridge} ${a.x+fx},${a.y+fy-ridge}`,
        fill:"#C7DDE0",stroke:"#13382C","stroke-opacity":.38}));
      g.append(el("line",{x1:a.x+fx,y1:a.y+fy-ridge,x2:b.x+fx,y2:b.y+fy-ridge,stroke:"#13382C","stroke-opacity":.4}));
    }
  } else if(kind==="skylight"){
    const i=inset(.5);g.append(el("polygon",{points:`${i.L.x},${i.L.y} ${i.R.x},${i.R.y} ${i.B.x},${i.B.y} ${i.F.x},${i.F.y}`,fill:"#C7DDE0",stroke:"#13382C","stroke-opacity":.4}));
    g.append(el("line",{x1:i.L.x,y1:i.L.y,x2:i.B.x,y2:i.B.y,stroke:"#174A3A","stroke-opacity":.3}),el("line",{x1:i.F.x,y1:i.F.y,x2:i.R.x,y2:i.R.y,stroke:"#174A3A","stroke-opacity":.3}));
  } else if(kind==="vault"){
    g.append(el("path",{d:`M ${tL.x} ${tL.y} Q ${cx} ${cy-22} ${tB.x} ${tB.y}`,fill:shade(base,0.18),stroke:"#13382C","stroke-opacity":.4}),
             el("path",{d:`M ${tF.x} ${tF.y} Q ${(tF.x+tR.x)/2} ${cy-22} ${tR.x} ${tR.y}`,fill:shade(base,0.1),stroke:"#13382C","stroke-opacity":.4}));
  } else if(kind==="tank"){
    g.append(el("ellipse",{cx,cy:cy-18,rx:Math.abs(tR.x-tL.x)/2.6,ry:7,fill:shade(base,0.22),stroke:"#13382C","stroke-opacity":.45}),
             el("rect",{x:cx-Math.abs(tR.x-tL.x)/2.6,y:cy-18,width:Math.abs(tR.x-tL.x)/1.3,height:12,fill:shade(base,0.05),stroke:"#13382C","stroke-opacity":.4}));
  } else if(kind==="deck"){
    g.append(el("polygon",{points:`${tL.x},${tL.y} ${tR.x},${tR.y} ${tB.x},${tB.y} ${tF.x},${tF.y}`,fill:shade(base,0.14)}));
    for(let k=1;k<6;k++){const a={x:tL.x+(tR.x-tL.x)*k/6,y:tL.y+(tR.y-tL.y)*k/6};g.append(el("line",{x1:a.x,y1:a.y,x2:a.x+(tF.x-tL.x),y2:a.y+(tF.y-tL.y),stroke:"#13382C","stroke-opacity":.3}));}
    g.append(el("line",{x1:tL.x,y1:tL.y-5,x2:tR.x,y2:tR.y-5,stroke:"#13382C","stroke-opacity":.4}));
  } else { // parapet
    const i=inset(.9);g.append(el("polygon",{points:`${i.L.x},${i.L.y} ${i.R.x},${i.R.y} ${i.B.x},${i.B.y} ${i.F.x},${i.F.y}`,fill:"none",stroke:"#13382C","stroke-opacity":.4,"stroke-width":2,transform:"translate(0 -3)"}));
  }
}

/* ---------- selection outline + handles + dim labels ---------- */
function drawSelection(g){
  if(!SELECTED) return;
  if(SELECTED.kind==="building"){
    const b=city.buildings.find(x=>x.id===SELECTED.id); if(!b) return;
    const t=BY[b.type], fp=footprint(b);
    const H=t.fl===0?0:floorsToH(b.fl);
    const base=[iso(b.gx,b.gy),iso(b.gx+fp.w,b.gy),iso(b.gx+fp.w,b.gy+fp.d),iso(b.gx,b.gy+fp.d)];
    const top=base.map(p=>({x:p.x,y:p.y-H}));
    // outline: footprint + vertical edges + roof
    g.appendChild(el("polygon",{points:base.map(p=>p.x+","+p.y).join(" "),class:"sel-outline"}));
    if(H){
      g.appendChild(el("polygon",{points:top.map(p=>p.x+","+p.y).join(" "),class:"sel-outline"}));
      [0,1,2,3].forEach(i=>g.appendChild(el("line",{x1:base[i].x,y1:base[i].y,x2:top[i].x,y2:top[i].y,stroke:accent,"stroke-width":1.4,"stroke-dasharray":"3 3",opacity:.8})));
    }
    // corner + edge handles on footprint
    const mids=[0,1,2,3].map(i=>({x:(base[i].x+base[(i+1)%4].x)/2,y:(base[i].y+base[(i+1)%4].y)/2}));
    [...base,...mids].forEach(p=>g.appendChild(el("rect",{x:p.x-4,y:p.y-4,width:8,height:8,rx:2,class:"sel-handle",transform:`rotate(26 ${p.x} ${p.y})`})));
    // rotation handle above roof
    const rc={x:(top[0].x+top[1].x)/2,y:Math.min(top[0].y,top[1].y)-22};
    g.appendChild(el("line",{x1:(top[0].x+top[1].x)/2,y1:(top[0].y+top[1].y)/2,x2:rc.x,y2:rc.y,stroke:accent,"stroke-width":1.2}));
    g.appendChild(el("circle",{cx:rc.x,cy:rc.y,r:5,class:"sel-handle rot"}));
    // dimension pills: width + depth + height
    dimLabel(g,base[0],base[1],fmtLen(fp.w),-16);
    dimLabel(g,base[0],base[3],fmtLen(fp.d),16);
    if(H) dimLabel(g,base[1],top[1],`${b.fl} FL`,18,true);
  } else if(SELECTED.kind==="road"){
    const path=city.roads[SELECTED.ri]; if(!path) return;
    let total=0;
    for(let i=0;i<path.length-1;i++){const a=path[i],b=path[i+1];const A=iso(a.gx,a.gy),B=iso(b.gx,b.gy);
      g.appendChild(el("line",{x1:A.x,y1:A.y,x2:B.x,y2:B.y,class:"sel-outline"}));
      [a,b].forEach(p=>{const s=iso(p.gx,p.gy);g.appendChild(el("rect",{x:s.x-4,y:s.y-4,width:8,height:8,rx:2,class:"sel-handle",transform:`rotate(26 ${s.x} ${s.y})`}));});
      total+=Math.abs(a.gx-b.gx)+Math.abs(a.gy-b.gy);}
    const mid=iso((path[0].gx+path[path.length-1].gx)/2,(path[0].gy+path[path.length-1].gy)/2);
    pill(g,mid.x,mid.y-14,`RUN ${fmtLen(total)}`);
  }
}
function dimLabel(g,a,b,text,off){
  const mx=(a.x+b.x)/2, my=(a.y+b.y)/2;
  const dx=b.x-a.x, dy=b.y-a.y, len=Math.hypot(dx,dy)||1;
  const nx=-dy/len*off, ny=dx/len*off;
  g.appendChild(el("line",{x1:a.x,y1:a.y,x2:b.x,y2:b.y,stroke:accent,"stroke-width":1,"stroke-dasharray":"1 3",opacity:.7}));
  pill(g,mx+nx,my+ny,text);
}
function pill(g,x,y,text){
  const w=text.length*6.6+14;
  g.appendChild(el("rect",{x:x-w/2,y:y-9,width:w,height:18,rx:9,class:"dim-pill"}));
  const tx=el("text",{x:x,y:y+4,"text-anchor":"middle",class:"dim-label"});tx.textContent=text;g.appendChild(tx);
}

/* ---------- measurements ---------- */
let measureA=null;
function drawMeasures(g){
  city.measures.forEach((m,i)=>{
    const A=iso(m.a.gx,m.a.gy),B=iso(m.b.gx,m.b.gy);
    g.appendChild(el("line",{x1:A.x,y1:A.y,x2:B.x,y2:B.y,class:"measure-line"}));
    [A,B].forEach(p=>g.appendChild(el("circle",{cx:p.x,cy:p.y,r:3.2,class:"measure-cap"})));
    const cells=Math.hypot(m.a.gx-m.b.gx,m.a.gy-m.b.gy);
    pill(g,(A.x+B.x)/2,(A.y+B.y)/2-12,fmtLen(cells));
  });
  if(measureA){const A=iso(measureA.gx,measureA.gy);g.appendChild(el("circle",{cx:A.x,cy:A.y,r:3.4,class:"measure-cap"}));}
}
function renderMeasureList(){
  const box=$("#measure-list");
  if(!city.measures.length){box.innerHTML='<div class="muted" style="font-size:10.5px;letter-spacing:.14em;text-transform:uppercase;">No measurements yet</div>';return;}
  box.innerHTML=city.measures.map((m,i)=>{
    const cells=Math.hypot(m.a.gx-m.b.gx,m.a.gy-m.b.gy);
    return `<div class="mrow"><span>Segment ${String.fromCharCode(65+i)}</span><span>${fmtLen(cells)}</span></div>`;}).join("");
}

/* ======================================================= *
 *  INTERACTION
 * ======================================================= */
const wrap=$("#canvas-wrap"), stage=$("#stage");
function screenToGrid(ev){
  const r=scene.getBoundingClientRect();
  const sx=(ev.clientX-r.left)/zoom, sy=(ev.clientY-r.top)/zoom;
  const dx=(sx-originX), dy=(sy-PAD);
  const gx=(dx/(TW/2)+dy/(TH/2))/2, gy=(dy/(TH/2)-dx/(TW/2))/2;
  return {gx,gy};
}
const snap=p=>({gx:clamp(Math.round(p.gx),0,GRID_W),gy:clamp(Math.round(p.gy),0,GRID_H)});

function setTool(t){
  TOOL=t; ARMED=null;
  $$(".tool").forEach(b=>b.classList.toggle("on",b.dataset.tool===t));
  $$(".lib-card").forEach(c=>c.classList.remove("armed"));
  wrap.className="canvas-wrap"+(t==="pan"?" pan":"")+(["road","park","measure"].includes(t)?" tool-"+t:"");
  measureA=null; roadStart=null; parkStart=null;
}
$$(".tool").forEach(b=>b.addEventListener("click",()=>setTool(b.dataset.tool)));

/* library */
function buildLibrary(){
  const cats=$("#lib-cats"); cats.innerHTML="";
  let active="All";
  const renderGrid=()=>{
    const grid=$("#lib-grid"); grid.innerHTML="";
    const items=BTYPES.filter(t=>active==="All"||t.cat===active);
    $("#lib-count").textContent=String(items.length).padStart(2,"0");
    items.forEach(t=>{
      const card=document.createElement("button");
      card.className="lib-card"; card.dataset.type=t.id;
      card.innerHTML=`${libThumb(t)}<div class="nm">${t.name}</div>`;
      card.addEventListener("click",()=>{
        $$(".lib-card").forEach(c=>c.classList.remove("armed"));
        card.classList.add("armed"); ARMED=t.id; TOOL="place";
        $$(".tool").forEach(b=>b.classList.remove("on"));
        wrap.className="canvas-wrap armed";
        toast("Placing · "+t.name);
      });
      grid.appendChild(card);
    });
  };
  CATS.forEach(c=>{const b=document.createElement("button");b.textContent=c;if(c==="All")b.classList.add("on");
    b.addEventListener("click",()=>{active=c;$$("#lib-cats button").forEach(x=>x.classList.toggle("on",x===b));renderGrid();});
    cats.appendChild(b);});
  renderGrid();
}
function libThumb(t){
  // tiny isometric preview
  const s=42, ox=s, oy=8, tw=22, th=11, H=t.fl===0?0:Math.min(t.fl,10)*2.4+6;
  const P=(gx,gy)=>`${ox+(gx-gy)*tw/2},${oy+(gx+gy)*th/2}`;
  const U=(gx,gy)=>`${ox+(gx-gy)*tw/2},${oy+(gx+gy)*th/2-H}`;
  const base=t.col;
  if(t.fl===0){
    return `<svg viewBox="0 0 ${s*2} ${s}"><polygon points="${P(0,0)} ${P(t.w,0)} ${P(t.w,t.d)} ${P(0,t.d)}" fill="${base}" fill-opacity=".9" stroke="#13382C" stroke-opacity=".4"/>
      <circle cx="${ox}" cy="${oy+((t.w+t.d)/2)*th/2-3}" r="5" fill="#5E8D57"/><circle cx="${ox+8}" cy="${oy+((t.w+t.d)/2)*th/2}" r="4" fill="#6E9E65"/></svg>`;
  }
  return `<svg viewBox="0 0 ${s*2} ${s}">
    <polygon points="${P(0,0)} ${U(0,0)} ${U(0,t.d)} ${P(0,t.d)}" fill="${shade(base,-0.28)}" stroke="#13382C" stroke-opacity=".45"/>
    <polygon points="${P(0,t.d)} ${U(0,t.d)} ${U(t.w,t.d)} ${P(t.w,t.d)}" fill="${shade(base,-0.12)}" stroke="#13382C" stroke-opacity=".45"/>
    <polygon points="${U(0,0)} ${U(t.w,0)} ${U(t.w,t.d)} ${U(0,t.d)}" fill="${shade(base,0.12)}" stroke="#13382C" stroke-opacity=".45"/></svg>`;
}

/* place / select / road / park / measure dispatch */
let roadStart=null, parkStart=null, dragState=null;

wrap.addEventListener("pointerdown",e=>{
  if(e.button!==0) return;
  const g=screenToGrid(e), s=snap(g);
  const hit=e.target.closest(".pick");
  if(TOOL==="pan"){ startPan(e); return; }
  if(TOOL==="place"&&ARMED){
    const t=BY[ARMED];
    city.buildings.push({id:uid(),type:ARMED,gx:clamp(s.gx,0,GRID_W-t.w),gy:clamp(s.gy,0,GRID_H-t.d),rot:0,name:t.name,fl:t.fl});
    markDirty(); drawScene(); toast(t.name+" placed"); return;
  }
  if(TOOL==="road"){
    if(!roadStart){roadStart=s;} else {
      const a=roadStart,b=s; const mid={gx:b.gx,gy:a.gy};
      city.roads.push([a, mid, b]); roadStart=null; markDirty(); drawScene(); toast("Road traced");
    } return;
  }
  if(TOOL==="park"){ parkStart=s; dragState={mode:"park"}; drawGhostPark(s,s); return; }
  if(TOOL==="measure"){
    if(!measureA){measureA=g;}
    else { city.measures.push({a:measureA,b:g}); measureA=null; markDirty(); drawScene(); renderMeasureList(); }
    return;
  }
  if(TOOL==="delete"){
    if(hit){ removeHit(hit); } return;
  }
  // select tool
  if(hit){
    if(hit.dataset.kind==="building"){
      select({kind:"building",id:hit.dataset.id});
      const b=city.buildings.find(x=>x.id===hit.dataset.id);
      dragState={mode:"move",id:b.id,start:g,orig:{gx:b.gx,gy:b.gy}};
      wrap.setPointerCapture(e.pointerId);
    } else if(hit.dataset.kind==="road"){
      select({kind:"road",ri:+hit.dataset.ri});
    }
  } else { select(null); }
});

wrap.addEventListener("pointermove",e=>{
  if(dragState?.mode==="pan"){ doPan(e); return; }
  const g=screenToGrid(e);
  if(dragState?.mode==="move"){
    const b=city.buildings.find(x=>x.id===dragState.id); if(!b) return;
    const t=BY[b.type];
    b.gx=clamp(Math.round(dragState.orig.gx+(g.gx-dragState.start.gx)),0,GRID_W-t.w);
    b.gy=clamp(Math.round(dragState.orig.gy+(g.gy-dragState.start.gy)),0,GRID_H-t.d);
    markDirty(); drawScene(); return;
  }
  if(dragState?.mode==="park"&&parkStart){ drawGhostPark(parkStart,snap(g)); return; }
  if(TOOL==="measure"&&measureA){ drawScene(); const ov=$("#overlay");
    const A=iso(measureA.gx,measureA.gy),B=iso(g.gx,g.gy);
    ov.appendChild(el("line",{x1:A.x,y1:A.y,x2:B.x,y2:B.y,class:"measure-line ghost"}));
    pill(ov,(A.x+B.x)/2,(A.y+B.y)/2-12,fmtLen(Math.hypot(measureA.gx-g.gx,measureA.gy-g.gy)));
  }
  if(TOOL==="road"&&roadStart){ drawScene(); const ov=$("#overlay"); const s=snap(g);
    const A=iso(roadStart.gx,roadStart.gy),M=iso(s.gx,roadStart.gy),B=iso(s.gx,s.gy);
    ov.appendChild(el("polyline",{points:`${A.x},${A.y} ${M.x},${M.y} ${B.x},${B.y}`,fill:"none",stroke:accent,"stroke-width":2,"stroke-dasharray":"4 4"}));
  }
});
wrap.addEventListener("pointerup",e=>{
  if(dragState?.mode==="park"&&parkStart){
    const b=snap(screenToGrid(e));
    const x=Math.min(parkStart.gx,b.gx),y=Math.min(parkStart.gy,b.gy);
    const w=Math.max(1,Math.abs(b.gx-parkStart.gx)),d=Math.max(1,Math.abs(b.gy-parkStart.gy));
    const kind=(w*d>=9)?"park":"garden";
    city.buildings.push({id:uid(),type:kind,gx:x,gy:y,rot:0,name:kind==="park"?"New Park":"Pocket Garden",fl:0,cw:w,cd:d});
    parkStart=null; dragState=null; markDirty(); drawScene(); toast("Green space added"); return;
  }
  dragState=null;
});
function drawGhostPark(a,b){
  drawScene(); const ov=$("#overlay");
  const x=Math.min(a.gx,b.gx),y=Math.min(a.gy,b.gy),w=Math.abs(a.gx-b.gx)||1,d=Math.abs(a.gy-b.gy)||1;
  ov.appendChild(el("polygon",{points:quad(x,y,w,d),fill:"#78A071","fill-opacity":.4,stroke:accent,"stroke-width":2,"stroke-dasharray":"4 4"}));
  pill(ov,iso(x+w/2,y+d/2).x,iso(x+w/2,y+d/2).y,`${fmtLen(w)} × ${fmtLen(d)}`);
}
function removeHit(hit){
  if(hit.dataset.kind==="building"){ city.buildings=city.buildings.filter(b=>b.id!==hit.dataset.id); }
  else if(hit.dataset.kind==="road"){ city.roads.splice(+hit.dataset.ri,1); }
  select(null); markDirty(); drawScene(); toast("Removed");
}

/* account for custom-sized parks in footprint */
const origFoot=footprint;
// eslint-disable-next-line no-func-assign
footprint=function(b){const t=BY[b.type];if(t.fl===0&&b.cw){const r=((b.rot%4)+4)%4;return r%2?{w:b.cd,d:b.cw}:{w:b.cw,d:b.cd};}return origFoot(b);};

/* selection + properties panel */
function select(sel){
  SELECTED=sel; drawScene(); renderProps();
}
function renderProps(){
  const body=$("#prop-body"), idLabel=$("#prop-id");
  if(!SELECTED){ idLabel.textContent="—";
    body.innerHTML='<div class="prop-empty">No object selected.<br>Pick a building, road or park on the canvas to edit its measurements and placement.</div>'; return; }
  if(SELECTED.kind==="building"){
    const b=city.buildings.find(x=>x.id===SELECTED.id); if(!b){select(null);return;}
    const t=BY[b.type], fp=footprint(b);
    idLabel.textContent=b.id.toUpperCase().slice(0,6);
    const isGreen=t.fl===0;
    body.innerHTML=`
      <div class="prow"><label>Name</label><input class="prop-field" id="p-name" value="${b.name}"></div>
      <div class="prow"><label>Type</label><span class="val">${t.name}</span></div>
      <div class="prow"><label>District</label><span class="val">${districtOf(b)}</span></div>
      <div class="prow"><label>Footprint</label><span class="val">${fmtLen(fp.w)} × ${fmtLen(fp.d)}</span></div>
      ${isGreen?"":`<div class="prow"><label>Floors</label><div class="stepper"><button id="fl-dn">−</button><span class="n" id="fl-n">${b.fl}</span><button id="fl-up">+</button></div></div>
      <div class="prow"><label>Height</label><span class="val">${fmtLen(b.fl*0.5)}</span></div>`}
      <div class="prow"><label>Grid position</label><span class="val">${b.gx}, ${b.gy}</span></div>
      <div class="prow"><label>Rotation</label><div class="stepper"><button id="rot-l">⟲</button><span class="n">${b.rot*90}°</span><button id="rot-r">⟳</button></div></div>
      <div class="prop-actions"><button class="btn ghost" id="p-dup">Duplicate</button><button class="btn" id="p-del" style="background:#8a3a30">Delete</button></div>
      <div class="mini-legend"><span class="layer-dot" style="background:${t.col}"></span>${isGreen?"Landscape element":"Occupied structure"}</div>`;
    $("#p-name").addEventListener("input",e=>{b.name=e.target.value;markDirty();});
    if(!isGreen){
      $("#fl-up").onclick=()=>{b.fl=clamp(b.fl+1,1,40);markDirty();drawScene();renderProps();};
      $("#fl-dn").onclick=()=>{b.fl=clamp(b.fl-1,1,40);markDirty();drawScene();renderProps();};
    }
    $("#rot-l").onclick=()=>{b.rot=(b.rot+3)%4;fitBuilding(b);markDirty();drawScene();renderProps();};
    $("#rot-r").onclick=()=>{b.rot=(b.rot+1)%4;fitBuilding(b);markDirty();drawScene();renderProps();};
    $("#p-dup").onclick=()=>{const n={...b,id:uid(),gx:clamp(b.gx+2,0,GRID_W-1),gy:clamp(b.gy+1,0,GRID_H-1)};city.buildings.push(n);select({kind:"building",id:n.id});markDirty();toast("Duplicated");};
    $("#p-del").onclick=()=>{city.buildings=city.buildings.filter(x=>x.id!==b.id);select(null);markDirty();drawScene();toast("Deleted");};
  } else if(SELECTED.kind==="road"){
    const path=city.roads[SELECTED.ri]; if(!path){select(null);return;}
    let len=0;for(let i=0;i<path.length-1;i++)len+=Math.abs(path[i].gx-path[i+1].gx)+Math.abs(path[i].gy-path[i+1].gy);
    idLabel.textContent="ROAD "+String(SELECTED.ri+1).padStart(2,"0");
    body.innerHTML=`
      <div class="prow"><label>Class</label><span class="val">Secondary boulevard</span></div>
      <div class="prow"><label>Run</label><span class="val">${fmtLen(len)}</span></div>
      <div class="prow"><label>Lanes</label><div class="stepper"><button id="ln-dn">−</button><span class="n">2</span><button id="ln-up">+</button></div></div>
      <div class="prow"><label>Verge planting</label><div class="toggle on" data-toggle></div></div>
      <div class="prop-actions"><button class="btn ghost" id="r-dup">Duplicate</button><button class="btn" id="r-del" style="background:#8a3a30">Delete</button></div>
      <div class="mini-legend"><span class="layer-dot" style="background:#C9BBA0"></span>Roads &amp; mobility layer</div>`;
    $("#r-del").onclick=()=>{city.roads.splice(SELECTED.ri,1);select(null);markDirty();drawScene();toast("Road removed");};
    $("#r-dup").onclick=()=>{city.roads.push(path.map(p=>({gx:p.gx,gy:clamp(p.gy+2,0,GRID_H)})));markDirty();drawScene();toast("Road duplicated");};
    $$('[data-toggle]',body).forEach(t=>t.onclick=()=>t.classList.toggle("on"));
  }
}
function fitBuilding(b){const fp=footprint(b);b.gx=clamp(b.gx,0,GRID_W-fp.w);b.gy=clamp(b.gy,0,GRID_H-fp.d);}
function districtOf(b){const cx=b.gx+0.5,cy=b.gy+0.5;
  const d=DISTRICTS.find(z=>cx>=z.x&&cx<=z.x+z.w&&cy>=z.y&&cy<=z.y+z.h);return d?d.name:"Unzoned";}

/* layers */
function buildLayers(){
  const box=$("#layer-body");
  const defs=[
    ["grid","Isometric grid","#174A3A33"],["zoning","District zoning","var(--d-civic-l)"],
    ["green","Green space","#78A071"],["roads","Roads & mobility","#C9BBA0"],
    ["labels","Place labels","#174A3A"],["shadows","Cast shadows","#174A3A55"],
  ];
  box.innerHTML="";
  defs.forEach(([key,name,col])=>{
    const row=document.createElement("div"); row.className="layer-row";
    row.innerHTML=`<span class="layer-dot" style="background:${col}"></span><span class="sw">${name}</span><div class="toggle ${LAYERS[key]?"on":""}"></div>`;
    row.querySelector(".toggle").addEventListener("click",()=>{
      LAYERS[key]=!LAYERS[key]; row.querySelector(".toggle").classList.toggle("on",LAYERS[key]); drawScene();
    });
    box.appendChild(row);
  });
}
$("#clear-measure").onclick=()=>{city.measures=[];drawScene();renderMeasureList();toast("Measurements cleared");};

/* zoom + pan */
const RAIL_L=264, RAIL_R=294; // library + right rail widths
function applyZoom(){stage.style.transform=`scale(${zoom})`;$("#zoom-lvl").textContent=Math.round(zoom*100)+"%";}
$("#zoom-in").onclick=()=>{zoom=clamp(zoom*1.12,0.4,2.4);applyZoom();};
$("#zoom-out").onclick=()=>{zoom=clamp(zoom/1.12,0.4,2.4);applyZoom();};
$("#zoom-fit").onclick=()=>fitScene();
wrap.addEventListener("wheel",e=>{if(!e.ctrlKey&&!e.metaKey)return;e.preventDefault();zoom=clamp(zoom*(e.deltaY<0?1.1:0.9),0.4,2.4);applyZoom();},{passive:false});
function contentBox(){
  const w=(GRID_W+GRID_H)*TW/2, h=(GRID_W+GRID_H)*TH/2;
  const top=110; // tallest tower rises above grid
  return {cx:PAD + w/2, cy:PAD - top/2 + h/2, w:w+80, h:h+top+60};
}
function fitScene(){
  const box=contentBox();
  const vw=wrap.clientWidth-RAIL_L-RAIL_R-24, vh=wrap.clientHeight-48;
  zoom=clamp(Math.min(vw/box.w*1.16, vh/box.h), 0.4, 1.7);
  applyZoom(); requestAnimationFrame(centerScene);
}
function centerScene(){
  const box=contentBox();
  const cx=RAIL_L + (wrap.clientWidth-RAIL_L-RAIL_R)/2;
  const cy=wrap.clientHeight/2 - 18;
  wrap.scrollLeft=box.cx*zoom - cx;
  wrap.scrollTop =box.cy*zoom - cy;
}
function startPan(e){dragState={mode:"pan",x:e.clientX,y:e.clientY,sl:wrap.scrollLeft,st:wrap.scrollTop};wrap.classList.add("panning");wrap.setPointerCapture(e.pointerId);}
function doPan(e){wrap.scrollLeft=dragState.sl-(e.clientX-dragState.x);wrap.scrollTop=dragState.st-(e.clientY-dragState.y);}
window.addEventListener("pointerup",()=>{if(dragState?.mode==="pan"){wrap.classList.remove("panning");}});

/* keyboard */
window.addEventListener("keydown",e=>{
  if(document.activeElement.tagName==="INPUT") return;
  const k=e.key.toLowerCase();
  if(k==="v")setTool("select"); else if(k==="h")setTool("pan");
  else if(k==="r")setTool("road"); else if(k==="p")setTool("park");
  else if(k==="m")setTool("measure");
  else if(k==="escape"){select(null);setTool("select");}
  else if((k==="delete"||k==="backspace")&&SELECTED){
    if(SELECTED.kind==="building")city.buildings=city.buildings.filter(b=>b.id!==SELECTED.id);
    else city.roads.splice(SELECTED.ri,1);
    select(null);markDirty();drawScene();
  }
});

/* ======================================================= *
 *  PROJECT GALLERY
 * ======================================================= */
const FOLDERS=["Masterplans","Studies","Competitions"];
let projects=[
  {id:"pr1",title:"Rivermouth Masterplan",folder:"Masterplans",updated:"Updated 2 days ago",seed:7,tag:"Mixed-use · river",blds:34,districts:4},
  {id:"pr2",title:"Northgate Transit Quarter",folder:"Masterplans",updated:"Updated last week",seed:13,tag:"Transit-oriented",blds:41,districts:5},
  {id:"pr3",title:"Lumen Cultural Mile",folder:"Competitions",updated:"Updated 3 weeks ago",seed:21,tag:"Civic competition",blds:22,districts:3},
  {id:"pr4",title:"Orchard Low-Rise Study",folder:"Studies",updated:"Updated 1 month ago",seed:29,tag:"Residential density",blds:28,districts:2},
  {id:"pr5",title:"Saltmarsh Eco-Campus",folder:"Studies",updated:"Updated 1 month ago",seed:33,tag:"Landscape-led",blds:17,districts:3},
  {id:"pr6",title:"Beacon Harbour Revival",folder:"Competitions",updated:"Updated 6 weeks ago",seed:41,tag:"Waterfront",blds:36,districts:4},
];
let folderFilter="all", sortRecent=true;

function previewSVG(seed){
  let s=(seed>>>0)||1; const rnd=()=>{s=(s*1664525+1013904223)>>>0;return s/4294967296;};
  const N=12, W=340, Hh=212, tw=24, th=12, ox=W/2, oy=22;
  const P=(gx,gy,h=0)=>`${(ox+(gx-gy)*tw/2).toFixed(1)},${(oy+(gx+gy)*th/2-h).toFixed(1)}`;
  let o=`<svg viewBox="0 0 ${W} ${Hh}" preserveAspectRatio="xMidYMid slice"><rect width="${W}" height="${Hh}" fill="#E4EFE7"/>`;
  o+=`<polygon points="${P(0,0)} ${P(N,0)} ${P(N,N)} ${P(0,N)}" fill="#E0EDE4"/>`;
  const tints=["#DCEBE1","#E4EEDC","#EDE7DA","#E7E3DE"], rm=N/2;
  for(let q=0;q<4;q++){const qx=(q%2)*rm, qy=((q/2)|0)*rm;
    o+=`<polygon points="${P(qx,qy)} ${P(qx+rm,qy)} ${P(qx+rm,qy+rm)} ${P(qx,qy+rm)}" fill="${tints[q]}"/>`;}
  const rv=0.55+rnd()*0.35;
  o+=`<polygon points="${P(N*rv,0)} ${P(N*rv+0.9,0)} ${P(N*rv+0.6,N)} ${P(N*rv-0.3,N)}" fill="#BCDEE1"/>`;
  for(let i=0;i<=N;i+=2){o+=`<line x1="${ox+(i-N)*tw/2}" y1="${oy+i*th/2}" x2="${ox+i*tw/2}" y2="${oy+(i+N)*th/2}" stroke="#174A3A" stroke-opacity=".05"/>`;
    o+=`<line x1="${ox-i*tw/2}" y1="${oy+i*th/2}" x2="${ox+(N-i)*tw/2}" y2="${oy+(i+N)*th/2}" stroke="#174A3A" stroke-opacity=".05"/>`;}
  o+=`<polygon points="${P(0,rm-.2)} ${P(N,rm-.2)} ${P(N,rm+.2)} ${P(0,rm+.2)}" fill="#C9BBA0"/>`;
  o+=`<polygon points="${P(rm-.2,0)} ${P(rm-.2,N)} ${P(rm+.2,N)} ${P(rm+.2,0)}" fill="#C9BBA0"/>`;
  const pal=["#6E8FA6","#C98F6B","#B7BDC2","#7E93A0","#D3A98A","#9AA7A1","#AEB7AE"];
  const cells=[]; for(let x=0;x<N;x++)for(let y=0;y<N;y++)cells.push([x,y]);
  cells.sort((a,b)=>(a[0]+a[1])-(b[0]+b[1]));
  const blockH={};
  for(const[x,y]of cells){
    if(Math.abs(x-rm)<0.6||Math.abs(y-rm)<0.6) continue;
    const bk=((x/3)|0)+"_"+((y/3)|0);
    if(!(bk in blockH)) blockH[bk]=7+rnd()*rnd()*32;
    const v=rnd();
    if(v<0.15){const c=P(x+.5,y+.5).split(",");
      o+=`<ellipse cx="${c[0]}" cy="${c[1]}" rx="7.5" ry="3.6" fill="#CFE2C9"/><circle cx="${c[0]}" cy="${+c[1]-3}" r="4" fill="#5E8D57"/>`;continue;}
    if(v>0.80) continue;
    const h=(v<0.28? 28+rnd()*34 : blockH[bk])+rnd()*4, col=pal[(rnd()*pal.length)|0];
    o+=`<polygon points="${P(x,y+1)} ${P(x,y+1,h)} ${P(x+1,y+1,h)} ${P(x+1,y+1)}" fill="${shade(col,-0.34)}"/>`;
    o+=`<polygon points="${P(x+1,y+1)} ${P(x+1,y+1,h)} ${P(x+1,y,h)} ${P(x+1,y)}" fill="${shade(col,-0.14)}"/>`;
    o+=`<polygon points="${P(x,y,h)} ${P(x+1,y,h)} ${P(x+1,y+1,h)} ${P(x,y+1,h)}" fill="${shade(col,0.14)}"/>`;
  }
  return o+`</svg>`;
}

function renderGallery(){
  const grid=$("#gallery"); grid.innerHTML="";
  let list=projects.filter(p=>folderFilter==="all"||p.folder===folderFilter);
  if(!sortRecent)list=[...list].sort((a,b)=>a.title.localeCompare(b.title));
  list.forEach(p=>{
    const card=document.createElement("div"); card.className="pcard"; card.draggable=true;
    card.innerHTML=`
      <div class="prev">${previewSVG(p.seed)}<span class="tagline">${p.tag}</span></div>
      <div class="meta">
        <h3>${p.title}</h3>
        <div class="ln">${p.folder} · ${p.updated}</div>
        <div class="stat-line"><span>${p.blds} structures</span><span>${p.districts} districts</span><span>Lorem ipsum</span></div>
        <div class="acts">
          <button data-a="open">Open</button><button data-a="dup">Duplicate</button>
          <button data-a="rename">Rename</button><button data-a="del" class="danger">Delete</button>
        </div></div>`;
    card.querySelector('[data-a="open"]').onclick=e=>{e.stopPropagation();city.title=p.title;$("#proj-title").value=p.title;go("studio");setTimeout(centerScene,80);toast("Opened · "+p.title);};
    card.querySelector('[data-a="dup"]').onclick=e=>{e.stopPropagation();projects.unshift({...p,id:uid(),title:p.title+" (copy)",updated:"Updated just now"});renderGallery();updateStats();toast("Project duplicated");};
    card.querySelector('[data-a="rename"]').onclick=e=>{e.stopPropagation();const n=prompt("Rename project",p.title);if(n){p.title=n;renderGallery();}};
    card.querySelector('[data-a="del"]').onclick=e=>{e.stopPropagation();projects=projects.filter(x=>x.id!==p.id);renderGallery();updateStats();toast("Project deleted");};
    card.onclick=()=>{city.title=p.title;$("#proj-title").value=p.title;go("studio");setTimeout(centerScene,80);};
    card.addEventListener("dragstart",()=>card.classList.add("ghost"));
    card.addEventListener("dragend",()=>card.classList.remove("ghost"));
    card.addEventListener("dragover",e=>e.preventDefault());
    card.addEventListener("drop",e=>{e.preventDefault();const dragging=$(".pcard.ghost");if(!dragging||dragging===card)return;
      const a=[...grid.children].indexOf(dragging),b=[...grid.children].indexOf(card);
      const ids=[...grid.children].map(c=>c); grid.insertBefore(dragging, b>a?card.nextSibling:card);
      projects=[...grid.children].map(c=>projects.find(pp=>pp.title===c.querySelector("h3").textContent));toast("Reordered");});
    grid.appendChild(card);
  });
  const add=document.createElement("div"); add.className="pcard new";
  add.innerHTML=`<div class="plus">＋</div><span>Start a new city</span>`;
  add.onclick=()=>{city=seedCity();city.buildings=[];city.roads=[];$("#proj-title").value="Untitled Masterplan";city.title="Untitled Masterplan";go("studio");drawScene();setTimeout(centerScene,80);toast("Blank canvas ready");};
  grid.appendChild(add);
}
function updateStats(){
  $("#st-projects").textContent=projects.length;
  $("#st-buildings").textContent=projects.reduce((s,p)=>s+p.blds,0)+city.buildings.length;
}
$("#folder-tabs").addEventListener("click",e=>{const b=e.target.closest("button");if(!b)return;
  folderFilter=b.dataset.folder;$$("#folder-tabs button").forEach(x=>x.classList.toggle("on",x===b));renderGallery();});
$("#profile-sort").onclick=()=>{sortRecent=!sortRecent;$("#profile-sort").textContent=sortRecent?"Sort · Recent":"Sort · A–Z";renderGallery();};

/* ======================================================= *
 *  NAV + AUTH
 * ======================================================= */
function go(v){document.body.dataset.view=v;
  if(v==="studio"){requestAnimationFrame(()=>requestAnimationFrame(centerScene));}}
$("#tab-register").onclick=()=>{$("#tab-register").classList.add("on");$("#tab-signin").classList.remove("on");$$("[data-reg]").forEach(x=>x.style.display="");};
$("#tab-signin").onclick=()=>{$("#tab-signin").classList.add("on");$("#tab-register").classList.remove("on");$$("[data-reg]").forEach(x=>x.style.display="none");};
$("#auth-go").onclick=()=>{
  const name=$("#f-name").value.trim()||"Atelier Vega";
  $("#profile-name").textContent=name;
  $("#avatar-top").textContent=name.split(/\s+/).map(w=>w[0]).join("").slice(0,2).toUpperCase();
  go("studio"); requestAnimationFrame(()=>requestAnimationFrame(fitScene));
};
$("#btn-profile").onclick=()=>{updateStats();renderGallery();go("profile");};
$("#btn-settings").onclick=()=>go("settings");
$("#avatar-top").onclick=()=>{updateStats();renderGallery();go("profile");};
$("#profile-back").onclick=()=>go("studio");
$("#settings-back").onclick=()=>go("studio");
$("#btn-save").onclick=()=>{markClean();city.title=$("#proj-title").value;
  const ex=projects.find(p=>p.title===city.title);
  if(ex){ex.updated="Updated just now";ex.blds=city.buildings.length;}
  toast("Masterplan saved");};
$("#btn-snapshot").onclick=()=>{
  const t=$("#proj-title").value||"Untitled";
  projects.unshift({id:uid(),title:t+" — snapshot",folder:"Studies",updated:"Updated just now",
    seed:(Math.random()*97)|0,tag:"Canvas snapshot",blds:city.buildings.length,districts:DISTRICTS.length});
  markClean(); toast("Snapshot added to gallery");
};
$("#proj-title").addEventListener("input",markDirty);
$("#proj-title").addEventListener("change",e=>city.title=e.target.value);

/* settings interactions */
$$(".settings-nav button").forEach(b=>b.onclick=()=>$$(".settings-nav button").forEach(x=>x.classList.toggle("on",x===b)));
$$(".seg").forEach(seg=>seg.addEventListener("click",e=>{const b=e.target.closest("button");if(!b)return;
  [...seg.children].forEach(x=>x.classList.toggle("on",x===b));
  if(b.dataset.unit){units=b.dataset.unit;drawScene();renderProps();renderMeasureList();toast("Units · "+(units==="m"?"metric":"imperial"));}}));
$$("[data-toggle]").forEach(t=>t.onclick=()=>t.classList.toggle("on"));
$("#accent-swatches").addEventListener("click",e=>{const sw=e.target.closest(".sw");if(!sw)return;
  $$("#accent-swatches .sw").forEach(x=>x.classList.toggle("on",x===sw));
  accent=sw.dataset.accent;document.documentElement.style.setProperty("--sel",accent);
  document.documentElement.style.setProperty("--sel-soft",accent+"22");drawScene();});

/* ---------- boot ---------- */
buildLibrary(); buildLayers(); drawScene(); renderMeasureList(); applyZoom();
updateStats(); renderGallery();
window.addEventListener("resize",()=>{if(document.body.dataset.view==="studio")centerScene();});
})();
</script>
</body>
</html>
