# Version overview table

The following figure documents which versions of the Poseidon standard are compatible with which versions of the software tools. Newer versions of `trident` can generally still read older packages, when no [breaking changes](changelog.md) were introduced.

<script>
  Vue.createApp({
    data () {
     return {
        versionTableRows: null,
        tools: null,
        poseidonVersions: null
      }
    },
    async mounted () {
      const response = await fetch(
        "https://raw.githubusercontent.com/poseidon-framework/poseidon-framework.github.io/master/version_table_figure/version_table.tsv"
      );
      const versionTableTSVData = await response.text();
      this.versionTableRows = this.parseTSV(versionTableTSVData);
      this.tools = this.versionTableRows.map((row) => row.tool).filter((x, i, a) => a.indexOf(x) == i).sort()
      this.poseidonVersions = this.versionTableRows.map((row) => row.poseidonVersion).filter((x, i, a) => a.indexOf(x) == i).sort()
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
      }
    }
  }).mount('#versionFileViewer');
</script>

<div id="versionFileViewer">

<div v-if="versionTableRows">
    <table>
      <thead>
        <tr>
        	<th>tool</th>
        	<th v-for="poseidonVersion in poseidonVersions">{{poseidonVersion}}<th>
        </tr>
      </thead>
      <tbody>
      <tr v-for="versionTableRow in versionTableRows">
<!--         <td>
          <div style="max-width: 15ch;word-wrap:break-word;">
            {{ymlDefFileRow.field}}<sup v-if="ymlDefFileRow.mandatory == 'TRUE'">*</sup>
          </div>
        </td>
        <td>
          <div>
            {{ymlDefFileRow.description}}
          </div>
          <div v-if="ymlDefFileRow.parent">
            <u>subfield of:</u> {{ymlDefFileRow.parent}}
          </div>
          <div v-if="ymlDefFileRow.type">
            <u>type:</u> {{ymlDefFileRow.type}}
          </div>
          <div v-if="ymlDefFileRow.format">
            <u>format:</u> {{ymlDefFileRow.format}}
          </div>
        </td> -->
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else><i>...fetching data from GitHub</i></div>

</div>

There is no documented version history before Poseidon v2.4.0.
