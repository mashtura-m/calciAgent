# ReveChat Mobile App - Product Requirements Document (PRD)

**Version:** 1.0
**Date:** November 5, 2026
**Author:** Product Team
**Audience:** QA Team

---

## 1. Product Overview

**Product Name:** ReveChat Agent Mobile App
**Purpose:** AI-powered customer support livechat application for fashion e-commerce businesses
**Target Market:** Bangladesh fashion retail (Bangla + English bilingual)
**Platform:** Mobile-first (390x844 viewport), single-page web application

### 1.1 User Roles

| Role | Access Level | Description |
|------|-------------|-------------|
| **Admin** | Full | Dashboard analytics, agent management, routing policies, integrations, all inbox conversations |
| **Agent** | Limited | Assigned inbox conversations, personal settings, break management |

### 1.2 AI Agent

- **AI Sara** — default AI handler for incoming conversations
- Confidence scoring (0-100%) on each response
- Auto-drafts with approve/edit/reject actions
- Automatic escalation to human when confidence is low or customer requests it

---

## 2. Screens & Features

### 2.1 Login Screen

**Fields:**
- Email input (required)
- Password input (required)
- Role toggle: Admin / Agent

**Use Cases:**

| ID | Use Case | Steps | Expected Result |
|----|----------|-------|-----------------|
| UC-LOGIN-01 | Successful admin login | Enter valid email, password, select Admin, tap Sign In | Navigate to Dashboard |
| UC-LOGIN-02 | Successful agent login | Enter valid email, password, select Agent, tap Sign In | Navigate to Inbox |
| UC-LOGIN-03 | Empty field validation | Leave email or password blank, tap Sign In | Show error state |
| UC-LOGIN-04 | Role toggle | Tap Admin/Agent toggle | Toggle switches between roles |

---

### 2.2 Dashboard (Admin Only)

**Components:**
- Header with greeting, date, online status badge
- Stats cards: Total Conversations, AI Handled %, Human Handled, Queue Waiting
- Channel breakdown bar (WhatsApp, Messenger, Instagram, LiveChat)
- Category breakdown bar (Shipping, Refund, Product, Payment)
- Agent performance cards with active/resolved/rating metrics

**Use Cases:**

| ID | Use Case | Steps | Expected Result |
|----|----------|-------|-----------------|
| UC-DASH-01 | View dashboard stats | Login as Admin, land on Dashboard | All stat cards display correct counts |
| UC-DASH-02 | Channel breakdown | View channel bar | Shows distribution across WhatsApp, Messenger, IG, LiveChat |
| UC-DASH-03 | Agent cards display | Scroll to agent section | Shows each agent with name, status, active count, resolved count, rating |
| UC-DASH-04 | Agent actions | Tap action buttons on agent card | Can reassign chats or put agent on break |
| UC-DASH-05 | Dashboard refresh | Navigate away and back | Stats reflect latest data |

---

### 2.3 Inbox

**Components:**
- Filter chips: All, AI, Human, Bot, Review (pending), Snoozed — each with count badge
- Sort/filter bar: Sort by FIFO/Unread/Newest/SLA urgency + Channel filter
- Search with channel and date filters
- Inbox Filter panel (bottom sheet): Visitor ID, Channel, Sub Channel, Sentiment, Reply Status, Customer Label
- Conversation cards: Avatar, name, channel icon, time, handler tag, preview, unread badge, SLA/sentiment tags
- Skeleton loading with "You're all caught up" completion

**Use Cases:**

