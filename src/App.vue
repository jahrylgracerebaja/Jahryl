<script setup>
import HeroSection from './components/HeroSection.vue'
import InventorySection from './components/InventorySection.vue'
</script>

<template>
  <div class="min-h-screen bg-paper text-ink">
    <HeroSection />
    <main>
      <InventorySection />
    </main>
    <footer class="border-t border-line px-5 py-6 text-center text-sm text-muted">
      Simple Inventory Management System
    </footer>
  </div>
</template>
