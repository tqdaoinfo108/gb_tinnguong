// icons.jsx — SVG icons (stroke-based, 24×24 viewBox by default)

const Icon = ({ d, size = 22, stroke = "currentColor", fill = "none", strokeWidth = 1.8, children, viewBox = "0 0 24 24" }) => (
  <svg width={size} height={size} viewBox={viewBox} fill={fill} stroke={stroke} strokeWidth={strokeWidth} strokeLinecap="round" strokeLinejoin="round">
    {d ? <path d={d} /> : children}
  </svg>
);

const IconHome = (p) => <Icon {...p}><path d="M3 11l9-7 9 7v9a1 1 0 0 1-1 1h-5v-6h-6v6H4a1 1 0 0 1-1-1z" /></Icon>;
const IconMap = (p) => <Icon {...p}><path d="M9 4L3 6v14l6-2 6 2 6-2V4l-6 2-6-2z" /><path d="M9 4v14M15 6v14" /></Icon>;
const IconCalendar = (p) => <Icon {...p}><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M3 10h18M8 3v4M16 3v4" /></Icon>;
const IconNews = (p) => <Icon {...p}><path d="M4 5h12a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4z" /><path d="M18 9h2v10a2 2 0 0 1-2 2M7 9h7M7 13h7M7 17h4" /></Icon>;
const IconBell = (p) => <Icon {...p}><path d="M6 8a6 6 0 0 1 12 0c0 7 3 8 3 8H3s3-1 3-8M10 21a2 2 0 0 0 4 0" /></Icon>;
const IconSearch = (p) => <Icon {...p}><circle cx="11" cy="11" r="7" /><path d="M21 21l-4.3-4.3" /></Icon>;
const IconChevR = (p) => <Icon {...p}><path d="M9 6l6 6-6 6" /></Icon>;
const IconChevL = (p) => <Icon {...p}><path d="M15 6l-6 6 6 6" /></Icon>;
const IconChevD = (p) => <Icon {...p}><path d="M6 9l6 6 6-6" /></Icon>;
const IconClose = (p) => <Icon {...p}><path d="M6 6l12 12M18 6L6 18" /></Icon>;
const IconPin = (p) => <Icon {...p}><path d="M12 21s-7-6-7-12a7 7 0 0 1 14 0c0 6-7 12-7 12z" /><circle cx="12" cy="9" r="2.5" /></Icon>;
const IconLayers = (p) => <Icon {...p}><path d="M12 3l9 5-9 5-9-5 9-5z" /><path d="M3 12l9 5 9-5M3 17l9 5 9-5" /></Icon>;
const IconEye = (p) => <Icon {...p}><path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z" /><circle cx="12" cy="12" r="3" /></Icon>;
const IconRoute = (p) => <Icon {...p}><circle cx="6" cy="19" r="3" /><circle cx="18" cy="5" r="3" /><path d="M6 16V9a4 4 0 0 1 4-4h4M18 8v7a4 4 0 0 1-4 4h-4" /></Icon>;
const IconRuler = (p) => <Icon {...p}><path d="M3 17L17 3l4 4L7 21z" /><path d="M7 13l2 2M10 10l2 2M13 7l2 2" /></Icon>;
const IconShare = (p) => <Icon {...p}><path d="M12 3v12M7 8l5-5 5 5M5 21h14a2 2 0 0 0 2-2v-4H3v4a2 2 0 0 0 2 2z" /></Icon>;
const IconBookmark = (p) => <Icon {...p}><path d="M6 3h12v18l-6-4-6 4z" /></Icon>;
const IconCalCheck = (p) => <Icon {...p}><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M3 10h18M8 3v4M16 3v4M9 15l2 2 4-4" /></Icon>;
const IconUsers = (p) => <Icon {...p}><circle cx="9" cy="8" r="4" /><path d="M2 21a7 7 0 0 1 14 0M17 11a4 4 0 0 0 0-8M22 21a7 7 0 0 0-5-6.7" /></Icon>;
const IconUser = (p) => <Icon {...p}><circle cx="12" cy="8" r="4" /><path d="M4 21a8 8 0 0 1 16 0" /></Icon>;
const IconBuilding = (p) => <Icon {...p}><path d="M5 21V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2v16" /><path d="M3 21h18M9 7h2M13 7h2M9 11h2M13 11h2M9 15h2M13 15h2M10 21v-3h4v3" /></Icon>;
const IconStats = (p) => <Icon {...p}><path d="M3 21h18M7 17v-6M12 17V7M17 17v-9" /></Icon>;
const IconDoc = (p) => <Icon {...p}><path d="M14 3H6a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V9z" /><path d="M14 3v6h6M8 13h8M8 17h5" /></Icon>;
const IconPhone = (p) => <Icon {...p}><path d="M5 4h4l2 5-2.5 1.5a11 11 0 0 0 5 5L15 13l5 2v4a2 2 0 0 1-2 2A16 16 0 0 1 3 6a2 2 0 0 1 2-2" /></Icon>;
const IconMail = (p) => <Icon {...p}><rect x="3" y="5" width="18" height="14" rx="2" /><path d="M3 7l9 7 9-7" /></Icon>;
const IconClock = (p) => <Icon {...p}><circle cx="12" cy="12" r="9" /><path d="M12 7v5l3 2" /></Icon>;
const IconAlert = (p) => <Icon {...p}><path d="M12 3l10 18H2z" /><path d="M12 10v5M12 18v.5" /></Icon>;
const IconCheck = (p) => <Icon {...p}><path d="M4 12l5 5L20 6" /></Icon>;
const IconPlus = (p) => <Icon {...p}><path d="M12 5v14M5 12h14" /></Icon>;
const IconMinus = (p) => <Icon {...p}><path d="M5 12h14" /></Icon>;
const IconExpand = (p) => <Icon {...p}><path d="M3 9V3h6M21 9V3h-6M3 15v6h6M21 15v6h-6" /></Icon>;
const IconCompress = (p) => <Icon {...p}><path d="M9 3v6H3M15 3v6h6M9 21v-6H3M15 21v-6h6" /></Icon>;
const IconLoc = (p) => <Icon {...p}><circle cx="12" cy="12" r="3" /><path d="M12 2v3M12 19v3M2 12h3M19 12h3" /></Icon>;
const IconFilter = (p) => <Icon {...p}><path d="M3 5h18M6 12h12M10 19h4" /></Icon>;
const IconArea = (p) => <Icon {...p}><path d="M4 4h7v7H4zM13 4h7v7h-7zM4 13h7v7H4zM13 13h7v7h-7z" strokeDasharray="2 2" /></Icon>;
const IconGrid = (p) => <Icon {...p}><rect x="3" y="3" width="7" height="7" rx="1" /><rect x="14" y="3" width="7" height="7" rx="1" /><rect x="3" y="14" width="7" height="7" rx="1" /><rect x="14" y="14" width="7" height="7" rx="1" /></Icon>;
const IconList = (p) => <Icon {...p}><path d="M8 6h13M8 12h13M8 18h13M4 6h.01M4 12h.01M4 18h.01" /></Icon>;
const IconHammer = (p) => <Icon {...p}><path d="M14 3l7 7-3 3-7-7zM10 7l-7 7 4 4 7-7" /></Icon>;
const IconHistory = (p) => <Icon {...p}><path d="M3 12a9 9 0 1 0 3-6.7L3 8" /><path d="M3 3v5h5M12 7v5l3 2" /></Icon>;
const IconImg = (p) => <Icon {...p}><rect x="3" y="5" width="18" height="14" rx="2" /><circle cx="9" cy="11" r="2" /><path d="M3 17l5-4 4 3 4-3 5 4" /></Icon>;
const IconHeart = (p) => <Icon {...p}><path d="M12 20s-7-4.5-7-11a4 4 0 0 1 7-2.5A4 4 0 0 1 19 9c0 6.5-7 11-7 11z" /></Icon>;
const IconRefresh = (p) => <Icon {...p}><path d="M3 12a9 9 0 0 1 15-6.7L21 8M21 3v5h-5M21 12a9 9 0 0 1-15 6.7L3 16M3 21v-5h5" /></Icon>;
const IconDownload = (p) => <Icon {...p}><path d="M12 3v13M7 11l5 5 5-5M4 21h16" /></Icon>;
const IconLink = (p) => <Icon {...p}><path d="M10 14a4 4 0 0 1 0-5.66l3.17-3.17a4 4 0 1 1 5.66 5.66l-1.5 1.5" /><path d="M14 10a4 4 0 0 1 0 5.66l-3.17 3.17a4 4 0 1 1-5.66-5.66l1.5-1.5" /></Icon>;
const IconChat = (p) => <Icon {...p}><path d="M21 11a8 8 0 0 1-12.2 6.8L3 19l1.2-5.8A8 8 0 1 1 21 11z" /></Icon>;
const IconShield = (p) => <Icon {...p}><path d="M12 3l8 3v6c0 5-3.5 8-8 9-4.5-1-8-4-8-9V6z" /><path d="M9 12l2 2 4-4" /></Icon>;