| ID | Use Case | Steps | Expected Result |
|----|----------|-------|-----------------|
| UC-INB-01 | View all conversations | Open Inbox tab | Shows all non-snoozed conversations with counts |
| UC-INB-02 | Filter by handler | Tap AI/Human/Bot/Review chip | List filters to matching handler type |
| UC-INB-03 | Filter snoozed | Tap Snoozed chip | Shows only snoozed conversations |
| UC-INB-04 | Sort by FIFO | Open sort bar, select Queue (FIFO) | Conversations sorted by queue position |
| UC-INB-05 | Sort by unread | Select Unread first | Conversations with most unread on top |
| UC-INB-06 | Sort by newest | Select Newest first | Most recent conversations on top |
| UC-INB-07 | Sort by SLA | Select SLA urgency | Breach > Warning > OK ordering |
| UC-INB-08 | Channel filter | Select specific channel in sort bar | Only that channel's conversations shown |
| UC-INB-09 | Search conversations | Tap search icon, type query | Filters by name and preview text |
| UC-INB-10 | Search with channel filter | While searching, select a channel chip | Results filtered by both text and channel |
| UC-INB-11 | Search with date filter | While searching, select date range | Results filtered by date (Today, 7d, 30d) |
| UC-INB-12 | Open inbox filter | Tap filter button (hamburger icon) | Bottom sheet opens with filter fields |
| UC-INB-13 | Filter by visitor ID | Enter visitor ID in filter | Matches against conversation ID and name |
| UC-INB-14 | Filter by channel | Select channel in filter dropdown | Shows only that channel |
| UC-INB-15 | Filter by sentiment | Select sentiment in filter | Filters by Happy/Neutral/Frustrated/Angry |
| UC-INB-16 | Filter by reply status | Select Replied/Unreplied/Pending | Filters by unread count and handover status |
| UC-INB-17 | Filter by customer label | Select label in filter | Matches customer label field |
| UC-INB-18 | Apply multiple filters | Set multiple filter criteria, tap Apply | All filters applied simultaneously |
| UC-INB-19 | Reset filters | Tap Reset in filter panel | All filters cleared, full list restored |
| UC-INB-20 | Active filter badge | Apply filters and close panel | Filter button shows count of active filters |
| UC-INB-21 | Agent role restriction | Login as Agent | Only sees assigned conversations + AI/Bot handled |
| UC-INB-22 | Open conversation | Tap conversation card | Navigates to chat view |
| UC-INB-23 | Skeleton loading | View inbox | Skeleton cards appear, then "You're all caught up" after 800ms |

---

### 2.4 Chat View

**Components:**
- Header: Avatar, name, channel status, AI toggle, info/more/snooze buttons
- Message types: Text, buttons, carousel (product cards), order summary, system, whisper
- AI handling bar (when AI on) with "Turn OFF" button
- Bot handling bar with "Take Over" button
- Human review zone with reason and "Take Over" button
- AI draft zone with confidence, approve/edit/reject
- Quick reply chips (when human handling)
- Input bar: Attach button, text input, send button
- Whisper mode (Admin only): Private note to agent
- Delivery ticks: Sent (single), Delivered (double gray), Read (double blue)

**Use Cases:**

