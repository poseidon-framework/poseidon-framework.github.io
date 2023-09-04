# Version overview table

The following figure documents which versions of the Poseidon standard are compatible with which versions of the software tools. Newer versions of `trident` can generally still read older packages, when no [breaking changes](changelog.md) were introduced.

<script>
  Vue.createApp({
    data () {
     return {
        versionTableRows: null,
        tools: null,
        poseidonVersions: null,
        versionsPerTool: null
      }
    },
    async mounted () {
      const response = await fetch(
        "https://raw.githubusercontent.com/poseidon-framework/poseidon-framework.github.io/master/version_table_figure/version_table.tsv"
      );
      const versionTableTSVData = await response.text();
      this.versionTableRows = this.parseTSV(versionTableTSVData);
      this.tools = ["trident", "xerxes", "qjanno", "janno"]
        //this.versionTableRows.map((row) => row.tool).filter(this.unique).sort()
      this.poseidonVersions = this.versionTableRows.map((row) => row.poseidonVersion).filter(this.unique).sort()
      this.versionsPerTool = this.tools.map((tool) => this.getVersions(tool, this.versionTableRows))
      console.log(this.versionsPerTool)
    },
    methods: {
      parseTSV(csvData) {
        const lines = csvData.split("\n");
        const headers = lines[0].split("\t");
        const rows = [];
        for (let i = 1; i < lines.length; i++) {
          const values = lines[i].split("\t");
          if (values.length !== headers.length) continue;
          const row = {};
          for (let j = 0; j < headers.length; j++) {
            row[headers[j]] = values[j];
          }
          rows.push(row);
        }
        return rows;
      },
      getVersions(tool, versionTableRows) {
        return(
          versionTableRows
            .filter((row) => row.tool == tool)
            .map((row) => row.version)
            // https://stackoverflow.com/questions/40201533/sort-version-dotted-number-strings-in-javascript
            .map( a => a.split('.').map( n => +n+1000000 ).join('.') )
            .sort((a,b) => b-a)
            .map( a => a.split('.').map( n => +n-1000000 ).join('.') )
        )
      },
      exists2(versionTableRows,t,v,pV) {
        return(true);
      },
      exists(versionTableRows,t,v,pV) {
        var fittingRows = versionTableRows.filter((row) => row.tool == t && row.version == v && row.poseidonVersion == pV );
        return fittingRows.length > 0;
      },
      unique(value, index, array) {
        return array.indexOf(value) === index;
      }
    }
  }).mount('#versionFileViewer');
</script>

<div id="versionFileViewer">

<div v-if="versionTableRows">
    <table>
      <tbody>
      <tr v-for="tool in tools">
        <td>
          {{tool}}
        </td>
        <td>
          <table>
            <thead>
              <tr>
                <th v-for="poseidonVersion in poseidonVersions">{{poseidonVersion}}<th>
              <tr>
            </thead>
            <tbody>
              <tr v-for="version in versionsPerTool[tools.findIndex((t) => t == tool)]">
                <td v-for="poseidonVersion in poseidonVersions">
                  <div v-if="exists(versionTableRows,tool,version,poseidonVersion)">
                    test
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else><i>...fetching data from GitHub</i></div>

</div>

There is no documented version history before Poseidon v2.4.0.
