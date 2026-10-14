# Simple Inventory Management System

A beginner-friendly inventory CRUD app built with Vue 3, Vite, Tailwind CSS, and Supabase.

## 1. Create the project

The project files are already in this folder. To create the same starter project from a terminal:

```powershell
npm create vite@latest simple-inventory-management-system -- --template vue
cd simple-inventory-management-system
```

For this repository, run the remaining commands from the repository folder instead of creating a second project.

## 2. Install packages

From the project folder, install the application and styling dependencies:

```powershell
npm install
npm install @supabase/supabase-js
npm install -D tailwindcss @tailwindcss/vite
```

The supplied `package.json` and Vite configuration already contain these settings.

## 3. Create the Supabase database

In the Supabase dashboard, open **SQL Editor**, create a query, paste the contents of [`supabase/schema.sql`](./supabase/schema.sql), and run it. This creates `public.inventory_items`, enables Row Level Security, and adds the demo policies.

### RLS warning

The included policies make the unauthenticated classroom demo work: anyone who can reach the app can read, add, edit, and delete every inventory record. The Supabase URL and publishable key are intentionally public client configuration, not secrets. RLS does not make this policy safe for private or production data.

Use a controlled development Supabase project and non-sensitive sample inventory only. For any real deployment, remove the four `Classroom demo...` policies and use Supabase Auth with policies that restrict rows to the signed-in user (for example, add a `user_id` column and require `auth.uid() = user_id`). Do not put a service-role or secret key in this app.

## 4. Configure Supabase

1. In Supabase, open **Project Settings → API**.
2. Copy the Project URL and the publishable key (`sb_publishable_...`, or the legacy `anon` key if that is what the project provides). Never use the service-role/secret key.
3. Copy `.env.example` to a file named `.env` in the project root.
4. Replace the placeholders:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=your_supabase_publishable_key
```

Vite exposes variables prefixed with `VITE_` to browser code. Do not put secrets in them. Restart the dev server after changing `.env`.

## 5. Project files

```text
.
├── index.html
├── public/
│   └── jahryl-profile.jpe
├── src/
│   ├── components/
│   │   ├── HeroSection.vue
│   │   ├── InventoryForm.vue
│   │   └── InventorySection.vue
│   ├── lib/
│   │   └── supabase.js
│   ├── App.vue
│   ├── main.js
│   └── style.css
├── supabase/
│   └── schema.sql
├── .env.example
├── package.json
└── vite.config.js
```

The profile banner image is `public/jahryl-profile.jpe`. Change the displayed developer name in the `developerName` constant near the top of `src/components/HeroSection.vue`.

## 6. Run locally

```powershell
npm run dev
```

Open the local URL printed by Vite (usually `http://localhost:5173`). Build the production bundle with `npm run build`.

## 7. CRUD test checklist

- **Create:** Add an item with a name, category, quantity, and unit price. Confirm the success message and new row appear.
- **Read:** Reload the page. Confirm the saved record, Philippine peso unit price, and quantity × unit price total display.
- **Search:** Search by part of an item name and category; clear the search to restore the full table.
- **Update:** Edit an item, change its details, and save. Confirm the refreshed row reflects the change.
- **Delete:** Delete an item, cancel once to verify it remains, then confirm deletion and verify the row disappears.
- **Validation/errors:** Try submitting blank required fields. Temporarily remove the Supabase environment values and verify the configuration message appears.
