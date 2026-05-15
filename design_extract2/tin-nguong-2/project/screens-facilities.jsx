// screens-facilities.jsx — Cơ sở tôn giáo (list + detail)

// ─────────────────────────────────────────────────────────────
// Facility List
// ─────────────────────────────────────────────────────────────
function ScreenFacilityList() {
  const filters = ['Tất cả', 'Chùa', 'Nhà thờ', 'Thánh thất', 'Đình', 'Miếu'];
  return (
    <div className="tn-screen">
      <div className="tn-content">
        {/* Header */}
        <div style={{ padding: `${STATUS_PAD}px 20px 12px` }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <h1 className="t-hero" style={{ margin: 0 }}>Cơ sở</h1>
              <div className="t-cap" style={{ marginTop: 2 }}>Tín ngưỡng · 48 cơ sở</div>
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <div className="icon-btn"><IconMap size={18} stroke="var(--ink-muted)" /></div>
              <div className="icon-btn"><IconFilter size={18} stroke="var(--ink-muted)" /></div>
            </div>
          </div>

          {/* Search */}
          <div className="search" style={{ marginTop: 16 }}>
            <IconSearch size={18} stroke="var(--ink-soft)" />
            <span>Tìm theo tên, địa chỉ…</span>
          </div>
        </div>

        {/* Filter chips */}
        <div style={{ display: 'flex', gap: 8, padding: '4px 20px 16px', overflowX: 'auto' }}>
          {filters.map((f, i) => (
            <span key={f} className="pill"
              style={i === 0
                ? { background: 'var(--ink)', color: '#fff' }
                : { background: '#fff', color: 'var(--ink-muted)', border: '1px solid var(--hairline)' }
              }>{f}</span>
          ))}
        </div>

        {/* Status filter */}
        <div style={{ padding: '0 20px 12px', display: 'flex', gap: 8 }}>
          <FilterDropdown label="Trạng thái: Tất cả" />
          <FilterDropdown label="Khu phố" />
        </div>

        {/* Facility cards */}
        <div style={{ padding: '4px 20px 12px', display: 'flex', flexDirection: 'column', gap: 12 }}>
          <FacilityCard
            religion="buddhism"
            type="Chùa"
            name="Chùa Pháp Hoa"
            address="870/53 Lê Quang Định, KP 4"
            year="1928"
            area="2.450"
            followers="1.240"
            clergy="6"
            status="emerald"
            statusLabel="Đã công nhận"
            variant="img-ph-warm"
          />
          <FacilityCard
            religion="catholic"
            type="Nhà thờ"
            name="Nhà thờ Hiển Linh"
            address="156 Đinh Tiên Hoàng, KP 1"
            year="1956"
            area="1.820"
            followers="2.150"
            clergy="3"
            status="emerald"
            statusLabel="Đã công nhận"
            variant="img-ph-clay"
          />
          <FacilityCard
            religion="caodai"
            type="Thánh thất"
            name="Thánh thất Bình Hoà"
            address="29A Bùi Đình Tuý, KP 6"
            year="1962"
            area="980"
            followers="420"
            clergy="4"
            status="amber"
            statusLabel="Đang xét duyệt"
            variant="img-ph-sage"
          />
          <FacilityCard
            religion="folk"
            type="Đình"
            name="Đình Bình Hoà"
            address="14 Phan Văn Trị, KP 2"
            year="1820"
            area="640"
            followers="—"
            clergy="2"
            status="slate"
            statusLabel="Chưa đăng ký"
            variant="img-ph"
          />
        </div>

        {/* Pagination */}
        <div style={{ padding: '8px 20px 20px', display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <span className="t-cap">48 cơ sở · Trang 1/4</span>
          <div style={{ display: 'flex', gap: 6 }}>
            <span className="pill pill-ghost" style={{ opacity: 0.5 }}>‹</span>
            <span className="pill pill-ghost" style={{ background: 'var(--primary)', color: '#fff', borderColor: 'transparent' }}>1</span>
            <span className="pill pill-ghost">2</span>
            <span className="pill pill-ghost">3</span>
            <span className="pill pill-ghost">›</span>
          </div>
        </div>
      </div>
      <TabBar active="home" />
    </div>
  );
}

function FilterDropdown({ label }) {
  return (
    <span style={{
      display: 'inline-flex', alignItems: 'center', gap: 6,
      padding: '8px 12px', borderRadius: 999,
      background: '#fff', border: '1px solid var(--hairline)',
      fontSize: 12.5, fontWeight: 600, color: 'var(--ink-muted)',
    }}>
      {label}
      <IconChevD size={12} stroke="var(--ink-soft)" strokeWidth={2.2} />
    </span>
  );
}

function FacilityCard({ religion, type, name, address, year, area, followers, clergy, status, statusLabel, variant }) {
  return (
    <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
      <div style={{ position: 'relative' }}>
        <Img tag={`${type.toLowerCase()} · ${name.toLowerCase()}`} variant={variant}
          style={{ width: '100%', height: 140, borderRadius: 0, fontSize: 11 }} />
        <div style={{ position: 'absolute', left: 12, bottom: 12, display: 'flex', gap: 6 }}>
          <span className="pill" style={{ background: 'rgba(255,255,255,0.92)', color: 'var(--ink)' }}>
            <ReligionDot k={religion} /> {type}
          </span>
        </div>
        <div style={{ position: 'absolute', right: 12, top: 12 }}>
          <StatusPill kind={status} label={statusLabel} />
        </div>
      </div>
      <div style={{ padding: 16 }}>
        <h3 className="t-h3" style={{ margin: 0, textWrap: 'pretty' }}>{name}</h3>
        <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 6 }}>
          <IconPin size={13} stroke="var(--ink-soft)" />
          <span className="t-cap">{address}</span>
        </div>
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)',
          gap: 8, marginTop: 14,
        }}>
          <MiniStat label="XD" value={year} />
          <MiniStat label="m²" value={area} />
          <MiniStat label="Chức sắc" value={clergy} />
          <MiniStat label="Tín đồ" value={followers} />
        </div>
      </div>
    </div>
  );
}