| ID | Use Case | Steps | Expected Result |
|----|----------|-------|-----------------|
| UC-CHAT-01 | Open chat | Tap conversation in inbox | Shows chat header, messages, input area |
| UC-CHAT-02 | Send text message | Type message, tap send or press Enter | Message appears as human bubble with timestamp |
| UC-CHAT-03 | Toggle AI on | Tap AI toggle (off state) | AI Sara takes over, AI handling bar shown |
| UC-CHAT-04 | Toggle AI off | Tap AI toggle (on state) | Human takes over, input bar shown |
| UC-CHAT-05 | Human takeover | Tap "Take Over" in review zone | Agent assigned, system message logged |
| UC-CHAT-06 | Bot takeover | Tap "Take Over" on bot handling bar | Agent assigned, bot removed from handling |
| UC-CHAT-07 | Send AI draft | Tap send on AI draft | Draft sent as AI message with confidence |
| UC-CHAT-08 | Quick reply | Tap a quick reply chip | Message sent immediately |
| UC-CHAT-09 | Whisper mode (Admin) | Tap whisper icon | Input switches to whisper mode, sends private note |
| UC-CHAT-10 | View message types | Scroll through conversation | Text, button, carousel, order messages render correctly |
| UC-CHAT-11 | Delivery status | Send message | Shows sent tick, then delivered, then read |
| UC-CHAT-12 | Snooze chat | Tap snooze button, select duration | Chat snoozed, system message logged, snooze badge shown |
| UC-CHAT-13 | Resume snoozed chat | Tap snooze on snoozed chat | Chat resumed, system message logged |
| UC-CHAT-14 | Attach menu | Tap "+" button | Bottom sheet: Canned Response, Image, File |
| UC-CHAT-15 | Canned response | Open attach > Canned Response | Pick from list, message sent |
| UC-CHAT-16 | Search canned responses | Type in canned search | Filters by title, text, category |
| UC-CHAT-17 | Customer info panel | Tap info button | Slide-in panel with customer details, sentiment, tags, notes, timeline |
| UC-CHAT-18 | Edit customer label | In info panel, select label | Label applied and displayed |
| UC-CHAT-19 | Add customer tag | In info panel, select tag | Tag added to customer |
| UC-CHAT-20 | Close chat | More menu > Close Chat | Optional remarks, chat marked closed |
| UC-CHAT-21 | Transfer chat | More menu > Transfer > Select agent | Chat transferred, system message logged |
| UC-CHAT-22 | Assign chat | More menu > Assign > Select agent | Chat assigned to selected agent |
| UC-CHAT-23 | Back to inbox | Tap back arrow | Returns to inbox, unread counts updated |

---

### 2.5 Ticketing System

**Components:**
- Ticket list with filter chips: All, Open, Pending, Closed (with counts)
- Search by subject and customer name
- Create Ticket form (full-screen overlay)
- Ticket Detail view with tabs: Overview, Profile, Notes

#### Create Ticket Form Fields:
- Select Form (General Inquiry, Returns, Payment Issue, Bug Report)
- Recipient Name (required)
- Recipient Email (required)
- Subject (required, max 250 chars with counter)
- Description (required)
- Ticket Assignee
- Due Date
- Ticket Priority (Low, Medium, High)
- Ticket Tags

**Use Cases:**

| ID | Use Case | Steps | Expected Result |
|----|----------|-------|-----------------|
| UC-TK-01 | View ticket list | Navigate to Tickets tab | Shows all tickets with status/priority badges |
| UC-TK-02 | Filter by status | Tap Open/Pending/Closed chip | Filtered list with correct counts |
| UC-TK-03 | Search tickets | Type in search bar | Filters by subject and customer name |
| UC-TK-04 | Create ticket | Tap "+" button | Full-screen create form opens |
| UC-TK-05 | Required fields validation | Submit with empty required fields | Error lists missing fields |
| UC-TK-06 | Subject char counter | Type in subject field | Shows "N / 250" counter |
| UC-TK-07 | Submit ticket | Fill all required fields, tap Create | Ticket added to list, overlay closes |
| UC-TK-08 | Discard ticket | Tap Discard on create form | Form closes without saving |
| UC-TK-09 | Open ticket detail | Tap ticket in list | Detail overlay with Overview tab |
| UC-TK-10 | Cycle ticket status | Tap status badge in detail | Cycles: Open > Pending > Closed |
| UC-TK-11 | Cycle priority | Tap priority in detail | Cycles: Low > Medium > High |
| UC-TK-12 | Collapsible sections | Tap section headers (Info, Assignee, Tag) | Sections expand/collapse with chevron |
| UC-TK-13 | Profile tab | Tap Profile tab | Shows customer contact info if found |
| UC-TK-14 | Notes tab | Tap Notes tab | Shows notes with add note input |
| UC-TK-15 | Add note | Type note, tap Add | Note saved with author and timestamp |
| UC-TK-16 | AI Following badge | View ticket with AI flag | Shows "AI Following" indicator |

---

### 2.6 Contacts

**Components:**
- View toggle: Segments / All Contacts
- Filter panel: Channel, Label, Last Contacted
- Segment folders: VIP Customers, Regular Buyers, New Leads, At Risk
- Contact cards: Avatar, name, channel, phone, chat count, last active, segment/label/tag badges

