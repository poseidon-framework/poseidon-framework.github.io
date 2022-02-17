# The repository explorer

<script>
  Vue.createApp({
    data () {
     return {
        packages: null,
      }
    },
    async mounted () {
      const response = await fetch("https://c107-224.cloud.gwdg.de/packages_all")
      const pacs = await response.json()
      this.packages = pacs
    }
  }).mount('#explorer');
</script>

<div id="explorer">
  <div v-if="packages">
    loaded {{packages.length}} packages
  </div>
  <div v-else><i>...loading packages - or server might be unresponsive</i></div>
</div>