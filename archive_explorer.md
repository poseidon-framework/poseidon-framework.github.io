<script>
  const { createApp, ref, computed, watch } = Vue;

  const PackageExplorer = {
    setup() {
      const packages = ref(null);
      const samples = ref(null);
      const searchQuery = ref('');
      const archiveType = ref('community-archive');
      const loading = ref(true);
      const mapInstance = ref(null);
      var mapMarkers = [];
      var markerClusters = L.markerClusterGroup({ chunkedLoading: true });
      const selectedPackageTitle = ref(null);
      const selectedPackage = ref(null);

      const packageTitles = computed(() => {
        if (!packages.value) { return []; }
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
          const filteredPackages = response_pacs_json.serverResponse.packageInfo.filter((p) => p.isLatest);
          packages.value = filteredPackages;
        } catch (error) {
          console.error(error);
        }
      };

      const loadSamples = async () => {
        try {
          let apiUrl = 'https://server.poseidon-adna.org/individuals?additionalJannoColumns=Genetic_Sex,Country,Location,Latitude,Longitude,Date_Type,Date_C14_Labnr,Date_BC_AD_Median,MT_Haplogroup,Y_Haplogroup,Capture_Type,UDG,Library_Built,Genotype_Ploidy,Nr_SNPs,Coverage_on_Target_SNPs,Publication';
          apiUrl += '&archive=' + archiveType.value;
          const response_inds = await fetch(apiUrl);
          const response_inds_json = await response_inds.json();
          const filteredSamples = response_inds_json.serverResponse.extIndInfo.filter((p) => p.isLatest);
          samples.value = filteredSamples;
        } catch (error) {
          console.error(error);
        }
      };

      const getSamplesForPackage = (requestedPackageTitle) => {
        if (!samples.value) { return; }
        return samples.value.filter((s) => s.packageTitle === requestedPackageTitle);
      };

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
          samplesFiltered.forEach((s) => {
            const addCols = s.additionalJannoColumns;
            const lat = addCols[3][1];
            const lng = addCols[4][1];
            if (lat == 0 && lng == 0) { return; }
            const location = addCols[2][1];
            const groupName = s.groupNames;
            const age = addCols[7][1];
            const popupContent =
              `<b>Poseidon ID:</b> ${s.poseidonID}<br>
               <b>Group Name:</b> ${groupName}<br>
               <b>Package:</b> ${s.packageTitle}<br>
               <b>Package Version:</b> ${s.packageVersion}<br>
               <b>Location:</b> ${location}<br>
               <b>Age BC/AD:</b> ${age}`;
            const oneMarker = L.marker([lat, lng]).bindPopup(popupContent);
            mapMarkers.push(oneMarker);
          });
          markerClusters.addLayers(mapMarkers);
          mapInstance.value.addLayer(markerClusters);
          // zoom
          var bounds = markerClusters.getBounds();
          if (bounds.isValid()) {
            mapInstance.value.fitBounds(bounds);
          }
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
        loading.value = true;
        await loadAllData();
        await updateMap();
        loading.value = false;
      };

      const selectPackage = async (requestedPackageTitle) => {
        loading.value = true;
        selectedPackageTitle.value = requestedPackageTitle;
        selectedPackage.value = packages.value.filter((pac) =>
          pac.packageTitle === selectedPackageTitle.value
        )[0];
        await updateMap(requestedPackageTitle);
        loading.value = false;
      }
      const unselectPackage = async () => {
        loading.value = true;
        selectedPackageTitle.value = null;
        await updateMap();
        mapInstance.value.setView([30, 10], 1);
        loading.value = false;
      }

      // primitive attempt to enable a URL selection for packages
      // has to be done way more professionally
      // const selectPackageByURL = async () => {
      //   let uri = window.location.href.split('?');
      //   if (uri.length == 2) {
      //     let vars = uri[1].split('&');
      //     let getVars = {};
      //     let tmp = '';
      //     vars.forEach(function(v) {
      //       tmp = v.split('=');
      //       if(tmp.length == 2)
      //         getVars[tmp[0]] = tmp[1];
      //     });
      //     if (getVars["package"]) {
      //       await loadAllData();
      //       selectPackage(getVars["package"]);
      //       console.log(selectedPackageTitle.value);
      //     }
      //   }
      // }
      // selectPackageByURL();

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
        loading,
        mapInstance,
        filteredPackages,
        showSelection,
        resetMarkers,
        downloadGenotypeData,
        getSamplesForPackage,
        selectPackage,
        selectedPackageTitle,
        selectedPackage,
        unselectPackage
      };
    }
  };

  const MapView = {
    template: `<div id="map" style="height: 400px;"></div>`,
    mounted() {
      const map = L.map('map').setView([30, 10], 1);
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {}).addTo(map);
      this.$parent.mapInstance = map;
    },
  };

  const app = createApp(PackageExplorer);
  app.component('map-view', MapView);
  app.mount('#archiveExplorer');
