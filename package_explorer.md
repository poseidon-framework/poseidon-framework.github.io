# Repository Explorer

<div id="app">
  <package-explorer></package-explorer>
</div>

<script>
  // Vue.js component code
  const { createApp, ref } = Vue;

  const PackageExplorer = {
    setup() {
      const packages = ref(null);
      const selectedEntityType = ref('packages');
      const searchQuery = ref('');
      const displayType = ref('table'); // Initialize to 'table'
      const selectedPackage = ref(null);
      const archiveType = ref('gold_standard'); // Initialize to 'gold_standard'
      const mapViewVisible = ref(true);
      const map = ref(null); // Reference to the Leaflet map
      const markers = ref([]); // Array to store the markers

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

      const loadMapData = async () => {
        try {
          const response_geo = await fetch('https://server.poseidon-adna.org/individuals?additionalJannoColumns=Latitude,Longitude');
          const response_geo_json = await response_geo.json();
          const locations = response_geo_json.serverResponse.individuals;

          // Clear existing markers
          markers.value.forEach(marker => {
            marker.remove();
          });

          // Add new markers
          locations.forEach(location => {
            const lat = location.additionalJannoColumns.Latitude;
            const lng = location.additionalJannoColumns.Longitude;

            const popupContent = `<b>Package:</b> ${JSON.stringify(location.packageTitle)}<br><b>Package Version:</b> ${JSON.stringify(location.packageVersion)}<br><b>Poseidon ID:</b> ${JSON.stringify(location.poseidonID)}`;
            const marker = L.marker([lat, lng]).bindPopup(popupContent);
            markers.value.push(marker);
            marker.addTo(map.value);
          });
        } catch (error) {
          console.error(error);
        }
      };

      // Other setup functions and computed properties...

      return {
        // Other return properties...
        mapViewVisible,
        map,
        markers,
        loadMapData,
      };
    },
    template: `
      <div>
        <input type="radio" id="table_view" value="table" v-model="displayType" />
        <label for="table_view">Table View</label>
        <input type="radio" id="list_view" value="list" v-model="displayType" />
        <label for="list_view">List View</label>
        <input type="radio" id="map_view" value="map" v-model="displayType" />
        <label for="map_view">Map View</label>

        <div></div> <!-- Empty div for spacing -->

        <!-- Archive type dropdown -->
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
          <!-- Table view, List view, and Map view sections... -->
        </div>
      </div>
    `,
  };

  // Create a separate Vue component for the map view
  const MapView = {
    template: `
      <div>
        <!-- Leaflet world map component-->
        <div id="map" style="height: 400px;"></div>
      </div>
    `,
    mounted() {
      // Leaflet world map configuration and markers here
      const map = L.map('map').setView([0, 0], 2);
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
      this.$parent.map = map; // Assign map to parent component
      this.$parent.loadMapData(); // Load map data
    },
  };

  // Create Vue app with both components
  const app = createApp(PackageExplorer);
  app.component('map-view', MapView);

  // Mount the Vue app
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

