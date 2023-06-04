# The repository explorer (experimental)

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
      const response_pacs = await fetch("https://server.poseidon-adna.org/packages")
      const response_pacs_json = await response_pacs.json()
      const pacs = response_pacs_json.serverResponse.packageInfo
      const response_groups = await fetch("https://server.poseidon-adna.org/groups")
      const groups_json = await response_groups.json()
      const groups = groups_json.serverResponse.groupInfo
      console.log(groups)
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
        <td>{{pac.packageVersion}}</td>
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
        <th>{{group.groupName}}</td>
        <td>{{group.packageNames.map(x => x.packageTitle).join(', ')}}</td>
        <td>{{group.nrIndividuals}}</td>
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else><i>...fetching data from poseidon package server</i></div>
</div>