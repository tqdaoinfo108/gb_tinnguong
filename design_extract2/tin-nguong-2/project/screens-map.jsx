// screens-map.jsx — Bản đồ GIS + popup cơ sở

// Map background with polygon boundary + scattered religion markers
function MapCanvas({ dim = false, showPopup = false }) {
  return (
    <div style={{ position: 'absolute', inset: 0, overflow: 'hidden' }}>
      {/* base */}
      <div className="map-bg" style={{ position: 'absolute', inset: 0 }} />

      {/* street network suggestion */}
      <svg style={{ position: 'absolute', inset: 0, width: '100%', height: '100%' }} viewBox="0 0 402 874" preserveAspectRatio="xMidYMid slice">
        {/* "rivers"/main roads */}
        <path d="M-20 220 Q 80 200 200 240 T 420 290" stroke="#cdc4ad" strokeWidth="14" fill="none" opacity="0.55" />
        <path d="M-20 220 Q 80 200 200 240 T 420 290" stroke="#fff" strokeWidth="2" fill="none" opacity="0.6" />
        <path d="M-20 580 Q 100 540 220 600 T 420 660" stroke="#cdc4ad" strokeWidth="10" fill="none" opacity="0.5" />
        <path d="M-20 580 Q 100 540 220 600 T 420 660" stroke="#fff" strokeWidth="1.5" fill="none" opacity="0.6" />
        {/* cross streets */}
        <path d="M120 -20 L 80 900" stroke="#d4cdb6" strokeWidth="6" fill="none" opacity="0.4" />
        <path d="M280 -20 L 320 900" stroke="#d4cdb6" strokeWidth="6" fill="none" opacity="0.4" />

        {/* boundary polygon — ward outline */}
        <path
          d="M 30 140 L 360 110 L 380 410 L 350 700 L 60 740 L 20 480 Z"
          fill="rgba(59,111,160,0.06)"
          stroke="#3b6fa0"
          strokeWidth="2.5"
          strokeDasharray="6 4"
          opacity="0.85"
        />
      </svg>

      {/* parks / blocks */}
      <div style={{ position: 'absolute', left: 60, top: 380, width: 80, height: 60, background: 'rgba(160,180,140,0.35)', borderRadius: 6 }} />
      <div style={{ position: 'absolute', left: 250, top: 470, width: 90, height: 70, background: 'rgba(160,180,140,0.30)', borderRadius: 6 }} />
      <div style={{ position: 'absolute', left: 180, top: 320, width: 50, height: 40, background: 'rgba(180,160,140,0.30)', borderRadius: 4 }} />

      {/* markers */}
      <Marker x={130} y={300} religion="buddhism" label="Chùa Pháp Hoa" big />
      <Marker x={250} y={360} religion="catholic" label="Hiển Linh" />
      <Marker x={90}  y={440} religion="caodai" />
      <Marker x={300} y={500} religion="buddhism" />
      <Marker x={180} y={540} religion="protestant" />
      <Marker x={240} y={620} religion="folk" />
      <Marker x={150} y={660} religion="catholic" />
      <Marker x={320} y={220} religion="buddhism" />

      {/* user location */}
      <div style={{
        position: 'absolute', left: 200, top: 480,
        width: 16, height: 16, borderRadius: 999,
        background: '#3b6fa0', boxShadow: '0 0 0 4px rgba(59,111,160,0.25), 0 0 0 8px rgba(59,111,160,0.15)',
        transform: 'translate(-50%,-50%)',
      }} />

      {dim && <div style={{ position: 'absolute', inset: 0, background: 'rgba(30,45,61,0.18)' }} />}
    </div>
  );
}

