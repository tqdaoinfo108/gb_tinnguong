// screens-events.jsx — Lễ hội & Hoạt động (list, calendar, detail)

// ─────────────────────────────────────────────────────────────
// Events List
// ─────────────────────────────────────────────────────────────
function ScreenEventList() {
  return (
    <div className="tn-screen">
      <div className="tn-content">
        {/* Header */}
        <div style={{ padding: `${STATUS_PAD}px 20px 12px` }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <h1 className="t-hero" style={{ margin: 0 }}>Sự kiện</h1>
              <div className="t-cap" style={{ marginTop: 2 }}>Lễ hội & hoạt động · 12 sự kiện</div>
            </div>
            <div className="icon-btn"><IconFilter size={18} stroke="var(--ink-muted)" /></div>
          </div>

          {/* Toggle */}
          <div style={{
            marginTop: 16, display: 'inline-flex',
            padding: 3, borderRadius: 999,
            background: 'rgba(30,45,61,0.06)',
          }}>
            <ToggleSeg active>Danh sách</ToggleSeg>
            <ToggleSeg>Lịch năm</ToggleSeg>
          </div>
        </div>

        {/* Alert banner — chưa có phép */}
        <div style={{ padding: '4px 20px 0' }}>
          <div style={{
            background: 'linear-gradient(135deg, #fbf1d9 0%, #f7e6bf 100%)',
            border: '1px solid #ecd9a6',
            borderRadius: 16, padding: 14,
            display: 'flex', gap: 12, alignItems: 'flex-start',
          }}>
            <div style={{
              width: 32, height: 32, borderRadius: 10,
              background: '#f0c878',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              flexShrink: 0,
            }}>
              <IconAlert size={18} stroke="#735a14" strokeWidth={2.2} />
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div className="t-body-strong" style={{ color: '#735a14' }}>2 sự kiện chưa có giấy phép</div>
              <div className="t-cap" style={{ color: '#8a6310', marginTop: 2 }}>
                Lễ Vu Lan · Chùa Pháp Hoa · còn 6 ngày
              </div>
            </div>
          </div>
        </div>

        {/* KPI strip */}
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)',
          gap: 8, padding: '16px 20px 0',
        }}>
          <KpiTile label="Tổng" value="12" />
          <KpiTile label="Sắp tới" value="3" />
          <KpiTile label="Đã phép" value="10" tone="emerald" />
          <KpiTile label="Chưa phép" value="2" tone="amber" />
        </div>

        {/* Filters */}
        <div style={{ padding: '16px 20px 8px', display: 'flex', gap: 8, overflowX: 'auto' }}>
          <FilterDropdown label="Trạng thái" />
          <FilterDropdown label="Giấy phép" />
          <FilterDropdown label="Tôn giáo" />
        </div>

        {/* Event cards */}
        <div style={{ padding: '4px 20px 0', display: 'flex', flexDirection: 'column', gap: 12 }}>
          <EventCardLarge
            date="18" month="THÁNG 5" weekday="THỨ HAI"
            religion="buddhism"
            name="Đại lễ Phật Đản"
            place="Chùa Pháp Hoa"
            attendees="~ 2.500 người"
            permit="Đã cấp · GP-018/2026"
            permitKind="emerald"
            status="Sắp diễn ra"
            statusKind="blue"
            variant="img-ph-warm"
          />
          <EventCardLarge
            date="22" month="THÁNG 5" weekday="THỨ SÁU"
            religion="catholic"
            name="Lễ Hiệp Thông"
            place="Nhà thờ Hiển Linh"
            attendees="~ 800 người"
            permit="Đã cấp · GP-021/2026"
            permitKind="emerald"
            status="Sắp diễn ra"
            statusKind="blue"
            variant="img-ph-clay"
          />
          <EventCardLarge
            date="29" month="THÁNG 5" weekday="THỨ SÁU"
            religion="buddhism"
            name="Lễ Vu Lan báo hiếu"
            place="Chùa Pháp Hoa"
            attendees="~ 3.000 người"
            permit="Chưa có phép"
            permitKind="amber"
            status="Sắp diễn ra"
            statusKind="blue"
            variant="img-ph-sage"
          />
        </div>
      </div>
      <TabBar active="events" />
    </div>
  );
}

function ToggleSeg({ active, children }) {
  return (
    <span style={{
      padding: '7px 16px',
      borderRadius: 999,
      fontSize: 13, fontWeight: 600,
      background: active ? '#fff' : 'transparent',
      color: active ? 'var(--ink)' : 'var(--ink-soft)',
      boxShadow: active ? '0 1px 3px rgba(0,0,0,0.06)' : 'none',
    }}>{children}</span>
  );
}

