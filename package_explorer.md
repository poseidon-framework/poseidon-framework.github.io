<div id="app">
  <package-explorer></package-explorer>
</div>

<script>
const { createApp, ref, computed } = Vue;

const PackageExplorer = {
  setup() {
    const packages       = ref(null);
    const samples        = ref(null);
    const searchQuery    = ref('');
    const archiveType    = ref('community-archive');
    const mapInstance    = ref(null);
    var   mapMarkers     = [];
    const markerClusters = L.markerClusterGroup({chunkedLoading: true});

    const packageTitles = computed(() => {
      if (!packages.value) { return []; }
      return packages.value.map(pac => pac.packageTitle.toLowerCase());
    });

    const filteredPackages = computed(() => {
      if (!packageTitles.value) { return []; }
      if (!searchQuery.value) { return packages.value; }
      const lowercaseQuery = searchQuery.value.toLowerCase();
      const matchingPackageTitles = packageTitles.value.filter(title =>
        title.includes(lowercaseQuery)
      );
      return packages.value.filter(pac =>
        matchingPackageTitles.includes(pac.packageTitle.toLowerCase())
      );
    });

    const loadPackages = async () => {
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

    const loadSamples = async () => {
      try {  
        let apiUrl = 'https://server.poseidon-adna.org/individuals?additionalJannoColumns=Latitude,Longitude';
        apiUrl += ('&archive=' + archiveType.value);
        const response_inds = await fetch(apiUrl);
        const response_inds_json = await response_inds.json();
        samples.value = response_inds_json.serverResponse.extIndInfo;
      } catch (error) {
        console.error(error);
      }
    };

    const addSamplesToMap = async (requestedPackageTitle) => {
      try {
        // check if necessary data and objects are there
        if (!mapInstance.value) { return; }
        if (!samples.value) { return; }
        // filter to one package, if this is requested
        if (requestedPackageTitle === undefined) {
          samplesFiltered = samples.value
        } else {
          samplesFiltered = samples.value.filter(s => {
            return(s.packageTitle === requestedPackageTitle)
          })
        }
        // compile markers
        samplesFiltered.forEach(s => {
          const addCols = s.additionalJannoColumns;
          const lat = addCols[0][1];
          const lng = addCols[1][1];
          const popupContent = `<b>Package:</b> ${s.packageTitle}<br><b>Package Version:</b> ${s.packageVersion}<br><b>Poseidon ID:</b> ${s.poseidonID}`;
          const oneMarker = L.marker([lat, lng]).bindPopup(popupContent);
          mapMarkers.push(oneMarker);
        });
        markerClusters.addLayers(mapMarkers);
        mapInstance.value.addLayer(markerClusters);
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
    }

    const updateMap = async (requestedPackageTitle) => {
      if (markerClusters) { resetMarkers(); }
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
        <button @click="showSelection">Show Selection</button>
      </div>
      <div></div> <!-- Empty div for spacing -->

      <div v-if="packages">

        <map-view></map-view>

        <table class="table-view">
          <thead>
            <tr>
              <th style="background-color: black; color: white;">Package Title</th>
              <th style="background-color: black; color: white;">Package Information</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="pac in filteredPackages" :key="pac.packageTitle">
              <td>{{ pac.packageTitle }}</td>
              <td>
                <b>Description:</b> {{ pac.description }}<br>
                <b>Version:</b> {{ pac.packageVersion }}<br>
                <b>Last Modified:</b> {{ pac.lastModified }}<br>
                <b>Poseidon Version:</b> {{ pac.poseidonVersion }}<br>
                <b>Nr of Individuals:</b> {{ pac.nrIndividuals }}<br>
                <b>Download genotype data:</b> 
                <button @click="downloadGenotypeData(pac.packageTitle)">Download</button>
                <br>
                <button @click="highlightSamplesInMap(pac.packageTitle)">Highlight Samples</button>
              </td>
            </tr>
          </tbody>
        </table>
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

