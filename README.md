# IEHP ERA Financial Dashboard
Goodnite Sleep Solution LLC — Internal Finance Tool

## What this does
Upload IEHP Remittance Advice PDFs → dashboard automatically shows:
- Provider totals (billed, allowed, net paid, withheld, denied)
- Full patient list with paid/denied status
- Denied claims flagged with action items
- Filter by LOB, status, patient name
- Export to Excel
- All historical ERAs saved — login any time to view past uploads

---

## Setup (one time, ~15 minutes)

### 1. Supabase — database + auth

1. Go to https://supabase.com and create a new project (free tier is fine)
2. In your project: go to **SQL Editor → New Query**
3. Paste the entire contents of `supabase_schema.sql` and click **Run**
4. Go to **Project Settings → API**
5. Copy your **Project URL** and **anon public** key

### 2. Create your login user

1. In Supabase: go to **Authentication → Users → Add User**
2. Enter your boss's email and a password
3. Confirm the user

### 3. Configure environment

```bash
cp .env.example .env
```

Open `.env` and fill in:
```
VITE_SUPABASE_URL=https://xxxx.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGc...
```

### 4. Run locally

```bash
npm install
npm run dev
```

Open http://localhost:5173 — log in with the credentials you created in step 2.

---

## Deploy to Netlify (free)

### Option A — Netlify CLI
```bash
npm install -g netlify-cli
npm run build
netlify deploy --prod --dir=dist
```

### Option B — GitHub + Netlify UI
1. Push this folder to a GitHub repo
2. Go to https://netlify.com → New site → Import from GitHub
3. Build command: `npm run build`
4. Publish directory: `dist`
5. Add environment variables in Netlify: Site Settings → Environment Variables
   - `VITE_SUPABASE_URL`
   - `VITE_SUPABASE_ANON_KEY`
6. Deploy

Your boss gets a URL like `https://goodnite-era.netlify.app` — bookmark it, done.

---

## How to use

1. Log in at your Netlify URL
2. Upload an IEHP ERA Remittance Advice PDF (downloaded from IEHP portal)
3. Dashboard populates automatically
4. Denied patients appear at the top in red with action items
5. Use filters to search by name, LOB, or status
6. Click any patient row to expand claim line details
7. Export to Excel any time
8. Upload next month's ERA — all history is saved

---

## File structure

```
src/
  lib/
    supabase.js      — Supabase client
    eraParser.js     — PDF text extraction + ERA data parser
  hooks/
    useAuth.jsx      — Auth context
  components/
    Navbar.jsx       — Top nav with sign out
    UploadZone.jsx   — Drag & drop PDF upload
    SummaryPanel.jsx — Metric cards + charts
    DeniedPanel.jsx  — Denied claims with action items
    PatientTable.jsx — Full patient list with filters + expand
    ERAHistory.jsx   — Sidebar list of past ERAs
    UI.jsx           — Shared components (Badge, MetricCard, etc.)
  pages/
    Login.jsx        — Login screen
    Dashboard.jsx    — Main dashboard page
```
