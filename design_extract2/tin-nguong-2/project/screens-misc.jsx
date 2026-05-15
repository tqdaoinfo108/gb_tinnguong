// screens-misc.jsx — Tin tức, Thông báo, Album, Thống kê, Chức sắc detail

// ─────────────────────────────────────────────────────────────
// News Feed
// ─────────────────────────────────────────────────────────────
function ScreenNewsList() {
  return (
    <div className="tn-screen">
      <div className="tn-content">
        <div style={{ padding: `${STATUS_PAD}px 20px 12px` }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <h1 className="t-hero" style={{ margin: 0 }}>Tin tức</h1>
              <div className="t-cap" style={{ marginTop: 2 }}>Hoạt động & sự kiện Phường 5</div>
            </div>
            <div className="icon-btn"><IconSearch size={18} stroke="var(--ink-muted)" /></div>
          </div>

          {/* Filter chips */}
          <div style={{ display: 'flex', gap: 8, marginTop: 16, overflowX: 'auto' }}>
            {['Tất cả', 'Công nhận', 'Hoạt động', 'Thông báo', 'Sự kiện'].map((f, i) => (
              <span key={f} className="pill"
                style={i === 0
                  ? { background: 'var(--ink)', color: '#fff' }
                  : { background: '#fff', color: 'var(--ink-muted)', border: '1px solid var(--hairline)' }
                }>{f}</span>
            ))}
          </div>
        </div>

        {/* Featured */}
        <div style={{ padding: '8px 20px 4px' }}>
          <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
            <Img tag="trao quyết định công nhận" variant="img-ph-warm"
              style={{ width: '100%', height: 200, fontSize: 11 }} />
            <div style={{ padding: 16 }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginBottom: 8 }}>
                <span className="pill pill-emerald"><span className="dot" />Công nhận</span>
                <span className="t-cap">14/05/2026</span>
              </div>
              <h3 className="t-h2" style={{ margin: 0, textWrap: 'pretty' }}>
                Trao quyết định công nhận Tịnh xá Ngọc Phương là cơ sở tôn giáo
              </h3>
              <p className="t-body muted" style={{ margin: '8px 0 0', textWrap: 'pretty' }}>
                Sáng nay tại UBND Phường 5, Ban Tôn giáo Quận đã trao quyết định công nhận chính thức
                Tịnh xá Ngọc Phương, kết thúc quá trình xét duyệt kéo dài 14 tháng.
              </p>
            </div>
          </div>
        </div>

        {/* News rows */}
        <div style={{ padding: '20px 20px 0', display: 'flex', flexDirection: 'column', gap: 14 }}>
          <NewsItem
            tag="hoạt động"
            tagKind="blue"
            title="Hội nghị liên tôn Phường 5 chuẩn bị Đại lễ Phật Đản 2026"
            excerpt="Đại diện 12 cơ sở thuộc Phật giáo, Công giáo, Cao Đài, Tin Lành cùng tham dự…"
            date="12/05/2026"
            variant="img-ph-sage"
          />
          <NewsItem
            tag="thông báo"
            tagKind="slate"
            title="Lịch tiếp dân tháng 5 — Phòng Nội vụ Phường 5"
            excerpt="Phòng Nội vụ sẽ tiếp nhận hồ sơ tôn giáo vào sáng thứ Hai – thứ Sáu hàng tuần…"
            date="10/05/2026"
            variant="img-ph"
          />
          <NewsItem
            tag="sự kiện"
            tagKind="amber"
            title="Mời tham dự lễ khánh thành trùng tu Đình Bình Hoà"
            excerpt="Sau hơn 18 tháng trùng tu, Đình Bình Hoà sẽ tổ chức lễ khánh thành vào…"
            date="08/05/2026"
            variant="img-ph-clay"
          />
          <NewsItem
            tag="công nhận"
            tagKind="emerald"
            title="Bổ nhiệm chánh xứ mới tại Nhà thờ Hiển Linh"
            excerpt="Linh mục Phêrô Nguyễn Văn An nhận nhiệm vụ chánh xứ Hiển Linh từ ngày…"
            date="02/05/2026"
            variant="img-ph"
          />
        </div>
      </div>
      <TabBar active="news" />
    </div>
  );
}

