<script setup>
import { computed, onMounted, ref } from 'vue'
import InventoryForm from './InventoryForm.vue'
import { isSupabaseConfigured, supabase } from '../lib/supabase'

const items = ref([])
const searchQuery = ref('')
const loading = ref(true)
const saving = ref(false)
const deletingId = ref(null)
const formOpen = ref(false)
const editingItem = ref(null)
const errorMessage = ref('')
const loadErrorMessage = ref('')
const successMessage = ref('')

const filteredItems = computed(() => {
  const query = searchQuery.value.trim().toLocaleLowerCase()
  if (!query) return items.value

  return items.value.filter((item) =>
    [item.item_name, item.category].some((value) =>
      value.toLocaleLowerCase().includes(query),
    ),
  )
})

const pesoFormatter = new Intl.NumberFormat('en-PH', {
  style: 'currency',
  currency: 'PHP',
  minimumFractionDigits: 2,
})

function formatPeso(value) {
  return pesoFormatter.format(Number(value) || 0)
}

function formatId(id) {
  return id.slice(0, 8).toUpperCase()
}

function clearMessages() {
  errorMessage.value = ''
  successMessage.value = ''
}

async function loadItems() {
  loading.value = true
  loadErrorMessage.value = ''

  if (!isSupabaseConfigured) {
    loadErrorMessage.value =
      'Supabase is not configured. Copy .env.example to .env, add your project URL and publishable key, then restart the development server.'
    loading.value = false
    return false
  }

  try {
    const { data, error } = await supabase
      .from('inventory_items')
      .select('id, item_name, description, category, quantity, unit_price, created_at')
      .order('created_at', { ascending: false })

    if (error) {
      loadErrorMessage.value = `Could not load inventory: ${error.message}`
      items.value = []
      loading.value = false
      return false
    }

    items.value = data ?? []
    loading.value = false
    return true
  } catch (error) {
    loadErrorMessage.value = `Could not load inventory: ${error instanceof Error ? error.message : String(error)}`
    items.value = []
    loading.value = false
    return false
  }
}

function openAddForm() {
  clearMessages()
  editingItem.value = null
  formOpen.value = true
}

function openEditForm(item) {
  clearMessages()
  editingItem.value = { ...item }
  formOpen.value = true
}

function closeForm() {
  if (saving.value) return
  formOpen.value = false
  editingItem.value = null
}

async function saveItem(formData) {
  clearMessages()
  if (!isSupabaseConfigured) {
    errorMessage.value = 'Add your Supabase project URL and publishable key to .env before saving inventory.'
    return
  }

  saving.value = true

  const isEditing = Boolean(editingItem.value)
  try {
    const result = isEditing
      ? await supabase
          .from('inventory_items')
          .update(formData)
          .eq('id', editingItem.value.id)
          .select()
      : await supabase.from('inventory_items').insert(formData).select()

    if (result.error) {
      errorMessage.value = `Could not ${isEditing ? 'update' : 'add'} item: ${result.error.message}`
      saving.value = false
      return
    }

    formOpen.value = false
    editingItem.value = null
    successMessage.value = isEditing ? 'Inventory item updated successfully.' : 'Inventory item added successfully.'
    saving.value = false
    await loadItems()
  } catch (error) {
    errorMessage.value = `Could not ${isEditing ? 'update' : 'add'} item: ${error instanceof Error ? error.message : String(error)}`
    saving.value = false
  }
}

async function deleteItem(item) {
  const confirmed = window.confirm(`Delete "${item.item_name}" from your inventory? This action cannot be undone.`)
  if (!confirmed) return

  clearMessages()
  deletingId.value = item.id

  try {
    const { error } = await supabase
      .from('inventory_items')
      .delete()
      .eq('id', item.id)

    if (error) {
      errorMessage.value = `Could not delete item: ${error.message}`
      deletingId.value = null
      return
    }

    successMessage.value = `"${item.item_name}" was deleted.`
    deletingId.value = null
    await loadItems()
  } catch (error) {
    errorMessage.value = `Could not delete item: ${error instanceof Error ? error.message : String(error)}`
    deletingId.value = null
  }

}

onMounted(loadItems)
</script>