</script>

<div id="archiveExplorer">

  <!-- loading banner -->
  <div v-if="loading" class="loading-banner" style="color:#fc8d21;">
    <span class="loading-spinner">_</span>&nbsp; Loading...
  </div>
  <div v-else class="loading-banner" style="color:#7CFC00;">
    <i class="fa fa-check" aria-hidden="true"></i>
  </div>

  <div v-if="!selectedPackageTitle">
    <!-- archive selection -->      
    <select id="archive-type-select" v-model="archiveType" @change="showSelection">
      <option value="community-archive">Poseidon Community Archive</option>
      <option value="aadr-archive">Poseidon AADR Archive</option>
    </select>
  </div>
  <div v-else>
    <button id=go-back-button @click="unselectPackage()" title="Go back to package overview.">
      <i class="fa fa-arrow-left" aria-hidden="true"></i> Back to the package overview page
    </button>
    <h3>Package: {{ selectedPackageTitle }} </h3>
  </div>

  <!-- search bar -->
  <div v-if="!selectedPackageTitle">
    <div class="search-bar">
      <input type="text" v-model="searchQuery" placeholder="Search Poseidon packages by title" />
    </div>
  </div>

  <div v-if="packages">

  <map-view></map-view>

  <!-- package view -->
  <div v-if="selectedPackageTitle">

  <div>
    <table class="table-default">
      <colgroup>
        <col style="width: 20%" />
        <col style="width: 80%" />
      </colgroup>
      <tbody>
        <tr>
          <td>Description</td>
          <td>{{ selectedPackage.description }}</td>
        </tr>
        <tr>
          <td>Package version</td>
          <td>
            v{{ selectedPackage.packageVersion }}
            <span v-if="selectedPackage.isLatest">(that is the latest available version)</span>
            <span v-else>(that is not the latest available version)</span>
            for Poseidon v{{ selectedPackage.poseidonVersion }}.
            <br>
            It was last modified on {{ selectedPackage.lastModified }}.
          </td>
        </tr>
        <tr>
          <td>Nr of samples</td>
          <td>{{ selectedPackage.nrIndividuals }}</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div>
    <table class="table-default">
      <colgroup>
        <col style="width: 20%" />
        <col style="width: 30%" />
        <col style="width: 50%" />
      </colgroup>
      <thead>
        <tr>
          <th>Poseidon_ID</th>
          <th>Groups</th>
          <th>Details</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="sample in getSamplesForPackage(selectedPackageTitle)">
          <td>{{ sample.poseidonID }}</td>
          <td>{{ sample.groupNames.toString() }}</td>
          <td>
            <details>
              <summary>View sample details</summary>
              <div v-for="addCol in sample.additionalJannoColumns">
                <div v-if="addCol[1] !== null">
                  <b>{{ addCol[0] }}</b>: {{ addCol[1] }}<br>
                </div>
              </div>
              <small>*More variables are available in the complete .janno file.</small>
            </details>
          </td>
        </tr>
      </tbody>
    </table>
  </div>

  </div>

  <!-- overview -->
  <div v-if="!selectedPackageTitle">

  <div class="table-container">

  <table class="table-default">
    <colgroup>
      <col style="width: 30%" />
      <col style="width: 54%" />
      <col style="width: 16%" />
    </colgroup>
    <tbody>
      <tr v-for="(pac, index) in filteredPackages" :key="index">
        <td style="overflow-wrap: break-word;">
          <b>{{ pac.packageTitle }}</b><br>
          v{{ pac.packageVersion }}, Samples: {{ pac.nrIndividuals }}
        </td>
        <td>
          {{ pac.description }}
          </div>
        </td>
        <td>
          <button @click="selectPackage(pac.packageTitle)" title="Open the package information page">
            <i class="fas fa-search" aria-hidden="true"></i>
          </button>
          &nbsp;
          <a :href="'https://github.com/poseidon-framework/' + archiveType + '/tree/master/' + pac.packageTitle" target="_blank">
            <button title="This package on GitHub">
              <i class="fab fa-github" aria-hidden="true"></i>
            </button>
          </a>
          &nbsp;
          <button @click="downloadGenotypeData(pac.packageTitle)" title="Download this package">
            <i class="fas fa-download" aria-hidden="true"></i>
          </button>
        </td>
      </tr>
    </tbody>
  </table>

  </div>
  </div>
  </div>

</div>  

<style>
  .loading-banner {
    width: 100%;
    height: 30px;
    text-align: right;
  }
  .loading-spinner {
    display: inline-block;
    animation: spin 1s infinite linear;
  }
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }

  #archive-type-select {
    width: 100%;
    padding: 5px;
  }

  #go-back-button {
    width: 100%;
    padding: 5px;
    margin-bottom: 10px;
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
    word-wrap: break-word;
  }
</style>