function NewsItem({ tag, tagKind, title, excerpt, date, variant }) {
  return (
    <div style={{ display: 'flex', gap: 12 }}>
      <Img tag={tag} variant={variant} style={{ width: 110, height: 110, borderRadius: 14, flexShrink: 0, fontSize: 10 }} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <span className={`pill pill-${tagKind}`} style={{ padding: '2px 8px', fontSize: 10.5 }}>{tag}</span>
        <div className="t-body-strong" style={{ marginTop: 6, textWrap: 'pretty' }}>{title}</div>
        <div className="t-cap" style={{ marginTop: 4, textWrap: 'pretty',
          display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}>
          {excerpt}
        </div>
        <div className="t-micro" style={{ color: 'var(--ink-faint)', marginTop: 6 }}>{date}</div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// News Detail (article)
// ─────────────────────────────────────────────────────────────
function ScreenNewsDetail() {
  return (
    <div className="tn-screen">
      <div className="tn-content" style={{ paddingBottom: 110 }}>
        {/* Top nav */}
        <div style={{
          position: 'sticky', top: 0, zIndex: 5,
          padding: `${STATUS_PAD - 8}px 16px 12px`,
          background: 'rgba(244,242,236,0.92)',
          backdropFilter: 'blur(20px) saturate(180%)',
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
        }}>
          <div className="icon-btn"><IconChevL size={20} stroke="var(--ink)" /></div>
          <div style={{ display: 'flex', gap: 8 }}>
            <div className="icon-btn"><IconBookmark size={18} stroke="var(--ink-muted)" /></div>
            <div className="icon-btn"><IconShare size={18} stroke="var(--ink-muted)" /></div>
          </div>
        </div>

        {/* Article */}
        <div style={{ padding: '8px 20px 0' }}>
          <span className="pill pill-emerald"><span className="dot" />Công nhận</span>
          <h1 className="t-title" style={{ margin: '12px 0 0', textWrap: 'pretty' }}>
            Trao quyết định công nhận Tịnh xá Ngọc Phương là cơ sở tôn giáo
          </h1>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginTop: 14, color: 'var(--ink-soft)' }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 6 }}>
              <div className="avatar" style={{ width: 22, height: 22, fontSize: 10 }}>BT</div>
              <span className="t-cap">Ban Tôn giáo Quận BT</span>
            </div>
            <span style={{ color: 'var(--ink-faint)' }}>·</span>
            <span className="t-cap">14/05/2026 · 5 phút đọc</span>
          </div>
        </div>

        {/* Hero image */}
        <div style={{ padding: '20px 20px 0' }}>
          <Img tag="lễ trao quyết định · sân uỷ ban" variant="img-ph-warm"
            style={{ width: '100%', height: 220, borderRadius: 16, fontSize: 11 }} />
          <div className="t-cap" style={{ marginTop: 8, fontStyle: 'italic' }}>
            Đại diện Ban Tôn giáo Quận trao quyết định công nhận cho trụ trì Tịnh xá Ngọc Phương.
          </div>
        </div>

        {/* Body */}
        <div style={{ padding: '20px 20px 0' }}>
          <p className="t-body" style={{ margin: 0, fontSize: 16, lineHeight: 1.55, textWrap: 'pretty', color: 'var(--ink)' }}>
            Sáng ngày 14/05/2026 tại trụ sở UBND Phường 5, Quận Bình Thạnh, Ban Tôn giáo Quận đã long trọng
            tổ chức Lễ trao quyết định công nhận Tịnh xá Ngọc Phương là cơ sở tôn giáo thuộc hệ phái Khất sĩ.
          </p>
          <p className="t-body" style={{ margin: '14px 0 0', fontSize: 16, lineHeight: 1.55, textWrap: 'pretty', color: 'var(--ink-muted)' }}>
            Tịnh xá Ngọc Phương được xây dựng từ năm 1971, hiện có 4 vị Tỳ kheo cùng khoảng 320 Phật tử
            sinh hoạt thường xuyên. Quá trình hoàn thiện hồ sơ kéo dài 14 tháng với sự phối hợp giữa nhà
            chùa và phòng Nội vụ.
          </p>

          {/* Pull-quote */}
          <div style={{
            margin: '20px 0',
            paddingLeft: 16,
            borderLeft: '3px solid var(--gold)',
          }}>
            <p className="t-h3" style={{ margin: 0, fontStyle: 'italic', textWrap: 'pretty', color: 'var(--ink)' }}>
              "Việc công nhận là sự ghi nhận của Nhà nước với một quá trình hoạt động tín ngưỡng nghiêm túc,
              gắn bó với cộng đồng địa phương."
            </p>
            <div className="t-cap" style={{ marginTop: 8 }}>— Trưởng phòng Nội vụ Phường 5</div>
          </div>

          <p className="t-body" style={{ margin: '0 0 0', fontSize: 16, lineHeight: 1.55, textWrap: 'pretty', color: 'var(--ink-muted)' }}>
            Sau lễ trao quyết định, Tịnh xá Ngọc Phương chính thức được cập nhật vào danh mục cơ sở tôn giáo
            trên hệ thống bản đồ số GIS của phường.
          </p>
        </div>

        {/* Related */}
        <div style={{ padding: '32px 0 0' }}>
          <SectionHeader title="Liên quan" />
          <div style={{ padding: '4px 20px 0', display: 'flex', flexDirection: 'column', gap: 14 }}>
            <NewsItem
              tag="hồ sơ"
              tagKind="slate"
              title="Quy trình xét duyệt công nhận cơ sở tôn giáo"
              excerpt="6 bước từ nộp hồ sơ đến trao quyết định, thời gian trung bình 12-18 tháng…"
              date="20/04/2026"
              variant="img-ph"
            />
          </div>
        </div>
      </div>
      <TabBar active="news" />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Notifications
// ─────────────────────────────────────────────────────────────
function ScreenNotifications() {
  return (
    <div className="tn-screen">
      <div className="tn-content">
        <div style={{ padding: `${STATUS_PAD}px 20px 12px` }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <h1 className="t-hero" style={{ margin: 0 }}>Thông báo</h1>
              <div className="t-cap" style={{ marginTop: 2 }}>3 mới · 12 đã đọc tuần này</div>
            </div>
            <div style={{ display: 'flex', gap: 8 }}>
              <div className="icon-btn"><IconCheck size={18} stroke="var(--ink-muted)" /></div>
              <div className="icon-btn"><IconFilter size={18} stroke="var(--ink-muted)" /></div>
            </div>
          </div>

          {/* Filter tabs */}
          <div style={{ display: 'flex', gap: 8, marginTop: 16 }}>
            <span className="pill" style={{ background: 'var(--ink)', color: '#fff' }}>Tất cả · 15</span>
            <span className="pill pill-ghost">Cảnh báo · 3</span>
            <span className="pill pill-ghost">Hoạt động · 8</span>
            <span className="pill pill-ghost">Hệ thống</span>
          </div>
        </div>

        {/* Hôm nay */}
        <div style={{ padding: '12px 20px 4px' }}>
          <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', marginBottom: 8, letterSpacing: 0.05 }}>
            Hôm nay
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            <NotifCard
              kind="alert"
              title="Lễ Vu Lan chưa có giấy phép"
              body="Sự kiện sẽ diễn ra trong 6 ngày tại Chùa Pháp Hoa. Hồ sơ cần được hoàn thiện trước 18/05."
              time="08:14"
              unread
            />
            <NotifCard
              kind="info"
              title="Cập nhật bản đồ ranh giới"
              body="Ranh giới Phường 5 đã được đồng bộ từ Bản đồ địa chính TP.HCM (phiên bản 2026.05)."
              time="07:30"
              unread
            />
            <NotifCard
              kind="ok"
              title="Hồ sơ Tịnh xá Ngọc Phương đã hoàn tất"
              body="Quyết định công nhận đã được trao. Cơ sở được thêm vào danh mục bản đồ."
              time="06:48"
              unread
            />
          </div>
        </div>

        {/* Hôm qua */}
        <div style={{ padding: '20px 20px 4px' }}>
          <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', marginBottom: 8, letterSpacing: 0.05 }}>
            Hôm qua
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            <NotifCard
              kind="info"
              title="Báo cáo tuần đã sẵn sàng"
              body="Báo cáo thống kê tuần 19/2026 đã được tạo. Xuất Excel hoặc xem trực tiếp."
              time="17:02"
            />
            <NotifCard
              kind="people"
              title="Bổ nhiệm chánh xứ mới"
              body="Linh mục Phêrô Nguyễn Văn An nhận nhiệm vụ tại Nhà thờ Hiển Linh từ 01/06."
              time="14:25"
            />
            <NotifCard
              kind="build"
              title="Sửa chữa hoàn thành"
              body="Trùng tu sân và cổng tam quan Chùa Pháp Hoa đã hoàn tất, chi phí 38.500.000 ₫."
              time="09:11"
            />
          </div>
        </div>

        {/* Tuần này */}
        <div style={{ padding: '20px 20px 4px' }}>
          <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', marginBottom: 8, letterSpacing: 0.05 }}>
            Tuần này
          </div>
          <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
            <NotifCard
              kind="event"
              title="Sự kiện mới được tạo"
              body="Lễ Hiệp Thông tại Nhà thờ Hiển Linh ngày 22/05 đã được cấp giấy phép GP-021/2026."
              time="T2 · 10:30"
            />
          </div>
        </div>
      </div>
      <TabBar active="notif" />
    </div>
  );
}

function NotifCard({ kind, title, body, time, unread }) {
  const map = {
    alert: { Icon: IconAlert, bg: 'var(--status-amber-bg)', fg: '#b8870c' },
    info:  { Icon: IconBell,  bg: 'var(--status-blue-bg)',  fg: 'var(--primary)' },
    ok:    { Icon: IconCheck, bg: 'var(--status-emerald-bg)', fg: '#1b6a43' },
    people:{ Icon: IconUser,  bg: '#ece9e0',                fg: 'var(--ink-muted)' },
    build: { Icon: IconHammer,bg: '#f0e6d6',                fg: '#735a14' },
    event: { Icon: IconCalendar, bg: 'var(--status-blue-bg)', fg: 'var(--primary)' },
  };
  const c = map[kind] || map.info;
  return (
    <div className="card" style={{
      padding: 14,
      display: 'flex', gap: 12, alignItems: 'flex-start',
      position: 'relative',
      borderColor: unread ? 'rgba(59,111,160,0.25)' : 'var(--hairline)',
      background: unread ? 'rgba(255,255,255,1)' : 'rgba(255,255,255,0.7)',
    }}>
      <div style={{
        width: 38, height: 38, borderRadius: 11,
        background: c.bg, color: c.fg,
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        flexShrink: 0,
      }}>
        <c.Icon size={18} stroke={c.fg} />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: 8 }}>
          <div className="t-body-strong" style={{ textWrap: 'pretty' }}>{title}</div>
          <span className="t-micro" style={{ color: 'var(--ink-faint)', flexShrink: 0 }}>{time}</span>
        </div>
        <div className="t-cap" style={{ marginTop: 4, textWrap: 'pretty' }}>{body}</div>
      </div>
      {unread && (
        <span style={{
          position: 'absolute', left: 6, top: '50%', transform: 'translateY(-50%)',
          width: 6, height: 6, borderRadius: 999,
          background: 'var(--primary)',
        }} />
      )}
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Album viewer (photo grid + lightbox feel)
// ─────────────────────────────────────────────────────────────
function ScreenAlbum() {
  const variants = ['img-ph-warm','img-ph-sage','img-ph-clay','img-ph','img-ph-warm','img-ph-clay','img-ph-sage','img-ph','img-ph-warm','img-ph-clay','img-ph-sage','img-ph-warm'];
  return (
    <div className="tn-screen">
      <div className="tn-content">
        {/* Top nav */}
        <div style={{
          position: 'sticky', top: 0, zIndex: 5,
          padding: `${STATUS_PAD - 8}px 16px 12px`,
          background: 'rgba(244,242,236,0.92)',
          backdropFilter: 'blur(20px) saturate(180%)',
          display: 'flex', justifyContent: 'space-between', alignItems: 'center',
        }}>
          <div className="icon-btn"><IconChevL size={20} stroke="var(--ink)" /></div>
          <div style={{ textAlign: 'center', flex: 1 }}>
            <div className="t-cap-strong">Lễ Phật Đản 2025</div>
            <div className="t-micro" style={{ color: 'var(--ink-soft)', marginTop: 1 }}>48 ảnh · 18/05/2025</div>
          </div>
          <div className="icon-btn"><IconDownload size={18} stroke="var(--ink-muted)" /></div>
        </div>

        {/* Featured banner */}
        <div style={{ padding: '8px 20px 0' }}>
          <Img tag="đại lễ phật đản · 18/05/2025" variant="img-ph-warm"
            style={{ width: '100%', height: 220, borderRadius: 18, fontSize: 11 }} />
        </div>

        {/* Album meta */}
        <div style={{ padding: '14px 20px 8px' }}>
          <div className="t-h2">Lễ Phật Đản 2025</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 8, marginTop: 6 }}>
            <ReligionDot k="buddhism" />
            <span className="t-cap">Chùa Pháp Hoa · Phường 5</span>
            <span className="pill pill-emerald" style={{ marginLeft: 'auto' }}>
              <span className="dot" /> Hiển thị
            </span>
          </div>
        </div>

        {/* Grid */}
        <div style={{ padding: '8px 16px 4px' }}>
          <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', padding: '0 4px 8px' }}>
            Tất cả · 48 ảnh
          </div>
          <div style={{ display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)', gap: 4 }}>
            {variants.map((v, i) => (
              <Img key={i} tag={`#${i+1}`} variant={v} style={{ width: '100%', aspectRatio: '1/1', borderRadius: 6, fontSize: 10 }} />
            ))}
          </div>
        </div>

        {/* Other albums */}
        <div style={{ padding: '20px 0 0' }}>
          <SectionHeader title="Album khác của cơ sở" />
          <div style={{ display: 'flex', gap: 10, padding: '4px 20px 0', overflowX: 'auto' }}>
            <AlbumCardSmall name="Vu Lan 2024" count="61 ảnh" variant="img-ph-clay" />
            <AlbumCardSmall name="Tịnh tu mùa hạ" count="22 ảnh" variant="img-ph-sage" />
            <AlbumCardSmall name="Trùng tu chính điện" count="34 ảnh" variant="img-ph" />
          </div>
        </div>
      </div>
      <TabBar active="home" />
    </div>
  );
}

function AlbumCardSmall({ name, count, variant }) {
  return (
    <div style={{ width: 140, flexShrink: 0 }}>
      <Img tag={name.toLowerCase()} variant={variant} style={{ width: '100%', aspectRatio: '4/3', borderRadius: 12, fontSize: 10 }} />
      <div className="t-body-strong" style={{ marginTop: 6, fontSize: 13 }}>{name}</div>
      <div className="t-micro" style={{ color: 'var(--ink-soft)', marginTop: 1 }}>{count}</div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Statistics Dashboard
// ─────────────────────────────────────────────────────────────
function ScreenStats() {
  return (
    <div className="tn-screen">
      <div className="tn-content">
        <div style={{ padding: `${STATUS_PAD}px 20px 12px` }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <h1 className="t-hero" style={{ margin: 0 }}>Thống kê</h1>
              <div className="t-cap" style={{ marginTop: 2 }}>Phường 5 · Năm 2026</div>
            </div>
            <div className="icon-btn"><IconDownload size={18} stroke="var(--ink-muted)" /></div>
          </div>

          {/* Period */}
          <div style={{ display: 'flex', gap: 8, marginTop: 16, overflowX: 'auto' }}>
            {['Tháng này', 'Quý này', 'Năm 2026', 'Năm 2025'].map((f, i) => (
              <span key={f} className="pill"
                style={i === 2
                  ? { background: 'var(--ink)', color: '#fff' }
                  : { background: '#fff', color: 'var(--ink-muted)', border: '1px solid var(--hairline)' }
                }>{f}</span>
            ))}
          </div>
        </div>

        {/* Hero KPI — large */}
        <div style={{ padding: '12px 20px 0' }}>
          <div className="card" style={{ padding: 18 }}>
            <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase' }}>Cơ sở tôn giáo</div>
            <div style={{ display: 'flex', alignItems: 'baseline', gap: 8, marginTop: 4 }}>
              <span style={{ fontSize: 48, fontWeight: 700, letterSpacing: '-0.03em', lineHeight: 1 }}>48</span>
              <span className="t-cap" style={{ color: 'var(--ink-soft)' }}>cơ sở</span>
              <span className="pill pill-emerald" style={{ marginLeft: 'auto', fontSize: 11 }}>↑ +2</span>
            </div>
            {/* Breakdown bars */}
            <div style={{ marginTop: 18, display: 'flex', flexDirection: 'column', gap: 8 }}>
              <Bar label="Phật giáo" count={22} max={48} color={RELIGION.buddhism.color} />
              <Bar label="Công giáo" count={11} max={48} color={RELIGION.catholic.color} />
              <Bar label="Cao Đài" count={6} max={48} color={RELIGION.caodai.color} />
              <Bar label="Tin Lành" count={4} max={48} color={RELIGION.protestant.color} />
              <Bar label="Khác" count={5} max={48} color={'#8a6e4a'} />
            </div>
          </div>
        </div>

        {/* 2-col KPI */}
        <div style={{
          display: 'grid', gridTemplateColumns: '1fr 1fr', gap: 10,
          padding: '12px 20px 0',
        }}>
          <BigKpi label="Tổng tín đồ" value="8.420" unit="người" delta="↑ +124" tone="ok" />
          <BigKpi label="Chức sắc" value="68" unit="người" delta="— 0" tone="neutral" />
          <BigKpi label="Lễ hội 2026" value="12" unit="lễ hội" delta="↓ -2" tone="warn" />
          <BigKpi label="Diện tích đất" value="18.420" unit="m²" delta="↑ +340" tone="ok" />
        </div>

        {/* Donut — Tình trạng pháp lý */}
        <div style={{ padding: '12px 20px 0' }}>
          <div className="card" style={{ padding: 18 }}>
            <div className="t-h3" style={{ marginBottom: 12 }}>Tình trạng pháp lý</div>
            <div style={{ display: 'flex', alignItems: 'center', gap: 18 }}>
              <Donut segments={[
                { value: 38, color: '#2a8a5a' },
                { value: 6,  color: '#b8870c' },
                { value: 3,  color: 'var(--ink-soft)' },
                { value: 1,  color: '#b03328' },
              ]} />
              <div style={{ flex: 1, display: 'flex', flexDirection: 'column', gap: 8 }}>
                <LegendRow color="#2a8a5a" label="Đã công nhận" value="38" />
                <LegendRow color="#b8870c" label="Đang xét duyệt" value="6" />
                <LegendRow color="var(--ink-soft)" label="Chưa đăng ký" value="3" />
                <LegendRow color="#b03328" label="Đình chỉ" value="1" />
              </div>
            </div>
          </div>
        </div>

        {/* Area chart — Tín đồ theo tháng */}
        <div style={{ padding: '12px 20px 0' }}>
          <div className="card" style={{ padding: 18 }}>
            <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
              <div className="t-h3">Xu hướng tín đồ</div>
              <span className="t-cap">T1/25 → T5/26</span>
            </div>
            <AreaChart />
          </div>
        </div>

        {/* Recent activity */}
        <div style={{ padding: '20px 0 4px' }}>
          <SectionHeader title="Hoạt động gần đây" more="Xem hết" />
          <div className="card" style={{ margin: '4px 20px 0', padding: 0, overflow: 'hidden' }}>
            <ActivityRow kind="emerald" tag="Thêm mới" entity="Cơ sở" name="Tịnh xá Ngọc Phương" time="2 giờ trước" />
            <div className="hl" />
            <ActivityRow kind="blue" tag="Cập nhật" entity="Sửa chữa" name="Chùa Pháp Hoa · trùng tu mái" time="5 giờ trước" />
            <div className="hl" />
            <ActivityRow kind="amber" tag="Cấp phép" entity="Sự kiện" name="Lễ Hiệp Thông · GP-021/2026" time="hôm qua" />
          </div>
        </div>
      </div>
      <TabBar active="home" />
    </div>
  );
}

function Bar({ label, count, max, color }) {
  const pct = (count / max) * 100;
  return (
    <div>
      <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: 4 }}>
        <span className="t-cap" style={{ color: 'var(--ink-muted)' }}>{label}</span>
        <span className="t-cap-strong">{count}</span>
      </div>
      <div style={{ height: 6, background: 'var(--parchment-2)', borderRadius: 999, overflow: 'hidden' }}>
        <div style={{ width: `${pct}%`, height: '100%', background: color, borderRadius: 999 }} />
      </div>
    </div>
  );
}

function BigKpi({ label, value, unit, delta, tone }) {
  const deltaColor = { ok: 'var(--status-emerald-fg)', warn: 'var(--status-amber-fg)', neutral: 'var(--ink-soft)' }[tone];
  return (
    <div className="card" style={{ padding: 14, borderRadius: 16 }}>
      <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase' }}>{label}</div>
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 4, marginTop: 4 }}>
        <span style={{ fontSize: 24, fontWeight: 700, letterSpacing: '-0.02em', lineHeight: 1.05 }}>{value}</span>
        <span className="t-micro" style={{ color: 'var(--ink-soft)' }}>{unit}</span>
      </div>
      <div className="t-micro" style={{ marginTop: 6, color: deltaColor, fontWeight: 700 }}>{delta}</div>
    </div>
  );
}

function Donut({ segments }) {
  const total = segments.reduce((s, x) => s + x.value, 0);
  const r = 38, c = 2 * Math.PI * r;
  let offset = 0;
  return (
    <svg width="100" height="100" viewBox="0 0 100 100" style={{ flexShrink: 0 }}>
      <circle cx="50" cy="50" r={r} fill="none" stroke="var(--hairline)" strokeWidth="14" />
      {segments.map((s, i) => {
        const len = (s.value / total) * c;
        const el = (
          <circle key={i}
            cx="50" cy="50" r={r}
            fill="none" stroke={s.color} strokeWidth="14"
            strokeDasharray={`${len} ${c - len}`}
            strokeDashoffset={-offset}
            transform="rotate(-90 50 50)"
          />
        );
        offset += len;
        return el;
      })}
      <text x="50" y="48" textAnchor="middle" fontSize="20" fontWeight="700" fill="var(--ink)" letterSpacing="-0.03em">{total}</text>
      <text x="50" y="62" textAnchor="middle" fontSize="9" fill="var(--ink-soft)" letterSpacing="0.08em">CƠ SỞ</text>
    </svg>
  );
}

function LegendRow({ color, label, value }) {
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
      <span style={{ width: 9, height: 9, borderRadius: 3, background: color, flexShrink: 0 }} />
      <span className="t-cap" style={{ flex: 1, color: 'var(--ink-muted)' }}>{label}</span>
      <span className="t-cap-strong">{value}</span>
    </div>
  );
}