// Tab bar
function TabBar({ active = 'home' }) {
  const tabs = [
    { id: 'home', label: 'Trang chủ', Icon: IconHome },
    { id: 'map', label: 'Bản đồ', Icon: IconMap },
    { id: 'events', label: 'Sự kiện', Icon: IconCalendar },
    { id: 'news', label: 'Tin tức', Icon: IconNews },
    { id: 'notif', label: 'Thông báo', Icon: IconBell },
  ];
  return (
    <div className="tn-tabbar">
      {tabs.map(t => (
        <div key={t.id} className={`tn-tab ${active === t.id ? 'active' : ''}`}>
          <t.Icon size={22} strokeWidth={active === t.id ? 2.1 : 1.7} />
          <span>{t.label}</span>
        </div>
      ))}
    </div>
  );
}

Object.assign(window, {
  Icon, TabBar,
  IconHome, IconMap, IconCalendar, IconNews, IconBell, IconSearch,
  IconChevR, IconChevL, IconChevD, IconClose, IconPin, IconLayers,
  IconEye, IconRoute, IconRuler, IconShare, IconBookmark, IconCalCheck,
  IconUsers, IconUser, IconBuilding, IconStats, IconDoc, IconPhone,
  IconMail, IconClock, IconAlert, IconCheck, IconPlus, IconMinus,
  IconExpand, IconCompress, IconLoc, IconFilter, IconArea, IconGrid,
  IconList, IconHammer, IconHistory, IconImg, IconHeart, IconRefresh,
  IconDownload, IconLink, IconChat, IconShield,
});
