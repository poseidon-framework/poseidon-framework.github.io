# Repository Explorer

<div id="app">
  <package-explorer></package-explorer>
</div>

<script>
const { createApp, ref, computed, watchEffect } = Vue;

const PackageExplorer = {
  setup() {
    const packages = ref(null);
    const individuals = ref(null);
    const selectedEntityType = ref('packages');
    const searchQuery = ref('');
    const selectedPackage = ref(null);
    const archiveType = ref('community-archive');
    const mapInstance = ref(null);
    const markers = ref([]);

    const packageTitles = computed(() => {
      if (!packages.value) {
        return [];
      }

      return packages.value.map(pac => pac.packageTitle.toLowerCase());
    });

    const filteredPackages = computed(() => {
      if (!packageTitles.value) {
        return [];
      }

      if (!searchQuery.value) {
        return packages.value;
      }

      const lowercaseQuery = searchQuery.value.toLowerCase();
      const matchingPackageTitles = packageTitles.value.filter(title =>
        title.includes(lowercaseQuery)
      );

      return packages.value.filter(pac =>
        matchingPackageTitles.includes(pac.packageTitle.toLowerCase())
      );
    });

    const showPackageDetails = (package) => {
      selectedPackage.value = package;
    };

    const loadData = async () => {
      try {
        let apiUrl = 'https://server.poseidon-adna.org/packages';
        apiUrl += ('?archive=' + archiveType.value);
        const response_pacs = await fetch(apiUrl);
        const response_pacs_json = await response_pacs.json();
        packages.value = response_pacs_json.serverResponse.packageInfo;
      } catch (error) {
        console.error(error);
      }
    };

    const loadMapData = async () => {
      try {
        if (!mapInstance.value) { return; }
        markers.value.forEach(marker => marker.remove()); // Clear existing markers
        markers.value = []; // Reset markers array

        let apiUrl = 'https://server.poseidon-adna.org/individuals?additionalJannoColumns=Latitude,Longitude';
        apiUrl += ('&archive=' + archiveType.value);
        const response_inds = await fetch(apiUrl);
        const response_inds_json = await response_inds.json();
        const individuals_all = response_inds_json.serverResponse.extIndInfo;

        const markerGroup = L.markerClusterGroup();
        individuals_all.forEach(ind => {
          const addCols = ind.additionalJannoColumns;
          const lat = addCols.filter(oneCol => oneCol[0] == "Latitude")[0][1];
          const lng = addCols.filter(oneCol => oneCol[0] == "Longitude")[0][1];

          if (packageTitles.value.includes(ind.packageTitle.toLowerCase())) {
            const popupContent = `<b>Package:</b> ${ind.packageTitle}<br><b>Package Version:</b> ${ind.packageVersion}<br><b>Poseidon ID:</b> ${ind.poseidonID}`;
            const marker = L.marker([lat, lng]).bindPopup(popupContent);
            markerGroup.addLayer(marker);
            markers.value.push(marker);
          }
        });
        mapInstance.value.addLayer(markerGroup);
      } catch (error) {
        console.error(error);
      }
    };

    const showSelection = () => {
      loadData();
      loadMapData();
    };

    loadData();

    watchEffect(() => {
      loadMapData();
    });

    return {
      packages,
      selectedEntityType,
      searchQuery,
      selectedPackage,
      archiveType,
      mapInstance,
      filteredPackages,
      showPackageDetails,
      showSelection,
      loadMapData
    };
  },
  template: `
    <div>
      <div>
        <label for="archive_type">Archive type:</label>
        <select id="archive_type" v-model="archiveType">
          <option value="community-archive">Poseidon Community Archive</option>
          <option value="aadr-archive">Poseidon AADR Archive</option>
        </select>
      </div>

      <div></div> <!-- Empty div for spacing -->

      <button @click="showSelection">Show Selection</button>

      <div v-if="packages && selectedEntityType === 'packages'">

        <map-view></map-view>

        <div>
          <p>loaded {{ filteredPackages.length }} packages</p>
          <input type="text" v-model="searchQuery" placeholder="Search Title" />
          <table class="table-view">
            <thead>
              <tr>
                <th style="background-color: black; color: white;">Title</th>
                <th style="background-color: black; color: white;">Package Information</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="pac in filteredPackages" :key="pac.packageTitle" @click="showPackageDetails(pac)">
                <td>{{ pac.packageTitle }}</td>
                <td>
                  <b>Description:</b> {{ pac.description }}<br>
                  <b>Version:</b> {{ pac.packageVersion }}<br>
                  <b>Last Modified:</b> {{ pac.lastModified }}<br>
                  <b>Poseidon Version:</b> {{ pac.poseidonVersion }}<br>
                  <b>Nr of Individuals:</b> {{ pac.nrIndividuals }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  `,
};

const MapView = {
  template: `
    <div>
      <div id="map" style="height: 400px;"></div>
    </div>
  `,
  mounted() {
    const map = L.map('map').setView([30, 10], 2);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { noWrap: true }).addTo(map);
    this.$parent.mapInstance = map;
    this.$parent.loadMapData();
  },
};

const app = createApp(PackageExplorer);
app.component('map-view', MapView);
app.mount('#app');

</script>

<style>
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