function AreaChart() {
  const pts = [8120, 8160, 8200, 8190, 8240, 8280, 8310, 8290, 8340, 8360, 8380, 8400, 8420, 8410, 8420, 8420, 8420];
  const max = 8500, min = 8000;
  const W = 320, H = 110;
  const xStep = W / (pts.length - 1);
  const yFor = v => H - ((v - min) / (max - min)) * H;
  const line = pts.map((v, i) => `${i === 0 ? 'M' : 'L'} ${i*xStep} ${yFor(v)}`).join(' ');
  const area = `${line} L ${W} ${H} L 0 ${H} Z`;
  return (
    <div style={{ marginTop: 12 }}>
      <svg viewBox={`0 0 ${W} ${H + 18}`} style={{ width: '100%', display: 'block' }}>
        <defs>
          <linearGradient id="grad" x1="0" x2="0" y1="0" y2="1">
            <stop offset="0" stopColor="#3b6fa0" stopOpacity="0.25" />
            <stop offset="1" stopColor="#3b6fa0" stopOpacity="0.02" />
          </linearGradient>
        </defs>
        <path d={area} fill="url(#grad)" />
        <path d={line} stroke="#3b6fa0" strokeWidth="2" fill="none" strokeLinejoin="round" strokeLinecap="round" />
        {/* dot at end */}
        <circle cx={W} cy={yFor(pts[pts.length-1])} r="4" fill="#3b6fa0" stroke="#fff" strokeWidth="2" />
        {/* axis labels */}
        <text x="0" y={H + 14} fontSize="9" fill="var(--ink-faint)">T1/25</text>
        <text x={W} y={H + 14} fontSize="9" fill="var(--ink-faint)" textAnchor="end">T5/26</text>
      </svg>
    </div>
  );
}

