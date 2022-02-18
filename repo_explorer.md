# The repository explorer

<script>
  Vue.createApp({
    data () {
     return {
        packages: null,
        groups: null,
        selected_entity_type: "packages"
      }
    },
    async mounted () {
      const response_pacs = await fetch("https://c107-224.cloud.gwdg.de/packages_all")
      const pacs = await response_pacs.json()
      const response_groups = await fetch("https://c107-224.cloud.gwdg.de/groups_all")
      const groups = await response_groups.json()
      this.packages = pacs
      this.groups = groups
    }
  }).mount('#explorer');
</script>

<div id="explorer">
  
  <input type="radio" id="packages_radio" value="packages" v-model="selected_entity_type" />
  <label for="packages_radio">Packages</label>
  <input type="radio" id="groups_radio" value="groups" v-model="selected_entity_type" />
  <label for="groups_radio">Groups</label>
  
  <div>Selected: {{selected_entity_type}}</div>
  <div v-if="packages && selected_entity_type === 'packages'">
    <p>loaded {{packages.length}} packages</p>
    <table>
      <thead>
        <tr>
          <th>Title</th>
          <th>Description</th>
          <th>Version</th>
          <th>Nr of individuals</th>
        </tr>
      </thead>
      <tbody>
      <tr v-for="pac in packages">
        <th>{{pac.title}}</td>
        <td>{{pac.description}}</td>
        <td>{{pac.version}}</td>
        <td>{{pac.nrIndividuals}}</td>
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else-if="groups && selected_entity_type === 'groups'">
    <p>loaded {{groups.length}} groups</p>
    <table>
      <thead>
        <tr>
          <th>Name</th>
          <th>Packages</th>
          <th>Nr of individuals</th>
        </tr>
      </thead>
      <tbody>
      <tr v-for="group in groups">
        <th>{{group.name}}</td>
        <td>{{group.packages.join(', ')}}</td>
        <td>{{group.nrIndividuals}}</td>
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else><i>...fetching data from poseidon package server</i></div>
</div>