function KpiTile({ label, value, tone }) {
  const fg = { emerald: 'var(--status-emerald-fg)', amber: 'var(--status-amber-fg)' }[tone] || 'var(--ink)';
  return (
    <div className="card" style={{ padding: '10px 12px', borderRadius: 14 }}>
      <div style={{ fontSize: 22, fontWeight: 700, letterSpacing: '-0.02em', color: fg, lineHeight: 1.05 }}>{value}</div>
      <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', marginTop: 2 }}>{label}</div>
    </div>
  );
}

function EventCardLarge({ date, month, weekday, religion, name, place, attendees, permit, permitKind, status, statusKind, variant }) {
  return (
    <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
      <div style={{ display: 'flex' }}>
        {/* Date block */}
        <div style={{
          width: 88, padding: '16px 0',
          background: 'var(--parchment)',
          borderRight: '1px solid var(--hairline)',
          display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
        }}>
          <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase' }}>{month}</div>
          <div style={{ fontSize: 36, fontWeight: 700, letterSpacing: '-0.025em', lineHeight: 1 }}>{date}</div>
          <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', marginTop: 2 }}>{weekday}</div>
        </div>
        {/* Right side */}
        <div style={{ flex: 1, padding: 14, minWidth: 0 }}>
          <div style={{ display: 'flex', alignItems: 'center', gap: 6, marginBottom: 4 }}>
            <ReligionDot k={religion} />
            <span className="t-cap-strong" style={{ color: 'var(--ink-soft)' }}>{RELIGION[religion].name}</span>
          </div>
          <div className="t-h3" style={{ textWrap: 'pretty' }}>{name}</div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 5, marginTop: 5 }}>
            <IconPin size={12} stroke="var(--ink-soft)" />
            <span className="t-cap">{place}</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 5, marginTop: 3 }}>
            <IconUsers size={12} stroke="var(--ink-soft)" />
            <span className="t-cap">{attendees}</span>
          </div>
        </div>
      </div>
      {/* Footer */}
      <div style={{
        borderTop: '1px solid var(--hairline)',
        padding: '10px 14px',
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <StatusPill kind={permitKind} label={permit} />
        <StatusPill kind={statusKind} label={status} />
      </div>
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Events Calendar (year view)
// ─────────────────────────────────────────────────────────────
function ScreenEventCalendar() {
  return (
    <div className="tn-screen">
      <div className="tn-content">
        {/* Header */}
        <div style={{ padding: `${STATUS_PAD}px 20px 12px` }}>
          <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
            <div>
              <h1 className="t-hero" style={{ margin: 0 }}>Lịch 2026</h1>
              <div className="t-cap" style={{ marginTop: 2 }}>Tổng 12 sự kiện · 2 chưa có phép</div>
            </div>
            <div style={{ display: 'flex', gap: 6 }}>
              <div className="icon-btn"><IconChevL size={16} stroke="var(--ink-muted)" /></div>
              <div className="icon-btn"><IconChevR size={16} stroke="var(--ink-muted)" /></div>
            </div>
          </div>

          {/* Toggle */}
          <div style={{
            marginTop: 16, display: 'inline-flex',
            padding: 3, borderRadius: 999,
            background: 'rgba(30,45,61,0.06)',
          }}>
            <ToggleSeg>Danh sách</ToggleSeg>
            <ToggleSeg active>Lịch năm</ToggleSeg>
          </div>
        </div>

        {/* Month grid */}
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(3, 1fr)',
          gap: 8, padding: '8px 20px 0',
        }}>
          {[
            { m: 'T1', n: 1 },
            { m: 'T2', n: 0 },
            { m: 'T3', n: 1, special: true },
            { m: 'T4', n: 1 },
            { m: 'T5', n: 3, hot: true },
            { m: 'T6', n: 1 },
            { m: 'T7', n: 1 },
            { m: 'T8', n: 2 },
            { m: 'T9', n: 1 },
            { m: 'T10', n: 0 },
            { m: 'T11', n: 1 },
            { m: 'T12', n: 0 },
          ].map(month => (
            <MonthTile key={month.m} {...month} />
          ))}
        </div>

        {/* This month details */}
        <div style={{ padding: '20px 20px 4px' }}>
          <h3 className="t-h2" style={{ margin: 0, marginBottom: 12 }}>Tháng 5 · 3 sự kiện</h3>
          <div className="card" style={{ padding: 0, overflow: 'hidden' }}>
            <CalEventRow day="18" name="Đại lễ Phật Đản" place="Chùa Pháp Hoa" permit="ok" />
            <div className="hl" />
            <CalEventRow day="22" name="Lễ Hiệp Thông" place="Nhà thờ Hiển Linh" permit="ok" />
            <div className="hl" />
            <CalEventRow day="29" name="Lễ Vu Lan báo hiếu" place="Chùa Pháp Hoa" permit="warn" />
          </div>
        </div>
      </div>
      <TabBar active="events" />
    </div>
  );
}

