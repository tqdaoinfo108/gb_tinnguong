// screens.jsx — TinNguongGIS mobile screens (read-only)
// Sized for iOS frame inner content (402 wide, ~874 tall)

const STATUS_PAD = 62; // space for iOS status bar

// ─────────────────────────────────────────────────────────────
// Shared bits
// ─────────────────────────────────────────────────────────────
const RELIGION = {
  buddhism:   { name: 'Phật giáo',        color: '#c9a84c' },
  catholic:   { name: 'Công giáo',        color: '#5a8aae' },
  protestant: { name: 'Tin Lành',         color: '#7a9b6e' },
  caodai:     { name: 'Cao Đài',          color: '#c87b3a' },
  hoahao:     { name: 'Hòa Hảo',          color: '#b56a8a' },
  islam:      { name: 'Hồi giáo',         color: '#3b6fa0' },
  folk:       { name: 'Tín ngưỡng dân gian', color: '#8a6e4a' },
};

const StatusPill = ({ kind, label }) => (
  <span className={`pill pill-${kind}`}>
    <span className="dot"></span>
    {label}
  </span>
);

const ReligionDot = ({ k }) => (
  <span className="dot-religion" style={{ background: RELIGION[k].color }}></span>
);

// Image placeholder
const Img = ({ tag = "ảnh", className = "", style = {}, variant = "" }) => (
  <div className={`img-ph ${variant} ${className}`} style={style}>
    {tag}
  </div>
);

// Simple sparkline placeholder
const Spark = ({ color = '#3b6fa0', up = true }) => (
  <svg width="56" height="22" viewBox="0 0 56 22" fill="none">
    <path
      d={up ? "M2 18 L12 14 L20 16 L30 8 L40 10 L54 4" : "M2 4 L12 8 L20 6 L30 14 L40 12 L54 18"}
      stroke={color} strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" fill="none"
    />
  </svg>
);

// Section header
const SectionHeader = ({ title, more }) => (
  <div className="section-title" style={{ padding: '0 20px' }}>
    <h3 className="t-h2" style={{ margin: 0 }}>{title}</h3>
    {more && <span className="more">{more} ›</span>}
  </div>
);

// ─────────────────────────────────────────────────────────────
// 1) Home / Dashboard
// ─────────────────────────────────────────────────────────────
function ScreenHome() {
  return (
    <div className="tn-screen" style={{ background: 'var(--parchment)' }}>
      <div className="tn-content">
        {/* Hero block — dark editorial tile */}
        <div style={{
          background: 'var(--tile-dark)',
          color: 'var(--on-dark)',
          padding: `${STATUS_PAD + 12}px 20px 28px`,
          borderBottomLeftRadius: 28,
          borderBottomRightRadius: 28,
          position: 'relative',
          overflow: 'hidden',
        }}>
          {/* subtle texture */}
          <div style={{
            position: 'absolute', inset: 0,
            background: 'radial-gradient(circle at 85% 10%, rgba(201,168,76,0.18), transparent 50%)',
            pointerEvents: 'none',
          }} />
          <div style={{ position: 'relative' }}>
            <div className="t-micro" style={{ color: 'var(--gold-soft)', textTransform: 'uppercase', marginBottom: 6 }}>
              Tin ngưỡng · GIS
            </div>
            <h1 className="t-hero" style={{ margin: 0, color: 'var(--on-dark)' }}>
              Chào buổi sáng
            </h1>
            <div style={{ marginTop: 6, color: 'var(--on-dark-muted)', fontSize: 14, fontWeight: 500 }}>
              Phường 5 · Quận Bình Thạnh
            </div>

            {/* KPI mini-grid */}
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10, marginTop: 22 }}>
              <KpiMini value="48" label="Cơ sở" tone="ok" />
              <KpiMini value="12" label="Sự kiện 2026" tone="info" />
              <KpiMini value="3" label="Sắp diễn ra" tone="info" />
              <KpiMini value="5" label="Cần xử lý" tone="warn" />
            </div>
          </div>
        </div>

        {/* Cảnh báo */}
        <div style={{ padding: '24px 20px 4px' }}>
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: 12 }}>
            <h3 className="t-h2" style={{ margin: 0 }}>Cảnh báo</h3>
            <span className="t-cap-strong" style={{ color: 'var(--status-amber-fg)' }}>5 mục</span>
          </div>

          <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
            <AlertRow
              severity="high"
              title="Lễ hội chưa có giấy phép"
              meta="Lễ Vu Lan · Chùa Pháp Hoa · còn 6 ngày"
            />
            <div className="hl" />
            <AlertRow
              severity="med"
              title="Hồ sơ thiếu giấy chứng nhận"
              meta="Nhà thờ Hiển Linh · cập nhật 12/05"
            />
            <div className="hl" />
            <AlertRow
              severity="low"
              title="Sửa chữa đang thực hiện"
              meta="Đình Thần Thắng Tam · từ 03/05"
            />
          </div>
        </div>

        {/* Sự kiện sắp tới */}
        <div style={{ padding: '24px 0 4px' }}>
          <SectionHeader title="Sắp diễn ra" more="Tất cả" />
          <div style={{ display: 'flex', gap: 12, padding: '0 20px', overflowX: 'auto', scrollSnapType: 'x mandatory' }}>
            <EventCardSmall
              date="18"
              month="THG 5"
              name="Lễ Phật Đản"
              place="Chùa Pháp Hoa"
              religion="buddhism"
              permit
            />
            <EventCardSmall
              date="22"
              month="THG 5"
              name="Lễ Hiệp Thông"
              place="Nhà thờ Hiển Linh"
              religion="catholic"
              permit
            />
            <EventCardSmall
              date="01"
              month="THG 6"
              name="Lễ giỗ Đức Hộ Pháp"
              place="Thánh thất Cao Đài"
              religion="caodai"
            />
          </div>
        </div>

        {/* Tin mới */}
        <div style={{ padding: '24px 0 4px' }}>
          <SectionHeader title="Tin mới" more="Tất cả" />
          <div className="card" style={{ margin: '0 20px', padding: 0, overflow: 'hidden' }}>
            <NewsRow
              tag="công nhận"
              tagKind="emerald"
              title="Trao quyết định công nhận cơ sở Tịnh xá Ngọc Phương"
              date="14/05/2026"
              variant="img-ph-warm"
            />
            <div className="hl" />
            <NewsRow
              tag="hoạt động"
              tagKind="blue"
              title="Hội nghị liên tôn Phường 5 chuẩn bị Đại lễ Phật Đản"
              date="12/05/2026"
              variant="img-ph-sage"
            />
            <div className="hl" />
            <NewsRow
              tag="thông báo"
              tagKind="slate"
              title="Lịch tiếp dân tháng 5 — Phòng Nội vụ"
              date="10/05/2026"
              variant="img-ph"
            />
          </div>
        </div>
      </div>
      <TabBar active="home" />
    </div>
  );
}