function MiniStat({ label, value }) {
  return (
    <div>
      <div style={{ fontSize: 14, fontWeight: 700, color: 'var(--ink)', letterSpacing: '-0.01em' }}>{value}</div>
      <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', marginTop: 1 }}>{label}</div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Facility Detail
// ─────────────────────────────────────────────────────────────
function ScreenFacilityDetail() {
  return (
    <div className="tn-screen" style={{ background: 'var(--parchment)' }}>
      <div className="tn-content" style={{ paddingBottom: 110 }}>
        {/* Hero image */}
        <div style={{ position: 'relative', height: 320 }}>
          <Img tag="chùa · cổng tam quan" variant="img-ph-warm"
            style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', fontSize: 11 }} />
          {/* gradient */}
          <div style={{
            position: 'absolute', inset: 0,
            background: 'linear-gradient(to bottom, rgba(30,45,61,0.45) 0%, transparent 35%, transparent 60%, rgba(30,45,61,0.55) 100%)',
          }} />
          {/* nav buttons */}
          <div style={{
            position: 'absolute', left: 16, right: 16, top: STATUS_PAD - 4,
            display: 'flex', justifyContent: 'space-between',
          }}>
            <div className="icon-btn" style={{ width: 42, height: 42, background: 'rgba(255,255,255,0.92)' }}>
              <IconChevL size={20} stroke="var(--ink)" />
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <div className="icon-btn" style={{ width: 42, height: 42, background: 'rgba(255,255,255,0.92)' }}>
                <IconShare size={18} stroke="var(--ink)" />
              </div>
              <div className="icon-btn" style={{ width: 42, height: 42, background: 'rgba(255,255,255,0.92)' }}>
                <IconBookmark size={18} stroke="var(--ink)" />
              </div>
            </div>
          </div>
          {/* Image indicator */}
          <div style={{
            position: 'absolute', left: '50%', bottom: 16,
            transform: 'translateX(-50%)',
            display: 'flex', gap: 4,
          }}>
            {[0,1,2,3,4].map(i => (
              <span key={i} style={{
                width: i === 0 ? 16 : 6, height: 6, borderRadius: 999,
                background: i === 0 ? '#fff' : 'rgba(255,255,255,0.5)',
              }} />
            ))}
          </div>
        </div>

        {/* Title block — sits on parchment, with rounded card overlap */}
        <div style={{
          background: 'var(--parchment)',
          marginTop: -20,
          borderTopLeftRadius: 24, borderTopRightRadius: 24,
          paddingTop: 20, paddingLeft: 20, paddingRight: 20,
          position: 'relative',
        }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
            <span className="pill pill-emerald"><span className="dot" /> Đã công nhận</span>
            <span className="pill" style={{ background: '#fff', border: '1px solid var(--hairline)', color: 'var(--ink-muted)' }}>
              <ReligionDot k="buddhism" /> Phật giáo
            </span>
          </div>
          <h1 className="t-title" style={{ margin: 0 }}>Chùa Pháp Hoa</h1>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginTop: 8 }}>
            <IconPin size={15} stroke="var(--ink-soft)" />
            <span className="t-body muted">870/53 Lê Quang Định, Khu phố 4</span>
          </div>

          {/* Action row */}
          <div style={{ display: 'flex', gap: 8, marginTop: 16 }}>
            <button className="btn-primary" style={{ flex: 1 }}>
              <IconRoute size={16} stroke="#fff" /> Chỉ đường
            </button>
            <button className="btn-ghost">
              <IconPhone size={15} stroke="var(--ink-muted)" />
            </button>
            <button className="btn-ghost">
              <IconShare size={15} stroke="var(--ink-muted)" />
            </button>
          </div>
        </div>

        {/* Spec table */}
        <div style={{ padding: '24px 20px 4px' }}>
          <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
            <InfoRow label="Loại hình" value="Chùa Bắc Tông" />
            <InfoRow label="Tên viết tắt" value="Pháp Hoa" />
            <InfoRow label="Năm xây dựng" value="1928" />
            <InfoRow label="Diện tích" value="2.450 m²" />
            <InfoRow label="Khu phố" value="Khu phố 4, Phường 5" />
            <InfoRow label="Toạ độ" value="10.804°, 106.700°" mono />
            <InfoRow label="Mã hoạt động" value="HD-PH-2024-018" mono last />
          </div>
        </div>

        {/* People */}
        <div style={{ padding: '24px 0 4px' }}>
          <SectionHeader title="Chức sắc – Chức việc" more="6 người" />
          <div style={{ padding: '4px 20px 0', display: 'flex', flexDirection: 'column', gap: 8 }}>
            <PersonRow name="Thượng toạ Thích Trí Quảng" role="Trụ trì" since="Từ 1996" />
            <PersonRow name="Đại đức Thích Nhật Từ" role="Phó trụ trì" since="Từ 2008" />
            <PersonRow name="Sư cô Diệu Hạnh" role="Quản chúng" since="Từ 2015" />
          </div>
        </div>

        {/* Album section */}
        <div style={{ padding: '24px 0 4px' }}>
          <SectionHeader title="Thư viện ảnh" more="4 album" />
          <div style={{
            display: 'grid', gridTemplateColumns: '1fr 1fr',
            gap: 10, padding: '4px 20px 0',
          }}>
            <AlbumTile name="Lễ Phật Đản 2025" count="48 ảnh" variant="img-ph-warm" />
            <AlbumTile name="Tịnh tu mùa hạ" count="22 ảnh" variant="img-ph-sage" />
            <AlbumTile name="Trùng tu chính điện" count="34 ảnh" variant="img-ph-clay" />
            <AlbumTile name="Vu Lan 2024" count="61 ảnh" variant="img-ph" />
          </div>
        </div>

        {/* Documents */}
        <div style={{ padding: '24px 0 4px' }}>
          <SectionHeader title="Hồ sơ – Tài liệu" more="12 mục" />
          <div className="card" style={{ margin: '4px 20px 0', padding: 0, overflow: 'hidden' }}>
            <DocRow icon="PDF" name="Quyết định công nhận cơ sở" meta="QĐ-185/PG · 2.4 MB · 14/03/2024" />
            <div className="hl" />
            <DocRow icon="DOC" name="Lý lịch cơ sở tôn giáo" meta="docx · 1.1 MB · 02/01/2025" />
            <div className="hl" />
            <DocRow icon="XLS" name="Danh sách tín đồ năm 2025" meta="xlsx · 480 KB · 12/03/2025" />
          </div>
        </div>

        {/* Repair history */}
        <div style={{ padding: '24px 0 24px' }}>
          <SectionHeader title="Lịch sử sửa chữa" more="8 lần" />
          <div style={{ padding: '4px 20px 0', display: 'flex', flexDirection: 'column', gap: 10 }}>
            <RepairRow date="03/05/2026" desc="Trùng tu mái chính điện, thay ngói lưu ly" cost="142.000.000 ₫" status="blue" statusLabel="Đang thực hiện" />
            <RepairRow date="14/11/2025" desc="Sơn lại tường rào và cổng tam quan" cost="38.500.000 ₫" status="emerald" statusLabel="Hoàn thành" />
          </div>
        </div>
      </div>
      <TabBar active="home" />
    </div>
  );
}

function InfoRow({ label, value, mono, last }) {
  return (
    <div style={{
      display: 'flex', alignItems: 'baseline', justifyContent: 'space-between',
      padding: '12px 16px',
      borderBottom: last ? 'none' : '1px solid var(--hairline)',
    }}>
      <span className="t-cap" style={{ color: 'var(--ink-soft)' }}>{label}</span>
      <span className={mono ? "t-mono" : "t-body-strong"} style={{ textAlign: 'right' }}>{value}</span>
    </div>
  );
}

function PersonRow({ name, role, since }) {
  return (
    <div className="card" style={{ padding: 12, display: 'flex', alignItems: 'center', gap: 12 }}>
      <div className="avatar" style={{ width: 44, height: 44, background: 'var(--parchment-2)' }}>
        {name.split(' ').slice(-2).map(w => w[0]).join('')}
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="t-body-strong">{name}</div>
        <div className="t-cap">{role} · {since}</div>
      </div>
      <IconChevR size={16} stroke="var(--ink-faint)" />
    </div>
  );
}

function AlbumTile({ name, count, variant }) {
  return (
    <div>
      <Img tag={name.toLowerCase()} variant={variant}
        style={{ width: '100%', aspectRatio: '4 / 3', borderRadius: 14, fontSize: 10 }} />
      <div className="t-body-strong" style={{ marginTop: 8 }}>{name}</div>
      <div className="t-cap" style={{ marginTop: 1 }}>{count}</div>
    </div>
  );
}

function DocRow({ icon, name, meta }) {
  const colors = { PDF: ['#7a2a22', '#f7e3e1'], DOC: ['#2a5a85', '#e4ecf5'], XLS: ['#1b6a43', '#e6f4ec'] };
  const [fg, bg] = colors[icon] || ['#4b5b6e', '#ece9e0'];
  return (
    <div className="row" style={{ padding: '14px 16px' }}>
      <div style={{
        width: 38, height: 38, borderRadius: 10,
        background: bg, color: fg,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        fontSize: 10.5, fontWeight: 700, letterSpacing: 0.02,
      }}>{icon}</div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="t-body-strong" style={{ textWrap: 'pretty' }}>{name}</div>
        <div className="t-cap" style={{ marginTop: 2 }}>{meta}</div>
      </div>
      <IconDownload size={18} stroke="var(--ink-soft)" />
    </div>
  );
}

function RepairRow({ date, desc, cost, status, statusLabel }) {
  return (
    <div className="card" style={{ padding: 14 }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: 8 }}>
        <span className="t-cap-strong">{date}</span>
        <StatusPill kind={status} label={statusLabel} />
      </div>
      <div className="t-body" style={{ textWrap: 'pretty' }}>{desc}</div>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginTop: 10 }}>
        <span className="t-cap" style={{ color: 'var(--ink-soft)' }}>Chi phí</span>
        <span className="t-body-strong">{cost}</span>
      </div>
    </div>
  );
}

Object.assign(window, {
  ScreenFacilityList, ScreenFacilityDetail,
  FacilityCard, MiniStat, FilterDropdown, InfoRow, PersonRow,
  AlbumTile, DocRow, RepairRow,
});
