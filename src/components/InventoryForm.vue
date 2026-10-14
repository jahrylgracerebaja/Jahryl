<script setup>
import { reactive, ref, watch } from 'vue'

const props = defineProps({
  item: {
    type: Object,
    default: null,
  },
  saving: {
    type: Boolean,
    default: false,
  },
})

const emit = defineEmits(['save', 'cancel'])
const validationMessage = ref('')

const form = reactive({
  item_name: '',
  description: '',
  category: '',
  quantity: 0,
  unit_price: 0,
})

watch(
  () => props.item,
  (item) => {
    form.item_name = item?.item_name ?? ''
    form.description = item?.description ?? ''
    form.category = item?.category ?? ''
    form.quantity = item?.quantity ?? 0
    form.unit_price = item?.unit_price ?? 0
  },
  { immediate: true },
)

function submitForm() {
  if (!form.item_name.trim() || !form.category.trim()) {
    validationMessage.value = 'Item name and category are required.'
    return
  }

  const quantity = Number(form.quantity)
  const unitPrice = Number(form.unit_price)
  if (!Number.isInteger(quantity) || quantity < 0 || !Number.isFinite(unitPrice) || unitPrice < 0) {
    validationMessage.value = 'Quantity must be a whole number and prices must be zero or greater.'
    return
  }

  validationMessage.value = ''
  emit('save', {
    item_name: form.item_name.trim(),
    description: form.description.trim(),
    category: form.category.trim(),
    quantity,
    unit_price: unitPrice,
  })
}
</script>

<template>
  <div
    class="fixed inset-0 z-20 flex items-end justify-center bg-ink/45 p-0 backdrop-blur-[2px] sm:items-center sm:p-5"
    @click.self="emit('cancel')"
  >
    <section
      class="max-h-[92vh] w-full overflow-y-auto rounded-t-2xl bg-white p-6 shadow-card sm:max-w-xl sm:rounded-2xl sm:p-8"
      role="dialog"
      aria-modal="true"
      aria-labelledby="form-title"
    >
      <div class="flex items-start justify-between gap-4">
        <div>
          <p class="eyebrow">Inventory record</p>
          <h2 id="form-title" class="mt-2 text-2xl font-semibold tracking-tight text-ink">
            {{ item ? 'Edit item' : 'Add an item' }}
          </h2>
        </div>
        <button
          type="button"
          class="icon-button"
          aria-label="Close form"
          :disabled="saving"
          @click="emit('cancel')"
        >
          <svg viewBox="0 0 20 20" fill="none" class="h-5 w-5" aria-hidden="true">
            <path d="m5 5 10 10M15 5 5 15" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" />
          </svg>
        </button>
      </div>

      <form class="mt-7 space-y-5" @submit.prevent="submitForm">
        <div v-if="validationMessage" class="notice-error" role="alert">
          {{ validationMessage }}
        </div>
        <div>
          <label class="field-label" for="item-name">Item name <span class="text-red-600">*</span></label>
          <input
            id="item-name"
            v-model="form.item_name"
            class="field-input"
            type="text"
            maxlength="120"
            autocomplete="off"
            required
          />
        </div>
        <div>
          <label class="field-label" for="category">Category <span class="text-red-600">*</span></label>
          <input
            id="category"
            v-model="form.category"
            class="field-input"
            type="text"
            maxlength="80"
            autocomplete="off"
            required
          />
        </div>
        <div>
          <label class="field-label" for="description">Description</label>
          <textarea
            id="description"
            v-model="form.description"
            class="field-input min-h-24 resize-y"
            rows="3"
            maxlength="500"
          />
        </div>
        <div class="grid gap-5 sm:grid-cols-2">
          <div>
            <label class="field-label" for="quantity">Quantity <span class="text-red-600">*</span></label>
            <input
              id="quantity"
              v-model.number="form.quantity"
              class="field-input"
              type="number"
              min="0"
              step="1"
              required
            />
          </div>
          <div>
            <label class="field-label" for="unit-price">Unit price (₱) <span class="text-red-600">*</span></label>
            <input
              id="unit-price"
              v-model.number="form.unit_price"
              class="field-input"
              type="number"
              min="0"
              step="0.01"
              required
            />
          </div>
        </div>
        <div class="flex flex-col-reverse gap-3 border-t border-line pt-5 sm:flex-row sm:justify-end">
          <button type="button" class="button-secondary" :disabled="saving" @click="emit('cancel')">
            Cancel
          </button>
          <button type="submit" class="button-primary" :disabled="saving">
            {{ saving ? 'Saving…' : item ? 'Save changes' : 'Save item' }}
          </button>
        </div>
      </form>
    </section>
  </div>
</template>