function Marker({ x, y, religion, label, big = false }) {
  const color = RELIGION[religion].color;
  const size = big ? 28 : 22;
  return (
    <div style={{ position: 'absolute', left: x, top: y, transform: 'translate(-50%,-100%)' }}>
      <div style={{
        width: size, height: size, borderRadius: 999,
        background: color, border: '2.5px solid #fff',
        boxShadow: '0 2px 6px rgba(0,0,0,0.25)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
      }}>
        <span style={{ color: '#fff', fontSize: big ? 13 : 11, fontWeight: 700 }}>
          {RELIGION[religion].name.charAt(0)}
        </span>
      </div>
      {label && (
        <div style={{
          position: 'absolute', left: '50%', top: '100%', transform: 'translateX(-50%)',
          marginTop: 4, padding: '2px 7px', borderRadius: 6,
          background: 'rgba(255,255,255,0.92)', backdropFilter: 'blur(4px)',
          fontSize: 10.5, fontWeight: 600, color: 'var(--ink)',
          whiteSpace: 'nowrap',
          boxShadow: '0 1px 3px rgba(0,0,0,0.12)',
        }}>{label}</div>
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Map screen (default state)
// ─────────────────────────────────────────────────────────────
function ScreenMap() {
  return (
    <div className="tn-screen" style={{ position: 'relative', background: '#eae5d5' }}>
      <MapCanvas />

      {/* Top floating bar — search + layers */}
      <div style={{
        position: 'absolute', left: 16, right: 16, top: STATUS_PAD - 4,
        display: 'flex', gap: 8, alignItems: 'center',
      }}>
        <div className="search" style={{
          flex: 1, background: 'rgba(255,255,255,0.94)',
          backdropFilter: 'blur(20px) saturate(180%)',
          boxShadow: '0 2px 10px rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.05)',
          border: '1px solid rgba(255,255,255,0.6)',
        }}>
          <IconSearch size={18} stroke="var(--ink-soft)" />
          <span>Tìm cơ sở, địa chỉ…</span>
        </div>
        <div className="icon-btn" style={{ width: 42, height: 42, boxShadow: '0 2px 8px rgba(0,0,0,0.06)' }}>
          <IconLayers size={20} stroke="var(--ink-muted)" />
        </div>
      </div>

      {/* Right side toolbar */}
      <div style={{
        position: 'absolute', right: 14, top: 200,
        display: 'flex', flexDirection: 'column', gap: 8,
      }}>
        {[
          { Icon: IconPlus, key: 'zin' },
          { Icon: IconMinus, key: 'zout' },
          { Icon: IconExpand, key: 'full' },
          { Icon: IconRuler, key: 'ruler' },
          { Icon: IconLoc, key: 'loc' },
        ].map(t => (
          <div key={t.key} className="icon-btn" style={{
            width: 42, height: 42, borderRadius: 12, boxShadow: '0 2px 6px rgba(0,0,0,0.08)',
          }}>
            <t.Icon size={20} stroke="var(--ink-muted)" />
          </div>
        ))}
      </div>

      {/* Legend pill (top-right under toolbar removed; place left) */}
      <div style={{
        position: 'absolute', left: 16, top: STATUS_PAD + 58,
        padding: '8px 12px', borderRadius: 14,
        background: 'rgba(255,255,255,0.94)',
        backdropFilter: 'blur(20px) saturate(180%)',
        boxShadow: '0 2px 10px rgba(0,0,0,0.06)',
        display: 'flex', alignItems: 'center', gap: 10,
      }}>
        <span className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase' }}>Hiển thị</span>
        <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><ReligionDot k="buddhism" /> 22</span>
        <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><ReligionDot k="catholic" /> 11</span>
        <span style={{ display: 'flex', alignItems: 'center', gap: 4 }}><ReligionDot k="caodai" /> 6</span>
        <span style={{ color: 'var(--ink-faint)', fontSize: 12, fontWeight: 600 }}>+3</span>
      </div>

      {/* Bottom sheet — peeking facility list */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: '#fff',
        borderTopLeftRadius: 24, borderTopRightRadius: 24,
        boxShadow: '0 -4px 24px rgba(0,0,0,0.10)',
        paddingTop: 8, paddingBottom: 96,
      }}>
        <div style={{
          width: 38, height: 5, background: 'var(--hairline-strong)',
          borderRadius: 999, margin: '4px auto 12px',
        }} />
        <div style={{ padding: '0 20px 8px', display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
          <div>
            <div className="t-h2">48 cơ sở</div>
            <div className="t-cap">Phường 5 · trong ranh giới</div>
          </div>
          <span className="more" style={{ color: 'var(--primary)', fontSize: 13, fontWeight: 600 }}>Bộ lọc</span>
        </div>
        <div style={{ padding: '4px 0 0' }}>
          <FacilityRow
            religion="buddhism"
            name="Chùa Pháp Hoa"
            address="34 Lê Quang Định"
            status="emerald"
            statusLabel="Đã công nhận"
          />
          <div className="hl" style={{ marginLeft: 20 }}/>
          <FacilityRow
            religion="catholic"
            name="Nhà thờ Hiển Linh"
            address="156 Đinh Tiên Hoàng"
            status="emerald"
            statusLabel="Đã công nhận"
          />
          <div className="hl" style={{ marginLeft: 20 }}/>
          <FacilityRow
            religion="caodai"
            name="Thánh thất Bình Hoà"
            address="29A Bùi Đình Tuý"
            status="amber"
            statusLabel="Đang xét duyệt"
          />
        </div>
      </div>

      <TabBar active="map" />
    </div>
  );
}

function FacilityRow({ religion, name, address, status, statusLabel }) {
  return (
    <div className="row" style={{ padding: '12px 20px' }}>
      <div style={{
        width: 42, height: 42, borderRadius: 12,
        background: 'var(--parchment)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        flexShrink: 0,
      }}>
        <span style={{
          width: 10, height: 10, borderRadius: 999,
          background: RELIGION[religion].color,
        }} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="t-body-strong" style={{ marginBottom: 1 }}>{name}</div>
        <div className="t-cap">{address}</div>
      </div>
      <StatusPill kind={status} label={statusLabel} />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Map screen — with facility popup expanded (bottom card)
// ─────────────────────────────────────────────────────────────
function ScreenMapPopup() {
  return (
    <div className="tn-screen" style={{ position: 'relative', background: '#eae5d5' }}>
      <MapCanvas dim />

      {/* Top floating bar (back + title) */}
      <div style={{
        position: 'absolute', left: 16, right: 16, top: STATUS_PAD - 4,
        display: 'flex', gap: 8, alignItems: 'center',
      }}>
        <div className="icon-btn" style={{ width: 42, height: 42, boxShadow: '0 2px 8px rgba(0,0,0,0.10)' }}>
          <IconChevL size={20} stroke="var(--ink)" />
        </div>
        <div style={{
          flex: 1, height: 42, borderRadius: 21,
          background: 'rgba(255,255,255,0.94)',
          backdropFilter: 'blur(20px) saturate(180%)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          fontSize: 13, fontWeight: 600, color: 'var(--ink)',
          boxShadow: '0 2px 8px rgba(0,0,0,0.06)',
        }}>
          Chi tiết cơ sở
        </div>
        <div className="icon-btn" style={{ width: 42, height: 42, boxShadow: '0 2px 8px rgba(0,0,0,0.06)' }}>
          <IconShare size={18} stroke="var(--ink-muted)" />
        </div>
      </div>

      {/* Facility popup card — large bottom sheet */}
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0,
        background: '#fff',
        borderTopLeftRadius: 24, borderTopRightRadius: 24,
        boxShadow: '0 -8px 32px rgba(0,0,0,0.18)',
        paddingBottom: 96,
        maxHeight: '78%',
        overflow: 'hidden',
      }}>
        <div style={{
          width: 38, height: 5, background: 'var(--hairline-strong)',
          borderRadius: 999, margin: '8px auto 0',
        }} />

        {/* Banner carousel — placeholder strip */}
        <div style={{ padding: '14px 0 0' }}>
          <div style={{ display: 'flex', gap: 8, padding: '0 16px', overflowX: 'auto' }}>
            <Img tag="chùa · cổng tam quan" variant="img-ph-warm" style={{ width: 220, height: 140, borderRadius: 14, flexShrink: 0 }} />
            <Img tag="chính điện" variant="img-ph-sage" style={{ width: 160, height: 140, borderRadius: 14, flexShrink: 0 }} />
            <Img tag="sân" variant="img-ph-clay" style={{ width: 120, height: 140, borderRadius: 14, flexShrink: 0 }} />
          </div>
        </div>

        {/* Body */}
        <div style={{ padding: '16px 20px 4px' }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6 }}>
            <ReligionDot k="buddhism" />
            <span className="t-cap-strong" style={{ color: 'var(--ink-soft)' }}>Phật giáo · Chùa</span>
          </div>
          <h2 className="t-title" style={{ margin: 0 }}>Chùa Pháp Hoa</h2>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 8, color: 'var(--ink-muted)' }}>
            <IconPin size={15} stroke="var(--ink-soft)" />
            <span className="t-body">870/53 Lê Quang Định, Phường 5</span>
          </div>

          {/* Spec grid */}
          <div style={{
            display: 'grid', gridTemplateColumns: 'repeat(4,1fr)',
            gap: 1, marginTop: 18,
            background: 'var(--hairline)',
            borderRadius: 14, overflow: 'hidden',
            border: '1px solid var(--hairline)',
          }}>
            <Spec label="Xây dựng" value="1928" />
            <Spec label="Diện tích" value="2.450" unit="m²" />
            <Spec label="Chức sắc" value="6" />
            <Spec label="Tín đồ" value="1.240" />
          </div>

          {/* Status row */}
          <div style={{ marginTop: 16, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <StatusPill kind="emerald" label="Đã công nhận" />
            <span className="t-cap-strong" style={{ color: 'var(--primary)' }}>Xem hồ sơ ›</span>
          </div>

          {/* Actions */}
          <div style={{ display: 'flex', gap: 8, marginTop: 18 }}>
            <button className="btn-primary" style={{ flex: 1 }}>
              <IconRoute size={16} stroke="#fff" /> Chỉ đường
            </button>
            <button className="btn-ghost">
              <IconImg size={16} stroke="var(--ink-muted)" /> Album
            </button>
          </div>
        </div>
      </div>

      <TabBar active="map" />
    </div>
  );
}

function Spec({ label, value, unit }) {
  return (
    <div style={{ background: '#fff', padding: '10px 12px' }}>
      <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', marginBottom: 4 }}>{label}</div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 3 }}>
        <span style={{ fontSize: 18, fontWeight: 700, letterSpacing: '-0.02em' }}>{value}</span>
        {unit && <span style={{ fontSize: 11, color: 'var(--ink-soft)', fontWeight: 600 }}>{unit}</span>}
      </div>
    </div>
  );
}

Object.assign(window, {
  ScreenMap, ScreenMapPopup, MapCanvas, Marker, FacilityRow, Spec,
});
