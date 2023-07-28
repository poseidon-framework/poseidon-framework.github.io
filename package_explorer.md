# Repository Explorer

<div id="app">
  <package-explorer></package-explorer>
</div>

<script markdown="1">
  // Vue.js component code
  const { createApp, ref } = Vue;

  const PackageExplorer = {
    setup() {
      const packages = ref(null);
      const selectedEntityType = ref('packages');
      const searchQuery = ref('');
      const displayType = ref('table');
      const selectedPackage = ref(null);

      const loadData = async () => {
        try {
          const response_pacs = await fetch('https://server.poseidon-adna.org/packages');
          const response_pacs_json = await response_pacs.json();
          packages.value = response_pacs_json.serverResponse.packageInfo;
        } catch (error) {
          console.error(error);
        }
      };

      const filteredPackages = Vue.computed(() => {
        if (!packages.value) {
          return [];
        }

        if (!searchQuery.value) {
          return packages.value;
        }

        const lowercaseQuery = searchQuery.value.toLowerCase();
        return packages.value.filter(pac =>
          pac.packageTitle.toLowerCase().includes(lowercaseQuery)
        );
      });

      const showPackageDetails = (package) => {
        selectedPackage.value = package;
      };

      loadData();

      return {
        packages,
        selectedEntityType,
        searchQuery,
        displayType,
        filteredPackages,
        selectedPackage,
        loadData,
        showPackageDetails,
      };
    },
    template: `
      <div>
        <input type="radio" id="table_view" value="table" v-model="displayType" />
        <label for="table_view">Table View</label>
        <input type="radio" id="list_view" value="list" v-model="displayType" />
        <label for="list_view">List View</label>

        <div v-if="packages && selectedEntityType === 'packages'">
          <!-- Table view -->
          <div v-if="displayType === 'table'">
            <p>loaded {{ filteredPackages.length }} packages</p>
            <input type="text" v-model="searchQuery" placeholder="Search Title" />
            <table class="table-view">
              <thead>
                <tr>
                  <th style="background-color: black; color: white;">Title</th>
                  <th style="background-color: black; color: white;">Description</th>
                  <th style="background-color: black; color: white;">Version</th>
                  <th style="background-color: black; color: white;">Last Modified</th>
                  <th style="background-color: black; color: white;">Poseidon Version</th>
                  <th style="background-color: black; color: white;">Nr of Individuals</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="pac in filteredPackages" :key="pac.packageTitle" @click="showPackageDetails(pac)">
                  <td>{{ pac.packageTitle }}</td>
                  <td>{{ pac.description }}</td>
                  <td>{{ pac.packageVersion }}</td>
                  <td>{{ pac.lastModified }}</td>
                  <td>{{ pac.poseidonVersion }}</td>
                  <td>{{ pac.nrIndividuals }}</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- List view -->
          <div v-else-if="displayType === 'list'">
            <ul class="list-view">
              <li v-for="pac in filteredPackages" :key="pac.packageTitle" @click="showPackageDetails(pac)">
                {{ pac.packageTitle }}
              </li>
            </ul>
          </div>

          <!-- Show selected package details in List View -->
          <div v-if="selectedPackage && displayType === 'list'">
            <h3>Selected Package Details:</h3>
            <table class="table-view">
              <thead>
                <tr>
                  <th style="background-color: black; color: white;">Title</th>
                  <th style="background-color: black; color: white;">Description</th>
                  <th style="background-color: black; color: white;">Version</th>
                  <th style="background-color: black; color: white;">Last Modified</th>
                  <th style="background-color: black; color: white;">Poseidon Version</th>
                  <th style="background-color: black; color: white;">Nr of Individuals</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>{{ selectedPackage.packageTitle }}</td>
                  <td>{{ selectedPackage.description }}</td>
                  <td>{{ selectedPackage.packageVersion }}</td>
                  <td>{{ selectedPackage.lastModified }}</td>
                  <td>{{ selectedPackage.poseidonVersion }}</td>
                  <td>{{ selectedPackage.nrIndividuals }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
        <div v-else><i>...fetching data from poseidon package server</i></div>
      </div>
    `,
  };

  createApp(PackageExplorer).mount('#app');
</script>

<style markdown="1">
  /* Styles for list view */
  .list-view ul {
    list-style-type: none;
    padding: 0;
  }

  .list-view li {
    margin-bottom: 10px;
    padding: 5px;
    border: 1px solid #ddd;
    cursor: pointer;
  }

  /* Styles for table view */
  .table-view {
    width: 100%;
    border-collapse: collapse;
  }

  .table-view th,
  .table-view td {
    padding: 8px;
    border: 1px solid #ddd;
    text-align: left;
  }

  /* Common styles */
  label {
    margin-right: 10px;
  }
</style>