function MonthTile({ m, n, hot, special }) {
  const dots = Math.min(n, 4);
  return (
    <div style={{
      background: '#fff',
      border: hot ? '1.5px solid var(--primary)' : '1px solid var(--hairline)',
      borderRadius: 14,
      padding: '10px 11px',
      minHeight: 76,
      position: 'relative',
    }}>
      <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between' }}>
        <span className="t-h3" style={{ color: hot ? 'var(--primary)' : 'var(--ink)' }}>{m}</span>
        <span className="t-micro" style={{ color: 'var(--ink-faint)' }}>{n}</span>
      </div>
      <div style={{ display: 'flex', gap: 3, marginTop: 14, flexWrap: 'wrap' }}>
        {[...Array(dots)].map((_, i) => (
          <span key={i} style={{
            width: 6, height: 6, borderRadius: 999,
            background: i === dots - 1 && special ? '#b8870c' : (i === 2 && m === 'T5' ? '#b8870c' : 'var(--primary)'),
          }} />
        ))}
      </div>
    </div>
  );
}

function CalEventRow({ day, name, place, permit }) {
  return (
    <div className="row" style={{ padding: '14px 16px' }}>
      <div style={{
        width: 42, height: 42, borderRadius: 12,
        background: 'var(--parchment)',
        display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
        flexShrink: 0,
      }}>
        <span style={{ fontSize: 16, fontWeight: 700, letterSpacing: '-0.02em', lineHeight: 1 }}>{day}</span>
        <span className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase', marginTop: 1 }}>T5</span>
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="t-body-strong">{name}</div>
        <div className="t-cap" style={{ marginTop: 1 }}>{place}</div>
      </div>
      <span style={{
        width: 10, height: 10, borderRadius: 999,
        background: permit === 'ok' ? '#2a8a5a' : '#b8870c',
      }} />
    </div>
  );
}