**Use Cases:**

| ID | Use Case | Steps | Expected Result |
|----|----------|-------|-----------------|
| UC-CT-01 | Segments view | Open Contacts tab | Shows collapsible segment folders |
| UC-CT-02 | Expand segment | Tap segment header | Shows contacts in that segment |
| UC-CT-03 | All contacts view | Tap "All Contacts" toggle | Shows flat list of all contacts |
| UC-CT-04 | Filter by channel | Open filter panel, select channel | Shows only contacts from that channel |
| UC-CT-05 | Filter by label | Select label filter | Filters by Buyer/Lead/Complainant |
| UC-CT-06 | Search contacts | Type in search bar | Filters by name and phone number |
| UC-CT-07 | Contact tags display | View contact card | Shows segment, label, and custom tags |

---

### 2.7 Settings

**Components:**
- Collapsible sections: Profile, Integrations (Admin), Routing Policy (Admin), Preferences
- Profile card with online status and break management

#### Integrations (Admin Only):

**META Business:**
- Channel list: WhatsApp (WA), Messenger (M), Instagram (IG) with connection status
- One-click Facebook login to connect all three

**Reve Services:**
- API Key input (required to enable services)
- ReveSMS, Phone (Click-to-call), KloudTalk (Cloud call center)
- Each toggleable Active/Enable

**Payment Gateway:**
- Payment method tiles: bKash, Nagad, SSLCommerz, Card
- Each tile toggleable (selectable/deselectable) with checkmark indicator
- Enable/Disconnect master toggle

#### Routing Policy (Admin Only):
- Mode: Round Robin / Least Active / Manual
- Max concurrent chats
- Auto-assign toggle
- Business hours toggle
- Auto-close idle (hours)
- SLA Response time (minutes)
- SLA Resolution time (hours)

#### Preferences:
- Available toggle
- Notifications toggle
- Sounds toggle
- Canned Responses management (Admin) — add/delete/search
- Language selector
- Logout button

**Use Cases:**

| ID | Use Case | Steps | Expected Result |
|----|----------|-------|-----------------|
| UC-SET-01 | View profile | Open Settings | Shows name, role, online status |
| UC-SET-02 | Go on break (Agent) | Tap "Go on Break" | Break reason dialog, status changes |
| UC-SET-03 | Come online | Tap "Come Online" | Status changes to online |
| UC-SET-04 | Connect META | Tap "Connect with Facebook Account" | All 3 channels show Connected |
| UC-SET-05 | META channel status | View META section | Shows per-channel connection indicators |
| UC-SET-06 | Save Reve API key | Enter key, tap Save | Key saved, services unlocked |
| UC-SET-07 | Enable Reve service | Tap Enable on a service | Status changes to Active |
| UC-SET-08 | Toggle payment method | Tap bKash/Nagad/SSLCommerz/Card tile | Tile toggles selected/deselected with border and checkmark |
| UC-SET-09 | Enable payments | Tap Enable Payments | Payment gateway activated |
| UC-SET-10 | Change routing mode | Select mode in dropdown | Routing policy updated |
| UC-SET-11 | Adjust SLA times | Change SLA response/resolution inputs | Values updated |
| UC-SET-12 | Manage canned responses | Open Canned Responses | List with add/delete actions |
| UC-SET-13 | Add canned response | Tap "+ Add New" | New response template added |
| UC-SET-14 | Delete canned response | Tap delete icon on response | Response removed from list |
| UC-SET-15 | Toggle notifications | Tap notification toggles | Toggle on/off states |
| UC-SET-16 | Logout | Tap Log Out | Returns to login screen |

---

### 2.8 Bottom Navigation

| Tab | Icon | Visible To | Navigation Target |
|-----|------|-----------|-------------------|
| Dashboard | chart icon | Admin only | Dashboard screen |
| Inbox | chat icon + unread badge | Both | Inbox screen |
| Tickets | ticket icon | Both | Tickets screen |
| Contacts | people icon | Both | Contacts screen |
| Settings | gear icon | Both | Settings screen |

