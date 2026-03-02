---
title: "Optimal UX Reference Library Structure for Eagle"
type: "research"
status: "seed"
version: "0.1.0"
created: "2026-03-02"
updated: "2026-03-02"
freshness: "current"
freshness_checked: "2026-03-02"
tags:
  - "type/research"
related_components: []
related_tokens: []
related_patterns: []
related_heuristics: []
platforms:
  - "web"
  - "iOS"
  - "Android"
description: "Research on optimal structure for a UI/UX reference library in Eagle"
---

Анализ **7 ведущих референс-сервисов** выявил консенсус в организации UI-коллекций: **трёхуровневая таксономия** (платформа → тип экрана → UI-элементы) в сочетании с **индустриальными тегами** обеспечивает максимальную гибкость поиска. Mobbin с **400,000+ скриншотами** задаёт отраслевой стандарт, разделяя контент на Screen Types (50+), UI Elements (60+), Flow Types (40+) и Industry Categories (20). Ключевое открытие: Pttrns использует уникальную **двойную таксономию**, разделяя UX-паттерны (поведенческие) и UI-элементы (компонентные) — этот подход идеален для Eagle с его системой тегов и папок.

---

## Сравнительный анализ референс-сервисов

### Mobbin — золотой стандарт категоризации

Mobbin организует контент по **4 основным типам**: Apps (профили приложений), Screens (отдельные экраны), Flows (пользовательские сценарии) и UI Elements (компоненты). Платформы чётко разделены: iOS, Android, Web и отдельно Sites для лендингов.

**Система Screen Types** включает **50+ категорий**, сгруппированных логически:

- **Authentication**: Welcome, Login, Signup, Verification, Forgot Password, Permission
- **Core Navigation**: Home, Browse & Discover, Search, Filter & Sort, Dashboard
- **Commerce**: Shop, Product Detail, Cart, Checkout, Payment Method, Subscription & Paywall
- **User Account**: Profile, Settings, Edit
- **Content**: Timeline, Social Feed, Chat Detail, Calendar, Reviews & Ratings
- **States**: Empty State, Error, Loading, Progress, Confirmation

**UI Elements** разбиты на **60+ компонентов**: Top Navigation Bar, Tab Bar, Side Navigation, Button, Text Field, Search Bar, Card, Carousel, Dialog, Bottom Sheet, Toast, Badge и другие. Важно: каждый элемент имеет **глоссарий с определением** на mobbin.com/glossary.

**Flow Types** описывают действия пользователя (**40+ категорий**): Onboarding, Creating Account, Searching & Finding, Purchasing & Ordering, Chatting, Editing Profile, Subscribing & Upgrading. Это позволяет искать не просто экраны, а целые пользовательские сценарии.

### Screenlane и PageFlows — комплементарный подход

**Screenlane** фокусируется на статических скриншотах с **5-мерной фильтрацией**: Platform, Views (Screen Types), Elements, Product Categories, Products (бренды). Уникальная сила — детальная разметка UI-элементов: Activity feed, Breadcrumbs, Calendar, Canvas, Chatbot, Color picker, Drag & drop, Hotspot, Kanban.

**PageFlows** специализируется на **видеозаписях user flows** с пошаговыми аннотациями. Охватывает **4 платформы** включая Desktop и Email-дизайн. Содержит **100+ специфических типов flows**: Creating an invoice, Driver signup, Enabling 2FA, Identity verification, In-app purchases. Цена: $99/год.

### UISources и Pttrns — взаимодополняющие системы

**UISources** (800+ видео, 2,400+ скриншотов) выделяется коллекцией **микровзаимодействий и анимаций**. Уникальные категории: Gamification (26 примеров), Coach Mark (64), Augmented Reality (11), Chat Bot (14). Организация flow-центричная — скриншоты группируются в контекстные последовательности.

**Pttrns** (7,000+ паттернов) предлагает **трёхуровневую систему фильтрации**:

1. **UX Patterns** (8 групп): Communication, Content, Creation, Data, Media, Onboarding, Purchase, Social
2. **UI Elements** (7 групп): Containers, Controls, Feedback, Images, Inputs, Navigation, Popovers
3. **App Categories** (24 индустрии)

Это разделение поведенческих паттернов (UX) и визуальных компонентов (UI) — **ключевой инсайт для структуры Eagle**.