// ─────────────────────────────────────────────────────────────
// Event Detail
// ─────────────────────────────────────────────────────────────
function ScreenEventDetail() {
  return (
    <div className="tn-screen">
      <div className="tn-content" style={{ paddingBottom: 110 }}>
        {/* Hero */}
        <div style={{ position: 'relative', height: 280 }}>
          <Img tag="đại lễ phật đản" variant="img-ph-warm"
            style={{ position: 'absolute', inset: 0, width: '100%', height: '100%', fontSize: 11 }} />
          <div style={{
            position: 'absolute', inset: 0,
            background: 'linear-gradient(to bottom, rgba(30,45,61,0.5), transparent 30%, transparent 50%, rgba(30,45,61,0.7))',
          }} />
          {/* nav */}
          <div style={{
            position: 'absolute', left: 16, right: 16, top: STATUS_PAD - 4,
            display: 'flex', justifyContent: 'space-between',
          }}>
            <div className="icon-btn" style={{ width: 42, height: 42, background: 'rgba(255,255,255,0.92)' }}>
              <IconChevL size={20} stroke="var(--ink)" />
            </div>
            <div className="icon-btn" style={{ width: 42, height: 42, background: 'rgba(255,255,255,0.92)' }}>
              <IconShare size={18} stroke="var(--ink)" />
            </div>
          </div>
          {/* Title overlay */}
          <div style={{ position: 'absolute', left: 20, right: 20, bottom: 20, color: '#fff' }}>
            <span className="pill pill-blue" style={{ background: 'rgba(59,111,160,0.9)', color: '#fff' }}>
              <span className="dot" style={{ background: '#fff' }}></span> Sắp diễn ra
            </span>
            <h1 className="t-title" style={{ margin: '10px 0 0', color: '#fff' }}>Đại lễ Phật Đản</h1>
            <div style={{ marginTop: 4, color: 'rgba(255,255,255,0.85)', fontSize: 14, fontWeight: 500 }}>
              Phật lịch 2570 · Dương lịch 2026
            </div>
          </div>
        </div>

        {/* Quick facts */}
        <div style={{
          margin: '-20px 20px 0',
          background: '#fff',
          borderRadius: 18,
          border: '1px solid var(--hairline)',
          boxShadow: '0 4px 20px rgba(30,45,61,0.08)',
          padding: 18,
          position: 'relative',
        }}>
          <FactRow Icon={IconCalendar} label="Thời gian" value="18 – 22 / 05 / 2026" />
          <div className="hl" style={{ margin: '12px 0' }} />
          <FactRow Icon={IconPin} label="Địa điểm" value="Chùa Pháp Hoa · 870/53 Lê Quang Định" />
          <div className="hl" style={{ margin: '12px 0' }} />
          <FactRow Icon={IconUsers} label="Tham dự dự kiến" value="~ 2.500 người" />
          <div className="hl" style={{ margin: '12px 0' }} />
          <FactRow Icon={IconShield} label="Giấy phép" value="Đã cấp · GP-018/2026" tone="emerald" />
        </div>

        {/* Description */}
        <div style={{ padding: '24px 20px 4px' }}>
          <h3 className="t-h2" style={{ margin: 0, marginBottom: 8 }}>Nội dung sự kiện</h3>
          <p className="t-body" style={{ margin: 0, color: 'var(--ink-muted)', textWrap: 'pretty' }}>
            Đại lễ Phật Đản được tổ chức trong 5 ngày, gồm các nghi lễ tắm Phật, thuyết pháp, diễu hành xe hoa,
            văn nghệ Phật giáo, và bữa cơm chay đãi khách thập phương. Sự kiện được tổ chức bởi Ban Trị sự
            Phật giáo Quận Bình Thạnh phối hợp với Chùa Pháp Hoa.
          </p>
        </div>

        {/* Schedule */}
        <div style={{ padding: '24px 0 4px' }}>
          <SectionHeader title="Chương trình" />
          <div style={{ padding: '4px 20px 0', display: 'flex', flexDirection: 'column', gap: 0 }}>
            <ScheduleRow time="06:00" title="Khai mạc – Tụng kinh khai lễ" />
            <ScheduleRow time="09:00" title="Lễ tắm Phật" />
            <ScheduleRow time="14:00" title="Thuyết pháp – Ý nghĩa Phật Đản" />
            <ScheduleRow time="18:00" title="Diễu hành xe hoa quanh phường" />
            <ScheduleRow time="19:30" title="Văn nghệ – Bế mạc" last />
          </div>
        </div>

        {/* Organizer */}
        <div style={{ padding: '24px 20px 4px' }}>
          <h3 className="t-h2" style={{ margin: 0, marginBottom: 12 }}>Đơn vị tổ chức</h3>
          <div className="card" style={{ padding: 14, display: 'flex', alignItems: 'center', gap: 12 }}>
            <div style={{
              width: 44, height: 44, borderRadius: 12,
              background: '#faf2d8',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              flexShrink: 0,
            }}>
              <ReligionDot k="buddhism" />
            </div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div className="t-body-strong">Chùa Pháp Hoa</div>
              <div className="t-cap" style={{ marginTop: 1 }}>Phật giáo · Phường 5</div>
            </div>
            <IconChevR size={16} stroke="var(--ink-faint)" />
          </div>
        </div>
      </div>
      <TabBar active="events" />
    </div>
  );
}

function FactRow({ Icon, label, value, tone }) {
  const valueColor = { emerald: 'var(--status-emerald-fg)' }[tone] || 'var(--ink)';
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
      <div style={{
        width: 32, height: 32, borderRadius: 9,
        background: 'var(--parchment)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        flexShrink: 0,
      }}>
        <Icon size={16} stroke="var(--ink-muted)" />
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div className="t-micro" style={{ color: 'var(--ink-soft)', textTransform: 'uppercase' }}>{label}</div>
        <div className="t-body-strong" style={{ marginTop: 1, color: valueColor }}>{value}</div>
      </div>
    </div>
  );
}

function ScheduleRow({ time, title, last }) {
  return (
    <div style={{
      display: 'flex', gap: 16, alignItems: 'flex-start',
      paddingBottom: last ? 0 : 14,
      position: 'relative',
    }}>
      <div style={{ width: 52, flexShrink: 0, paddingTop: 1 }}>
        <span className="t-mono" style={{ color: 'var(--ink)', fontWeight: 600 }}>{time}</span>
      </div>
      <div style={{
        width: 12, display: 'flex', flexDirection: 'column', alignItems: 'center',
        flexShrink: 0, paddingTop: 5,
      }}>
        <span style={{ width: 8, height: 8, borderRadius: 999, background: 'var(--primary)' }} />
        {!last && <span style={{ flex: 1, width: 1.5, background: 'var(--hairline)', marginTop: 2, minHeight: 18 }} />}
      </div>
      <div className="t-body" style={{ flex: 1, paddingTop: 0 }}>{title}</div>
    </div>
  );
}

Object.assign(window, {
  ScreenEventList, ScreenEventCalendar, ScreenEventDetail,
  ToggleSeg, KpiTile, EventCardLarge, MonthTile, CalEventRow,
  FactRow, ScheduleRow,
});
