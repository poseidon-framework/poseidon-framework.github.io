<div id="app">
  <package-explorer></package-explorer>
</div>

<script>
  const { createApp, ref, computed, watch } = Vue;

  const PackageExplorer = {
    setup() {
      const packages = ref(null);
      const samples = ref(null);
      const searchQuery = ref('');
      const archiveType = ref('community-archive');
      const mapInstance = ref(null);
      var mapMarkers = [];
      const markerClusters = L.markerClusterGroup({ chunkedLoading: true });
      const selectedPackage = ref('');

      const packageTitles = computed(() => {
        if (!packages.value) {
          return [];
        }
        return packages.value.map((pac) => pac.packageTitle.toLowerCase());
      });

      const filteredPackages = ref([]);

      // Watch for changes in searchQuery and update filteredPackages accordingly
      watch([searchQuery, packageTitles], ([newSearchQuery, newPackageTitles]) => {
        if (!newPackageTitles || !newSearchQuery) {
          filteredPackages.value = packages.value;
          return;
        }
        const lowercaseQuery = newSearchQuery.toLowerCase();
        const matchingPackageTitles = newPackageTitles.filter((title) =>
          title.includes(lowercaseQuery)
        );
        filteredPackages.value = packages.value.filter((pac) =>
          matchingPackageTitles.includes(pac.packageTitle.toLowerCase())
        );
      });

      const loadPackages = async () => {
        try {
          let apiUrl = 'https://server.poseidon-adna.org/packages';
          apiUrl += '?archive=' + archiveType.value;
          const response_pacs = await fetch(apiUrl);
          const response_pacs_json = await response_pacs.json();
          packages.value = response_pacs_json.serverResponse.packageInfo;
        } catch (error) {
          console.error(error);
        }
      };

      const loadSamples = async () => {
        try {
          let apiUrl = 'https://server.poseidon-adna.org/individuals?additionalJannoColumns=Latitude,Longitude,Country,Location,Group_Name,Age';
          apiUrl += '&archive=' + archiveType.value;
          const response_inds = await fetch(apiUrl);
          const response_inds_json = await response_inds.json();
          samples.value = response_inds_json.serverResponse.extIndInfo;
        } catch (error) {
          console.error(error);
        }
      };

      const getSamplesForPackage = (requestedPackageTitle) => {
        if (!samples.value) {
          return;
        }
        return samples.value.filter((s) => s.packageTitle === requestedPackageTitle);
      };

      const addSamplesToMap = async (requestedPackageTitle) => {
        try {
          // check if necessary data and objects are there
          if (!mapInstance.value) {
            return;
          }
          if (!samples.value) {
            return;
          }
          // filter to one package, if this is requested
          if (requestedPackageTitle === undefined) {
            samplesFiltered = samples.value;
          } else {
            samplesFiltered = getSamplesForPackage(requestedPackageTitle);
          }
          // compile markers
          samplesFiltered.forEach((s) => {
            const addCols = s.additionalJannoColumns;
            const lat = addCols[0][1];
            const lng = addCols[1][1];
            if (lat == 0 && lng == 0) {
              return;
            }
            const location = addCols[3][1];
            const groupName = addCols[4][1];
            const age = addCols[5][1];
            const popupContent = `<b>Package:</b> ${s.packageTitle}<br><b>Package Version:</b> ${s.packageVersion}<br><b>Poseidon ID:</b> ${s.poseidonID}<br><b>Location:</b> ${location}<br><b>Group Name:</b> ${groupName}<br><b>Age:</b> ${age}`;
            const oneMarker = L.marker([lat, lng]).bindPopup(popupContent);
            mapMarkers.push(oneMarker);
          });
          markerClusters.addLayers(mapMarkers);
          mapInstance.value.addLayer(markerClusters);
          mapInstance.value.fitBounds(markerClusters.getBounds());
        } catch (error) {
          console.error(error);
        }
      };

      const resetMarkers = () => {
        markerClusters.removeLayers(mapMarkers);
        mapMarkers = [];
      };

      const loadAllData = async () => {
        await loadPackages();
        await loadSamples();
      };

      const updateMap = async (requestedPackageTitle) => {
        if (markerClusters) {
          resetMarkers();
        }
        addSamplesToMap(requestedPackageTitle);
      };

      const showSelection = async () => {
        await loadAllData();
        updateMap();
      };

      const highlightSamplesInMap = (requestedPackageTitle) => {
        updateMap(requestedPackageTitle);
      };

      const downloadGenotypeData = (packageTitle) => {
        const downloadLink = document.createElement('a');
        downloadLink.href = `https://server.poseidon-adna.org/zip_file/${packageTitle}?archive=${archiveType.value}`;
        downloadLink.download = `${packageTitle}.zip`;
        downloadLink.click();
      };

      showSelection();

      return {
        packages,
        searchQuery,
        archiveType,
        mapInstance,
        filteredPackages,
        showSelection,
        highlightSamplesInMap,
        resetMarkers,
        downloadGenotypeData,
        getSamplesForPackage,
        selectedPackage,
      };
    },
    template: `
      <div>
        
        <!-- archive selection -->      
        <select id="archive-type-select" v-model="archiveType" @change="showSelection">
          <option value="community-archive">Poseidon Community Archive</option>
          <option value="aadr-archive">Poseidon AADR Archive</option>
        </select>

        <!-- search bar -->
        <div class="search-bar">
          <input type="text" v-model="searchQuery" placeholder="Search Poseidon packages by title" />
        </div>

        <div v-if="packages">
          <map-view></map-view>
        <div class="table-container">
          <table class="table-default">
            <colgroup>
              <col style="width: 30%" />
              <col style="width: 55%" />
              <col style="width: 5%" />
              <col style="width: 5%" />
              <col style="width: 5%" />
            </colgroup>
            <thead>
              <tr>
                <th>Package Title</th>
                <th>Description</th>
                <th></th>
                <th></th>
                <th></th>              
              </tr>
            </thead>
            <tbody>
              <tr v-for="(pac, index) in filteredPackages.slice(0,30)" :key="index">
                <td style="overflow-wrap: break-word;">
                  {{ pac.packageTitle }}
                </td>
                <td>
                  <details>
                    <summary style="color: white">
                      Package Details
                    </summary>
                    <div class="details-content">
                      <b>Description:</b> {{ pac.description }}<br>
                      <b>Version:</b> {{ pac.packageVersion }}<br>
                      <b>Last Modified:</b> {{ pac.lastModified }}<br>
                      <b>Poseidon Version:</b> {{ pac.poseidonVersion }}<br>
                      <b>Nr of samples:</b> {{ pac.nrIndividuals }}
                    </div>
                  </details>
                </td>
                <td>
                  <button @click="selectedPackage = pac.packageTitle" title="View package information">
                    <i class="fas fa-search" aria-hidden="true"></i>
                  </button>
                </td>
                <td>
                  <button @click="highlightSamplesInMap(pac.packageTitle)" title="Highlight samples on the map">
                    <i class="fas fa-map" aria-hidden="true"></i>
                  </button>
                </td>
                <td>
                  <button @click="downloadGenotypeData(pac.packageTitle)" title="Download genotype data for this package">
                    <i class="fas fa-download" aria-hidden="true"></i>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>  
    `
  };

  const MapView = {
    template: `
    <div>
      <div id="map" style="height: 400px;"></div>
    </div>
    `,
    mounted() {
      const map = L.map('map').setView([30, 10], 2);
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {}).addTo(map);
      this.$parent.mapInstance = map;
    },
  };

  const app = createApp(PackageExplorer);
  app.component('map-view', MapView);
  app.mount('#app');
</script>

<style>

  #archive-type-select {
    width: 100%;
    padding: 5px;
  }

  .search-bar {
    margin-top: 10px;
    margin-bottom: 10px;
  }
  .search-bar input[type="text"] {
    width: 100%;
    padding: 5px;
  }

  .table-container {
    max-height: 400px; 
    overflow-y: scroll;
    width: 100%;
  }
  .table-default {
    width: 100%;
    display: table !important;
    table-layout: fixed;
  }
   
</style>