**Use Cases:**

| ID | Use Case | Steps | Expected Result |
|----|----------|-------|-----------------|
| UC-NAV-01 | Tab navigation | Tap each tab | Correct screen renders |
| UC-NAV-02 | Active state | Tap a tab | Active tab highlighted, others not |
| UC-NAV-03 | Unread badge | Have unread messages | Badge shows count on Inbox tab |
| UC-NAV-04 | Agent no dashboard | Login as Agent | Dashboard tab hidden |

---

## 3. Cross-Cutting Concerns

### 3.1 Bottom Sheet Pattern
- All modals use bottom sheet (slide-up overlay)
- Max height 85% of screen
- Dismissible by tapping outside
- Consistent header with handle bar

### 3.2 SLA System
- Visual SLA tags: Breach (red), Warning (yellow), OK (none)
- SLA breach alerts in inbox and chat

### 3.3 Sentiment Tracking
- Per-conversation sentiment: Happy, Neutral, Frustrated, Angry
- Sentiment bar with icon, score fill, and label
- Sentiment tags on conversation cards

### 3.4 Role-Based Access

| Feature | Admin | Agent |
|---------|-------|-------|
| Dashboard | Yes | No |
| All inbox conversations | Yes | Assigned only |
| Whisper to agent | Yes | No |
| Integrations settings | Yes | No |
| Routing policy | Yes | No |
| Canned response management | Yes | No |
| Go on break | No | Yes |
| Customer tags in inbox | Yes | No |

---

## 4. Test Environment

- **Viewport:** 390 x 844 (iPhone frame)
- **Tech stack:** Single HTML file, vanilla JS, CSS custom properties
- **Data:** In-memory mock data (resets on refresh)
- **Channels:** WhatsApp, Messenger, Instagram, LiveChat
- **Sample data:** 8+ conversations, 6+ tickets, 12+ contacts

---

## 5. Known Limitations (Prototype)

1. No persistent data storage — all state resets on page refresh
2. Image/File attachments in chat show UI but don't upload actual files
3. Agent break timer is simulated
4. SLA timers are static mock data
5. Search date filter is UI-only (no actual date filtering on mock data)
6. Canned response editing is add/delete only (no inline edit)
7. Ticket assignee selection is placeholder (shows "Add Assignee" but no picker)

---

## 6. QA Checklist Summary

- [ ] Login flow works for both Admin and Agent roles
- [ ] Dashboard displays all stat cards and agent info (Admin)
- [ ] Inbox filtering by handler type, channel, sort order all work
- [ ] Inbox filter panel (Visitor ID, Channel, Sub Channel, Sentiment, Reply Status, Customer Label) works
- [ ] Active filter count badge appears on filter button
- [ ] Chat messages render all types (text, button, carousel, order, system, whisper)
- [ ] AI toggle on/off works correctly
- [ ] Human takeover flow works from review zone
- [ ] Bot takeover flow works
- [ ] Snooze/resume works with duration options
- [ ] Transfer and assign chat flows work
- [ ] Close chat with optional remarks works
- [ ] Canned responses can be searched, selected, and sent
- [ ] Customer info panel shows all details, labels, tags, notes
- [ ] Ticket CRUD: create, view list, filter, detail view all work
- [ ] Ticket detail tabs (Overview, Profile, Notes) all render
- [ ] Status and priority cycling works in ticket detail
- [ ] Contacts segments and all-contacts views work
- [ ] Contact filter panel filters correctly
- [ ] Settings sections collapse/expand
- [ ] META integration connect flow works
- [ ] Reve API key save/service enable flow works
- [ ] Payment method tiles toggle selection with visual feedback
- [ ] Routing policy inputs work
- [ ] Canned response management (add/delete) works
- [ ] Logout returns to login
- [ ] Bottom navigation works across all tabs
- [ ] Unread badge updates correctly
- [ ] Role-based access restrictions enforced
