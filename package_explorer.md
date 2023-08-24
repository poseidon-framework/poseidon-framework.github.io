# Repository Explorer

<div id="app">
  <package-explorer></package-explorer>
</div>

<script>
const { createApp, ref, computed } = Vue;

const MapSymbol = Symbol();

const PackageExplorer = {
  setup() {
    const packages = ref(null);
    const individuals = ref(null);
    const selectedEntityType = ref('packages');
    const searchQuery = ref('');
    const displayType = ref('table');
    const selectedPackage = ref(null);
    const archiveType = ref('gold_standard');

    const loadData = async () => {
      try {
        let apiUrl = 'https://server.poseidon-adna.org/packages';
        if (archiveType.value === 'aadr_archive') {
          apiUrl += '?archive=aadr-archive';
        }

        const response_pacs = await fetch(apiUrl);
        const response_pacs_json = await response_pacs.json();
        packages.value = response_pacs_json.serverResponse.packageInfo;
      } catch (error) {
        console.error(error);
      }
    };

    const filteredPackages = computed(
      () => {
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

    const showSelection = () => {
      loadData();
    };

    loadData();

    return {
      packages,
      selectedEntityType,
      searchQuery,
      displayType,
      selectedPackage,
      archiveType,
      filteredPackages,
      showPackageDetails,
      showSelection,
      MapView
    };
  },
  template: `
    <div>
      <input type="radio" id="table_view" value="table" v-model="displayType" />
      <label for="table_view">Table View</label>
      <input type="radio" id="list_view" value="list" v-model="displayType" />
      <label for="list_view">List View</label>

      <div></div> <!-- Empty div for spacing -->

      <div>
        <label for="archive_type">Archive type:</label>
        <select id="archive_type" v-model="archiveType">
          <option value="gold_standard">Poseidon Gold standard</option>
          <option value="aadr_archive">Poseidon AADR</option>
        </select>
      </div>

      <div></div> <!-- Empty div for spacing -->

      <button @click="showSelection">Show Selection</button>

      <div v-if="packages && selectedEntityType === 'packages'">

        <map-view></map-view>

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

        <div v-else-if="displayType === 'list'">
          <ul class="list-view">
            <li v-for="pac in filteredPackages" :key="pac.packageTitle" @click="showPackageDetails(pac)">
              {{ pac.packageTitle }}
            </li>
          </ul>
        </div>

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
        
        <div v-else><i>...fetching data from poseidon package server</i></div>
      </div>
    </div>
  `,
};

const loadMapData = async (map) => {
  try {
    const response_geo = await fetch('https://server.poseidon-adna.org/individuals?additionalJannoColumns=Latitude,Longitude');
    const response_geo_json = await response_geo.json();
    const individuals_all = response_geo_json.serverResponse.extIndInfo;
    const individuals_one_package = individuals_all.filter((ind) => ind.packageTitle == "2019_Feldman_Anatolia")

    const markerGroup = L.markerClusterGroup();
    individuals_all.forEach(individual => {
      const addCols = individual.additionalJannoColumns
      const lat = addCols.filter((oneCol) => oneCol[0] == "Latitude")[0][1]
      const lng = addCols.filter((oneCol) => oneCol[0] == "Longitude")[0][1]
      const popupContent = `<b>Package:</b> ${location.packageTitle}<br><b>Package Version:</b> ${location.packageVersion}<br><b>Poseidon ID:</b> ${location.poseidonID}`;
      var marker = L.marker([lat,lng]).bindPopup(popupContent);
      markerGroup.addLayer(marker);
    });
    map.addLayer(markerGroup);

  } catch (error) {
    console.error(error);
  }
};

const MapView = {
  template: `
    <div>
      <div id="map" style="height: 400px;"></div>
    </div>
  `,
  mounted() {
    const map = L.map('map').setView([0, 0], 2);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
    loadMapData(map);
    this.$parent[MapSymbol] = map; // Save the map instance
  },
};

const app = createApp(PackageExplorer);
app.component('map-view', MapView);

app.mount('#app');
</script>

<style>
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

