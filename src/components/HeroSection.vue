<script setup>
const developerName = 'Jahryl Grace Rebaja'
const profileImage = '/jahryl-profile.jpe'
</script>

<template>
  <header class="px-5 pb-12 pt-6 sm:px-8 sm:pb-16 sm:pt-8">
    <div class="mx-auto max-w-7xl">
      <a href="#" class="inline-flex items-center gap-2.5" aria-label="Inventory home">
        <span
          class="grid h-10 w-10 place-items-center rounded-xl bg-forest text-white"
          aria-hidden="true"
        >
          <svg viewBox="0 0 24 24" fill="none" class="h-5 w-5">
            <path
              d="M4 7.5 12 3l8 4.5v9L12 21l-8-4.5v-9Z"
              stroke="currentColor"
              stroke-width="1.7"
              stroke-linejoin="round"
            />
            <path d="m4.5 7.5 7.5 4.3 7.5-4.3M12 12v8.5" stroke="currentColor" stroke-width="1.7" />
          </svg>
        </span>
        <span class="text-sm font-semibold tracking-tight text-ink sm:text-base">
          Inventory<span class="text-forest">.simple</span>
        </span>
      </a>

      <section
        class="mt-8 overflow-hidden rounded-3xl border border-line bg-white shadow-card sm:mt-10"
        aria-labelledby="profile-name"
      >
        <div class="grid md:grid-cols-[minmax(240px,0.8fr)_1.2fr]">
          <img
            :src="profileImage"
            :alt="`${developerName} profile photo`"
            class="h-72 w-full object-cover object-center sm:h-96 md:h-full md:min-h-[440px]"
          />
          <div class="flex flex-col justify-center px-6 py-9 sm:px-10 sm:py-12 lg:px-16">
            <span class="eyebrow">Developer profile</span>
            <h1 id="profile-name" class="mt-3 text-4xl font-semibold leading-tight tracking-tight text-ink sm:text-5xl">
              {{ developerName }}
            </h1>
            <p class="mt-2 text-sm font-medium text-forest">Designed and Developed by {{ developerName }}</p>
            <div class="my-7 h-px w-full bg-line"></div>
            <h2 class="text-xl font-semibold tracking-tight text-ink sm:text-2xl">
              Simple Inventory Management System
            </h2>
            <p class="mt-3 max-w-lg text-base leading-7 text-muted">
              A simple and efficient way to manage inventory records.
            </p>
            <a href="#inventory" class="button-primary mt-7 self-start">
              Manage Inventory
              <svg viewBox="0 0 20 20" fill="none" class="h-4 w-4" aria-hidden="true">
                <path
                  d="M10 4v12m0 0 5-5m-5 5-5-5"
                  stroke="currentColor"
                  stroke-width="1.7"
                  stroke-linecap="round"
                  stroke-linejoin="round"
                />
              </svg>
            </a>
          </div>
        </div>
      </section>
    </div>
  </header>
</template>