### Collect UI, Dribbble, Behance — crowd-sourced категоризация

**Collect UI** курирует Dribbble-работы в **167 категорий** по модели Daily UI Challenge: Sign Up (336), Dashboard (433), Animation (482), Illustration (1269). Это готовый список популярных UI-типов с количественной валидацией.

**Dribbble** использует **теги свободной формы**. Паттерны тегирования:

- Compound tags: `mobile-app-design`, `dashboard-ui`, `landing-page-design`
- Platform + Type: `ios-app`, `android-mobile`
- Style + Category: `dark-dashboard`, `minimal-ui`

**Behance** разделяет **Creative Fields** (официальные категории: UI/UX, Web Design, Interaction Design, App Design) и **project tags** (свободные ключевые слова). Moodboards позволяют создавать тематические коллекции.

---

## Сводная таблица категорий и тегов

### Screen Types (Типы экранов) — консолидированный список

|Категория|Примеры экранов|
|---|---|
|**Authentication**|Welcome, Splash, Login, Signup, Forgot Password, Verification, Permission Request, Account Setup|
|**Onboarding**|Walkthrough, Guided Tour, Feature Info, Coach Mark, Tutorial|
|**Home & Navigation**|Home, Dashboard, Browse & Discover, Search, Filter & Sort|
|**User Account**|Profile, My Account, Settings, Preferences, Edit Profile|
|**Commerce**|Shop, Product Detail, Cart, Checkout, Payment, Pricing, Subscription, Paywall, Order History|
|**Content & Media**|Feed, Timeline, Article, Chat, Messages, Calendar, Event Detail, Reviews|
|**Creation & Input**|Add/Create, Upload, Edit, Form, Quiz, Feedback|
|**Status & Feedback**|Empty State, Error, Loading, Progress, Confirmation, Success|
|**Social**|Activity Feed, Comments, Share, Invite Friends, Leaderboard|

### UI Elements (Компоненты) — унифицированный список

|Группа|Элементы|
|---|---|
|**Navigation**|Top Bar, Tab Bar, Bottom Bar, Side Nav, Breadcrumbs, Toolbar, Drawer|
|**Inputs**|Button, Text Field, Search Bar, Checkbox, Radio, Switch, Slider, Dropdown, Date Picker, Color Picker|
|**Containers**|Card, Tile, Grid, List, Table, Carousel, Accordion, Bottom Sheet, Modal, Dialog|
|**Feedback**|Toast, Banner, Badge, Tooltip, Progress Bar, Loading Indicator, Spinner|
|**Media**|Avatar, Thumbnail, Hero Image, Icon, Illustration, Video Player, Audio Player|
|**Data Display**|Chart, Statistics, Calendar, Map, Timeline|

### Industry Categories (Индустрии) — полный список

Finance, Health & Fitness, Shopping/E-commerce, Food & Drink, Travel, Social Networking, Productivity, Entertainment, Education, Music, News, Photo & Video, Business, Medical, Lifestyle, Sports, Navigation, Utilities, Games, CRM, Developer Tools, AI, Crypto & Web3, Real Estate

### Visual Styles (Стили)

Minimal, Dark Mode, Light Mode, Colorful, Gradient, Glassmorphism, Neumorphic, Brutalist, Editorial, Flat Design

---

## Рекомендуемая структура каталогов для Eagle

Оптимальная архитектура сочетает **папки для major categories** и **теги для attributes**. Глубина папок — максимум 3 уровня.

