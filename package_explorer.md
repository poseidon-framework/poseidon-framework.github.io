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
    const modalPackage   = ref('');

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
        let apiUrl = 'https://server.poseidon-adna.org/individuals?additionalJannoColumns=Latitude,Longitude,Country';
        apiUrl += ('&archive=' + archiveType.value);
        const response_inds = await fetch(apiUrl);
        const response_inds_json = await response_inds.json();
        samples.value = response_inds_json.serverResponse.extIndInfo;
      } catch (error) {
        console.error(error);
      }
    };

    const getSamplesForPackage = (requestedPackageTitle) => {
      if (!samples.value) { return; }
      return(samples.value.filter(s => { return(s.packageTitle === requestedPackageTitle) }))
    }

    const addSamplesToMap = async (requestedPackageTitle) => {
      try {
        // check if necessary data and objects are there
        if (!mapInstance.value) { return; }
        if (!samples.value) { return; }
        // filter to one package, if this is requested
        if (requestedPackageTitle === undefined) { 
          samplesFiltered = samples.value;
        } else {
          samplesFiltered = getSamplesForPackage(requestedPackageTitle);
        }
        // compile markers
        samplesFiltered.forEach(s => {
          const addCols = s.additionalJannoColumns;
          const lat = addCols[0][1];
          const lng = addCols[1][1];
          if (lat == 0 && lng == 0) { return; }
          const popupContent = `<b>Package:</b> ${s.packageTitle}<br><b>Package Version:</b> ${s.packageVersion}<br><b>Poseidon ID:</b> ${s.poseidonID}`;
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
      getSamplesForPackage,
      modalPackage
    };
  },
  template: `
    <div>
      <div>
        <input type="text" v-model="searchQuery" placeholder="Search Packages" />
        <div></div>
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

        <table class="table-default">
          <colgroup>
            <col style="width:6%">
            <col style="width:38%">
            <col style="width:38%">
            <col style="width:6%">
            <col style="width:6%">
            <col style="width:6%">
          </colgroup>  
          <tbody>
            <tr v-for="pac in filteredPackages" :key="pac.packageTitle">
              <td>
                {{ pac.nrIndividuals }}
              </td>
              <td style="overflow-wrap: break-word;">
                {{ pac.packageTitle }}
              </td>
              <td>
                <details>
                  <b>Description:</b> {{ pac.description }}<br>
                  <b>Version:</b> {{ pac.packageVersion }}<br>
                  <b>Last Modified:</b> {{ pac.lastModified }}<br>
                  <b>Poseidon Version:</b> {{ pac.poseidonVersion }}<br>
                  <b>Nr of samples:</b> {{ pac.nrIndividuals }}
                </details>
              </td>
              <td>
                <button @click="modalPackage = pac.packageTitle"><i class="fas fa-search" aria-hidden="true"></i></button>
              </td>
              <td>
                <button @click="highlightSamplesInMap(pac.packageTitle)"><i class="fas fa-map" aria-hidden="true"></i></button>
              </td>
              <td>
                <button @click="downloadGenotypeData(pac.packageTitle)"><i class="fas fa-download" aria-hidden="true"></i></button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div v-if="modalPackage !== ''" class="modal-background"> 
      <div class="modal">
        <div class="modal-header">
          <h3>{{ modalPackage }}</h3>
          <label for="modal" @click="modalPackage = ''">close</label>
        </div>
        <table>
          <tbody>
            <tr v-for="sample in getSamplesForPackage(modalPackage)">
              <td>{{ sample.poseidonID }}</td>
              <td>{{ sample.additionalJannoColumns[2][1] }}</td>
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
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {}).addTo(map);
    this.$parent.mapInstance = map;
  },
};

const app = createApp(PackageExplorer);
app.component('map-view', MapView);
app.mount('#app');

</script>

<style>

  .table-default {
    width: 100%;
    display: table !important;
    table-layout: fixed;
  }
  .table-default thead {
    width: 100%;
  } 
  .table-default tbody {
    width: 100%;
  } 
  .table-default tr {
    width: 100%;
  }
  .table-default th {
  }
  .table-default td {
  }

  .modal-background {
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
    position: fixed;
    top: 0;
    left: 0;
    z-index: 9998;
  }
  .modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    margin: auto;
    width: 50%;
    height: 50%;
    background-color: #fff;
    box-sizing: border-box;
    z-index: 9999;
    overflow: auto;
  }
  .modal-header {
    background-color: #f9f9f9;
    border-bottom: 1px solid #dddddd;
    box-sizing: border-box;
    height: 50px;
  }
  .modal-header h3 {
    margin: 0;
    box-sizing: border-box;
    padding-left: 15px;
    line-height: 50px;
    color: #4d4d4d;
    font-size: 16px;
    display: inline-block;
  }
  .modal-header label {
    box-sizing: border-box;
    border-left: 1px solid #dddddd;
    float: right;
    line-height: 50px;
    padding: 0 15px 0 15px;
    cursor: pointer;
  }
  
</style>