function KpiMini({ value, label, tone }) {
  const toneColor = {
    ok: 'var(--gold-soft)',
    info: '#a9c7e3',
    warn: '#f0c878',
  }[tone] || '#fff';
  return (
    <div style={{
      background: 'rgba(255,255,255,0.06)',
      border: '1px solid rgba(255,255,255,0.10)',
      borderRadius: 14,
      padding: '12px 14px',
      backdropFilter: 'blur(8px)',
    }}>
      <div style={{ fontSize: 26, fontWeight: 700, letterSpacing: '-0.02em', color: '#fff', lineHeight: 1.05 }}>{value}</div>
      <div style={{ marginTop: 2, fontSize: 12, fontWeight: 500, color: toneColor }}>{label}</div>
    </div>
  );
}

function AlertRow({ severity, title, meta }) {
  const dotColor = { high: '#b03328', med: '#b8870c', low: 'var(--primary)' }[severity];
  return (
    <div className="row" style={{ alignItems: 'flex-start' }}>
      <div style={{ width: 32, display: 'flex', justifyContent: 'center', paddingTop: 4 }}>
        <span style={{ width: 8, height: 8, borderRadius: 999, background: dotColor, display: 'inline-block' }} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="t-body-strong" style={{ marginBottom: 2 }}>{title}</div>
        <div className="t-cap">{meta}</div>
      </div>
      <IconChevR size={16} stroke="var(--ink-faint)" />
    </div>
  );
}

function EventCardSmall({ date, month, name, place, religion, permit }) {
  return (
    <div className="card" style={{
      width: 220, flexShrink: 0, padding: 16,
      scrollSnapAlign: 'start',
    }}>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 6 }}>
        <span style={{ fontSize: 30, fontWeight: 700, letterSpacing: '-0.02em', lineHeight: 1 }}>{date}</span>
        <span className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase' }}>{month}</span>
      </div>
      <div className="t-h3" style={{ marginTop: 12, textWrap: 'pretty' }}>{name}</div>
      <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 6 }}>
        <ReligionDot k={religion} />
        <span className="t-cap">{place}</span>
      </div>
      <div style={{ marginTop: 14, display: 'flex' }}>
        {permit
          ? <StatusPill kind="emerald" label="Đã cấp phép" />
          : <StatusPill kind="amber" label="Chưa có phép" />}
      </div>
    </div>
  );
}

function NewsRow({ tag, tagKind, title, date, variant }) {
  return (
    <div className="row" style={{ alignItems: 'flex-start' }}>
      <Img tag={tag.slice(0,3)} variant={variant} style={{ width: 64, height: 64, borderRadius: 10, fontSize: 10 }} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <span className={`pill pill-${tagKind}`} style={{ padding: '2px 8px', fontSize: 10.5 }}>{tag}</span>
        <div className="t-body-strong" style={{ marginTop: 6, textWrap: 'pretty' }}>{title}</div>
        <div className="t-cap" style={{ marginTop: 4 }}>{date}</div>
      </div>
    </div>
  );
}

Object.assign(window, {
  ScreenHome, StatusPill, ReligionDot, Img, Spark, SectionHeader,
  KpiMini, AlertRow, EventCardSmall, NewsRow, RELIGION, STATUS_PAD,
});