function ActivityRow({ kind, tag, entity, name, time }) {
  return (
    <div className="row" style={{ padding: '12px 16px' }}>
      <span className={`pill pill-${kind}`} style={{ padding: '2px 8px', fontSize: 10.5, flexShrink: 0 }}>{tag}</span>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="t-body-strong" style={{ fontSize: 13.5, textWrap: 'pretty' }}>{name}</div>
        <div className="t-micro" style={{ color: 'var(--ink-soft)', marginTop: 1 }}>{entity} · {time}</div>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Clergy / Người dùng detail
// ─────────────────────────────────────────────────────────────
function ScreenClergyDetail() {
  return (
    <div className="tn-screen">
      <div className="tn-content" style={{ paddingBottom: 110 }}>
        {/* Header */}
        <div style={{
          background: 'var(--tile-dark)',
          color: 'var(--on-dark)',
          padding: `${STATUS_PAD - 8}px 20px 28px`,
          borderBottomLeftRadius: 24, borderBottomRightRadius: 24,
        }}>
          <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
            <div className="icon-btn" style={{ background: 'rgba(255,255,255,0.12)', border: '1px solid rgba(255,255,255,0.18)' }}>
              <IconChevL size={20} stroke="#fff" />
            </div>
            <div className="icon-btn" style={{ background: 'rgba(255,255,255,0.12)', border: '1px solid rgba(255,255,255,0.18)' }}>
              <IconShare size={18} stroke="#fff" />
            </div>
          </div>

          <div style={{ textAlign: 'center', marginTop: 24 }}>
            <div className="avatar" style={{
              width: 88, height: 88, fontSize: 30, margin: '0 auto',
              background: '#faf2d8', color: '#735a14',
              border: '3px solid rgba(255,255,255,0.12)',
            }}>TQ</div>
            <h1 className="t-title" style={{ margin: '14px 0 0', color: '#fff' }}>Thượng toạ Thích Trí Quảng</h1>
            <div style={{ marginTop: 4, color: 'var(--on-dark-muted)', fontSize: 14, fontWeight: 500 }}>
              Trụ trì · Chùa Pháp Hoa
            </div>
            <div style={{ display: 'flex', justifyContent: 'center', gap: 6, marginTop: 12 }}>
              <span className="pill" style={{ background: 'rgba(255,255,255,0.12)', color: '#fff' }}>
                <ReligionDot k="buddhism" /> Phật giáo
              </span>
              <span className="pill pill-emerald" style={{ background: 'rgba(34,138,90,0.22)', color: '#a8e4c2' }}>
                <span className="dot" style={{ background: '#5cd99a' }} />Đang hoạt động
              </span>
            </div>
          </div>
        </div>

        {/* Info cards */}
        <div style={{ padding: '20px 20px 4px' }}>
          <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
            <InfoRow label="Năm sinh" value="1959 · 67 tuổi" />
            <InfoRow label="Quê quán" value="Thừa Thiên Huế" />
            <InfoRow label="Đảm nhiệm từ" value="1996" />
            <InfoRow label="Cơ sở" value="Chùa Pháp Hoa" />
            <InfoRow label="Khu phố" value="Khu phố 4, Phường 5" />
            <InfoRow label="Điện thoại" value="028 3551 2xxx" mono />
            <InfoRow label="Email" value="trutri.phaphoa@pg.vn" mono last />
          </div>
        </div>

        {/* Note */}
        <div style={{ padding: '16px 20px 0' }}>
          <div style={{
            background: 'linear-gradient(135deg, #fbf1d9, #f7e6bf)',
            border: '1px solid #ecd9a6',
            borderRadius: 14, padding: 14,
          }}>
            <div className="t-micro" style={{ color: '#8a6310', textTransform: 'uppercase', marginBottom: 4 }}>Ghi chú</div>
            <div className="t-body" style={{ color: '#735a14', textWrap: 'pretty' }}>
              Phụ trách Ban Hoằng pháp Giáo hội Phật giáo Quận Bình Thạnh nhiệm kỳ 2022–2027.
            </div>
          </div>
        </div>

        {/* Quick actions */}
        <div style={{ padding: '20px 20px 0', display: 'flex', gap: 8 }}>
          <button className="btn-primary" style={{ flex: 1 }}>
            <IconPhone size={15} stroke="#fff" /> Gọi điện
          </button>
          <button className="btn-ghost" style={{ flex: 1 }}>
            <IconMail size={15} stroke="var(--ink-muted)" /> Email
          </button>
        </div>
      </div>
      <TabBar active="home" />
    </div>
  );
}

Object.assign(window, {
  ScreenNewsList, ScreenNewsDetail, ScreenNotifications,
  ScreenAlbum, ScreenStats, ScreenClergyDetail,
  NewsItem, NotifCard, AlbumCardSmall, Bar, BigKpi, Donut,
  LegendRow, AreaChart, ActivityRow,
});