```
📁 UI Reference Library
│
├── 📁 Platform
│   ├── 📁 iOS
│   ├── 📁 Android
│   └── 📁 Web
│       ├── 📁 Apps (SaaS/Products)
│       ├── 📁 Landing Pages
│       └── 📁 Marketing Sites
│
├── 📁 Screen Types
│   ├── 📁 Authentication
│   │   └── Login, Signup, Password Reset, Verification
│   ├── 📁 Onboarding
│   │   └── Walkthrough, Tour, Permissions
│   ├── 📁 Core Screens
│   │   └── Home, Dashboard, Search, Browse
│   ├── 📁 Commerce
│   │   └── Product, Cart, Checkout, Pricing
│   ├── 📁 User Account
│   │   └── Profile, Settings, Preferences
│   ├── 📁 Content
│   │   └── Feed, Article, Chat, Calendar
│   └── 📁 States
│       └── Empty, Error, Loading, Success
│
├── 📁 UI Components
│   ├── 📁 Navigation
│   ├── 📁 Forms & Inputs
│   ├── 📁 Cards & Containers
│   ├── 📁 Modals & Overlays
│   └── 📁 Feedback & Status
│
├── 📁 User Flows
│   ├── 📁 Account Management
│   ├── 📁 Purchase & Checkout
│   ├── 📁 Content Creation
│   └── 📁 Search & Discovery
│
└── 📁 By Industry
    ├── 📁 Fintech
    ├── 📁 Health & Fitness
    ├── 📁 E-commerce
    ├── 📁 Social
    └── 📁 Productivity
```

### Система Tag Groups для Eagle

Используйте **цветовое кодирование** для визуального разделения типов тегов:

|Цвет|Tag Group|Примеры тегов|
|---|---|---|
|🔵 Blue|**Screen Type**|login, signup, dashboard, profile, settings, checkout, onboarding|
|🟢 Green|**Platform**|ios, android, web, desktop, tablet|
|🟣 Purple|**UI Element**|button, card, modal, nav-bar, form, carousel, toast|
|🟠 Orange|**Industry**|fintech, health, ecommerce, social, saas, travel|
|🔴 Red|**Style**|dark-mode, minimal, gradient, colorful, glassmorphism|
|🟡 Yellow|**Flow Type**|onboarding-flow, purchase-flow, search-flow, auth-flow|
|🩵 Aqua|**Source**|mobbin, dribbble, behance, awwwards, direct|
|🩷 Pink|**Status**|favorite, to-review, archived, inspiration|

### Smart Folders для автоматизации

Создайте Smart Folders для частых запросов:

- **"Best iOS Onboarding"** = Tag: ios + Tag: onboarding + Rating: 5 stars
- **"Dark Dashboards"** = Tag: dashboard + Tag: dark-mode
- **"Fintech Flows"** = Tag: fintech + Tag: *-flow
- **"Untagged Backlog"** = No tags + Added: Last 30 days
- **"Recent Favorites"** = Rating: 4-5 stars + Modified: Last 7 days

---

## JSON-конфигурация для Eagle AI Autotagger

Плагин AI Autotagger (v9.0.0) поддерживает кастомные presets. Рекомендуемый провайдер: **Google Gemini 2.5 Pro** (бесплатный API tier доступен на aistudio.google.com).

### Preset для UI/UX Screenshot Tagging

