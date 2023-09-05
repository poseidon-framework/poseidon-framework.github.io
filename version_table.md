# Version overview table

The following figure documents which versions of the Poseidon standard (columns) are compatible with which versions of the software tools (rows).

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
      //console.log(this.versionsPerTool)
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
            .filter(this.unique)
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
    <table class="table-default">
      <tbody class="table-body">
      <tr v-for="tool in tools" style="background: none;">
        <td style="vertical-align: top; text-align: left; padding-top: 30px; writing-mode: vertical-rl; font-size: 25px;">
          {{tool}}
        </td>
        <td>
          <table class="table-default">
            <thead>
              <tr style="background: none;">
                <th>v</th>
                <th v-for="poseidonVersion in poseidonVersions">{{poseidonVersion}}<th>
              <tr>
            </thead>
            <tbody>
              <tr v-for="version in versionsPerTool[tools.findIndex((t) => t == tool)]">
                <td>{{version}}</td>
                <td v-for="poseidonVersion in poseidonVersions">
                  <div v-if="exists(versionTableRows,tool,version,poseidonVersion)">
                    ✅
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

<style>
  .table-default {
    width: 100%;
    display: table !important;
  }
  .table-default thead {
    width: 100%;
  } 
  .table-default tbody {
    width: 100%;
  } 
  .table-default tr {
    width: 100%;
    line-height: 8px !important;
  }
  .table-default th {
    text-align: center !important;
  }
  .table-default td {
    text-align: center;
  }
</style>

There is no documented version history before Poseidon v2.4.0.
