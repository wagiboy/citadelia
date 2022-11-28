<template>
  <div>
    <p class="display-2 mt-15 gold--text text-center">Citadelia</p>
    <p class="title text-center">Public Works Funds Management System for Free Cities</p>      
  </div>
</template>

<script>
export default {
  data: () => ({ 
    value: 0
  }),
  methods: {
    setCookie(value) {
      console.log('setCookie('+value+')')
      this.$cookies.set('ttt', value);
      this.getCookie()
    },
    getCookie() {
      console.log('getCookie()')
      this.value = this.$cookies.get('ttt')
    },
    removeCookie() {
      console.log('removeCookie()')
      this.$cookies.remove('ttt');   
      this.getCookie()
    }
  }
}
</script> 