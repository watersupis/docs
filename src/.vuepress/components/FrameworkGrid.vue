<template>
    <div class="framework-grid">
      <div 
        v-for="(framework, index) in frameworks" 
        :key="index" 
        class="grid-item"
      >
        <FrameworkCard :framework="framework" />
      </div>
    </div>
  </template>
  
  <script>
  import FrameworkCard from './FrameworkCard.vue'
  
  export default {
    components: {
      FrameworkCard
    },
    props: {
      frameworks: {
        type: Array,
        required: true
      }
    }
  }
  </script>
  
  <style scoped>
  .framework-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 50px 10px;
    margin-top: 2rem;
    margin-bottom: 2rem;
  }
  
  .grid-item {
    height: 100%;
  }
  
  @media (max-width: 1024px) {
    .framework-grid {
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    }
  }
  
  @media (max-width: 768px) {
    .framework-grid {
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 18px;
    }
  }
  
  @media (max-width: 480px) {
    .framework-grid {
      grid-template-columns: 1fr;
    }
  }
  </style>