```json
{
  "name": "UI/UX Screenshot Tagger",
  "version": "1.0",
  "description": "Comprehensive tagging for UI/UX reference screenshots",
  "model": "gemini-2.5-pro-exp-03-25",
  "analysis_rules": {
    "screen_type": {
      "enabled": true,
      "prefix": "screen/",
      "categories": [
        "login", "signup", "forgot-password", "verification", "permission",
        "onboarding", "walkthrough", "tour", "splash",
        "home", "dashboard", "browse", "discover", "search", "filter",
        "profile", "account", "settings", "preferences", "edit-profile",
        "product-detail", "shop", "cart", "checkout", "payment", "pricing", "subscription", "paywall",
        "feed", "timeline", "article", "chat", "messages", "calendar", "event",
        "create", "add", "upload", "form", "quiz",
        "empty-state", "error", "loading", "success", "confirmation", "progress",
        "notifications", "activity-feed", "comments", "share", "invite"
      ]
    },
    "platform": {
      "enabled": true,
      "prefix": "platform/",
      "categories": ["ios", "android", "web", "desktop", "tablet"]
    },
    "ui_elements": {
      "enabled": true,
      "prefix": "element/",
      "categories": [
        "top-nav", "tab-bar", "bottom-nav", "side-nav", "breadcrumbs", "toolbar", "drawer",
        "button", "text-field", "search-bar", "checkbox", "radio", "switch", "slider", "dropdown", "date-picker",
        "card", "tile", "grid", "list", "table", "carousel", "accordion", "modal", "bottom-sheet", "dialog",
        "toast", "banner", "badge", "tooltip", "progress-bar", "loading-spinner",
        "avatar", "thumbnail", "hero-image", "icon", "illustration",
        "chart", "graph", "map", "calendar-widget"
      ]
    },
    "industry": {
      "enabled": true,
      "prefix": "industry/",
      "categories": [
        "fintech", "finance", "banking",
        "health", "fitness", "medical", "wellness",
        "ecommerce", "shopping", "marketplace",
        "social", "networking", "community",
        "productivity", "business", "saas",
        "entertainment", "media", "streaming",
        "education", "learning",
        "travel", "booking", "hospitality",
        "food", "delivery", "restaurant",
        "music", "audio", "podcast",
        "news", "magazine", "editorial",
        "gaming", "sports",
        "utilities", "tools",
        "ai", "crypto", "web3"
      ]
    },
    "visual_style": {
      "enabled": true,
      "prefix": "style/",
      "categories": [
        "dark-mode", "light-mode",
        "minimal", "clean", "simple",
        "colorful", "vibrant", "gradient",
        "glassmorphism", "neumorphic", "brutalist",
        "flat", "material", "skeuomorphic",
        "editorial", "magazine-style"
      ]
    },
    "flow_type": {
      "enabled": true,
      "prefix": "flow/",
      "categories": [
        "auth-flow", "onboarding-flow", "signup-flow",
        "purchase-flow", "checkout-flow", "payment-flow",
        "search-flow", "filter-flow", "browse-flow",
        "create-flow", "edit-flow", "upload-flow",
        "social-flow", "share-flow", "invite-flow",
        "settings-flow", "profile-flow"
      ]
    }
  },
  "output_settings": {
    "max_tags": 15,
    "tag_separator": ", ",
    "include_confidence": false,
    "generate_description": true,
    "description_max_length": 200
  }
}
```

### Prompt Template для AI Autotagger

Используйте этот промпт в настройках плагина:

```
Analyze this UI/UX screenshot and identify:

1. SCREEN TYPE: What type of screen is this? (login, dashboard, checkout, profile, settings, onboarding, etc.)

2. PLATFORM: Which platform? (ios, android, web, desktop)

3. UI ELEMENTS present: List all visible UI components (buttons, cards, modals, navigation bars, forms, etc.)

4. INDUSTRY/DOMAIN: What industry does this app belong to? (fintech, health, ecommerce, social, productivity, etc.)

5. VISUAL STYLE: Describe the design style (dark-mode, minimal, colorful, gradient, glassmorphism, etc.)

6. FLOW TYPE (if applicable): What user journey stage is this? (onboarding-flow, purchase-flow, auth-flow, etc.)

Return tags in the format: prefix/tag-name
Example: screen/login, platform/ios, element/button, element/text-field, industry/fintech, style/dark-mode

Be specific and comprehensive. Maximum 15 tags.
```

---

## Рекомендации по внедрению

Для эффективной работы с библиотекой на **10,000+ скриншотов** следуйте этим принципам:

**Первый этап — структура папок**. Создайте базовую иерархию Platform → Screen Types. Не создавайте слишком глубокую вложенность — 3 уровня максимум. Используйте Auto-Tagging для папок: при добавлении файла в папку "iOS" автоматически присваивается тег `platform/ios`.

**Второй этап — Tag Groups**. Настройте 8 цветовых групп тегов. Перенесите базовые теги из JSON-конфига в Eagle. Используйте slash-naming (`screen/login`) для имитации иерархии в плоской системе тегов Eagle.

**Третий этап — AI Autotagger**. Подключите Gemini 2.5 Pro API. Загрузите preset и промпт. Запустите batch-обработку для существующей коллекции. Проверяйте и корректируйте результаты первых 50-100 скриншотов для калибровки.

**Четвёртый этап — Smart Folders**. Создайте 10-15 Smart Folders для типичных поисковых запросов. Комбинируйте теги: `platform/ios` + `screen/onboarding` + `style/dark-mode`.

**Масштабирование**. При достижении **50,000+ элементов** рассмотрите разделение на несколько Eagle-библиотек по платформам или индустриям. Экспортируйте Tag Groups между библиотеками для консистентности.

Эта структура обеспечивает баланс между **строгой организацией** (папки) и **гибким поиском** (теги), поддерживает автоматическую категоризацию через AI и масштабируется до сотен тысяч референсов.