<template>
  <section id="inventory" class="scroll-mt-6 px-5 pb-20 sm:px-8 sm:pb-28">
    <div class="mx-auto max-w-7xl">
      <div class="mb-7 flex flex-col gap-5 sm:mb-9 sm:flex-row sm:items-end sm:justify-between">
        <div>
          <p class="eyebrow">Your records</p>
          <h2 class="mt-2 text-3xl font-semibold tracking-tight text-ink sm:text-4xl">
            Inventory Management
          </h2>
          <p class="mt-2 text-sm leading-6 text-muted">
            Keep item details and stock values up to date.
          </p>
        </div>
        <button type="button" class="button-primary self-start sm:self-auto" @click="openAddForm">
          <svg viewBox="0 0 20 20" fill="none" class="h-4 w-4" aria-hidden="true">
            <path d="M10 4v12M4 10h12" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" />
          </svg>
          Add Item
        </button>
      </div>

      <div class="overflow-hidden rounded-2xl border border-line bg-white shadow-card">
        <div class="flex flex-col gap-4 border-b border-line px-5 py-5 sm:flex-row sm:items-center sm:justify-between sm:px-6">
          <div>
            <h3 class="font-semibold text-ink">All inventory items</h3>
            <p class="mt-1 text-sm text-muted">
              {{ items.length }} {{ items.length === 1 ? 'record' : 'records' }}
            </p>
          </div>
          <label class="relative block w-full sm:max-w-xs">
            <span class="sr-only">Search by item name or category</span>
            <svg
              viewBox="0 0 20 20"
              fill="none"
              class="pointer-events-none absolute left-3.5 top-1/2 h-4 w-4 -translate-y-1/2 text-muted"
              aria-hidden="true"
            >
              <circle cx="8.8" cy="8.8" r="5.8" stroke="currentColor" stroke-width="1.5" />
              <path d="m13.2 13.2 4 4" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
            </svg>
            <input
              v-model="searchQuery"
              class="field-input !py-2.5 !pl-10"
              type="search"
              placeholder="Search name or category"
            />
          </label>
        </div>

        <div v-if="successMessage" class="notice-success mx-5 mt-5 sm:mx-6" role="status">
          {{ successMessage }}
        </div>
        <div v-if="loadErrorMessage" class="notice-error mx-5 mt-5 sm:mx-6" role="alert">
          {{ loadErrorMessage }}
        </div>
        <div v-if="errorMessage" class="notice-error mx-5 mt-5 sm:mx-6" role="alert">
          {{ errorMessage }}
        </div>

        <div v-if="loading" class="grid min-h-64 place-items-center px-6 py-12">
          <div class="flex items-center gap-3 text-sm font-medium text-muted" role="status">
            <span class="loading-spinner" aria-hidden="true"></span>
            Loading inventory…
          </div>
        </div>

        <div v-else-if="loadErrorMessage && items.length === 0" class="px-6 py-16 text-center">
          <h3 class="font-semibold text-ink">Inventory isn’t available</h3>
          <p class="mt-1 text-sm text-muted">Resolve the message above and reload the page.</p>
        </div>

        <div v-else-if="items.length === 0" class="px-6 py-16 text-center">
          <div class="mx-auto grid h-12 w-12 place-items-center rounded-xl bg-paper text-forest" aria-hidden="true">
            <svg viewBox="0 0 24 24" fill="none" class="h-6 w-6">
              <path d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5v-9Z" stroke="currentColor" stroke-width="1.5" stroke-linejoin="round" />
              <path d="M8 10h8" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" />
            </svg>
          </div>
          <h3 class="mt-4 font-semibold text-ink">Your inventory is empty</h3>
          <p class="mt-1 text-sm text-muted">Add your first item to get started.</p>
          <button type="button" class="button-secondary mt-5" @click="openAddForm">Add your first item</button>
        </div>

        <div v-else-if="filteredItems.length === 0" class="px-6 py-16 text-center">
          <h3 class="font-semibold text-ink">No matching items</h3>
          <p class="mt-1 text-sm text-muted">Try another item name or category.</p>
        </div>

        <div v-else class="overflow-x-auto">
          <table class="w-full min-w-[1050px] text-left text-sm">
            <thead class="bg-paper/70 text-xs font-semibold uppercase tracking-wide text-muted">
              <tr>
                <th scope="col" class="px-5 py-3.5 sm:px-6">Item ID</th>
                <th scope="col" class="px-4 py-3.5">Item name</th>
                <th scope="col" class="px-4 py-3.5">Description</th>
                <th scope="col" class="px-4 py-3.5">Category</th>
                <th scope="col" class="px-4 py-3.5 text-right">Quantity</th>
                <th scope="col" class="px-4 py-3.5 text-right">Unit price</th>
                <th scope="col" class="px-4 py-3.5 text-right">Total value</th>
                <th scope="col" class="px-5 py-3.5 text-right sm:px-6">Actions</th>
              </tr>
            </thead>
            <tbody class="divide-y divide-line">
              <tr v-for="item in filteredItems" :key="item.id" class="transition-colors hover:bg-paper/50">
                <td class="whitespace-nowrap px-5 py-4 font-mono text-xs text-muted sm:px-6" :title="item.id">
                  {{ formatId(item.id) }}
                </td>
                <td class="max-w-48 px-4 py-4 font-medium text-ink">{{ item.item_name }}</td>
                <td class="max-w-56 truncate px-4 py-4 text-muted" :title="item.description || '—'">
                  {{ item.description || '—' }}
                </td>
                <td class="px-4 py-4">
                  <span class="rounded-full bg-paper px-2.5 py-1 text-xs font-medium text-ink">
                    {{ item.category }}
                  </span>
                </td>
                <td class="px-4 py-4 text-right tabular-nums text-ink">{{ item.quantity }}</td>
                <td class="whitespace-nowrap px-4 py-4 text-right tabular-nums text-muted">
                  {{ formatPeso(item.unit_price) }}
                </td>
                <td class="whitespace-nowrap px-4 py-4 text-right font-medium tabular-nums text-ink">
                  {{ formatPeso(item.quantity * item.unit_price) }}
                </td>
                <td class="whitespace-nowrap px-5 py-4 text-right sm:px-6">
                  <div class="inline-flex items-center gap-1.5">
                    <button
                      type="button"
                      class="table-action"
                      :aria-label="`Edit ${item.item_name}`"
                      @click="openEditForm(item)"
                    >
                      Edit
                    </button>
                    <button
                      type="button"
                      class="table-action table-action-danger"
                      :aria-label="`Delete ${item.item_name}`"
                      :disabled="deletingId === item.id"
                      @click="deleteItem(item)"
                    >
                      {{ deletingId === item.id ? 'Deleting…' : 'Delete' }}
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <InventoryForm
      v-if="formOpen"
      :item="editingItem"
      :saving="saving"
      @save="saveItem"
      @cancel="closeForm"
    />
  </section>
</template>
