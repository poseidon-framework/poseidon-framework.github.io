![poseidon banner with logo](_media/Poseidon-Logo-WaterGraphicLrg.png)

<center>
<b>Poseidon is a framework to work with human aDNA data and its archaeological context information.</b>
</center>

<div id="landingPageButtonsOuter">
  <div id="landingPageButtonsInner">
    <button onclick="window.open(
      '#/background',
      '_blank');;"
      class="button">
      <span>
        <i class="fa fa-question-circle" aria-hidden="true"></i> Why?
      </span>
    </button>
    <button onclick="window.open(
      '#/getting_started',
      '_blank');;"
      class="button">
      <span style="color: #7CFC00">
        <i class="fa fa-play-circle" aria-hidden="true"></i> Quick start guide
      </span>
    </button>
    &nbsp;
    <button onclick="window.open(
      'https://join.slack.com/t/poseidon-8el7276/shared_invite/zt-14q2wxxmf-pbtNtm5E9DFJbjioyfAyMg',
      '_blank');;"
      class="button">
      <span>
        <i class="fab fa-slack" aria-hidden="true"></i> Slack
      </span>
    </button>
    <button onclick="window.open(
      'https://github.com/poseidon-framework',
      '_blank');;"
      class="button">
      <span>
        <i class="fab fa-github" aria-hidden="true"></i> GitHub
      </span>
    </button>
    <button onclick="window.open(
      'https://ecoevo.social/@poseidon',
      '_blank');;"
      class="button">
      <span>
        <i class="fab fa-mastodon" aria-hidden="true"></i> Mastodon
      </span>
    </button>
  </div>
</div>

<style>
  #landingPageButtonsOuter {
    width:100%
  }
  #landingPageButtonsInner {
    display: table;
    margin: 0 auto;
  }
  .button {
    color: white;
    background-color: #555555;
    border: 1px solid;
    border-color: grey;
    padding: 8px 15px;
    text-align: center;
    margin: 4px 2px;
    cursor: pointer;
    transition: all 0.5s;
  }
  .button span {
    cursor: pointer;
    display: inline-block;
    position: relative;
    transition: 0.5s;
  }
  .button span:after {
    content: '\00bb';
    position: absolute;
    opacity: 0;
    top: 0;
    right: -20px;
    transition: 0.5s;
  }
  .button:hover span {
    padding-right: 25px;
  }
  .button:hover span:after {
    opacity: 1;
    right: 0;
  }
</style>

<br>

<div class="grid-container">
  <div class="grid-element">
    <div class="grid-symbol"><i class="fas fa-clipboard-list" aria-hidden="true"></i></div>
    Poseidon provides a standardized <b>package format</b> for genotype and context data
    <ul>
      <li>The Poseidon <a href="#standard">package standard</a></li>
      <li>How we define and store <a href="#genotype_data">genotype data</a></li>
      <li>How we include context data in the <a href="#janno_details">.janno file</a></li>
      <li>How we reference raw sequencing data with the <a href="#ssf_details">.ssf file</a></li>
    </ul> 
  </div>
  <div class="grid-element">
    <div class="grid-symbol"><i class="fas fa-tools" aria-hidden="true"></i></div>
    Poseidon includes <b>software tools</b> to work with Poseidon packages
    <ul>
      <li>The <a href="#trident">trident</a> CLI software for data management</li>
      <li>The <a href="#xerxes">xerxes</a> CLI software for data analysis</li>
      <li>The <a href="#qjanno">qjanno</a> CLI software for querying .janno files with SQL statements</li>
      <li>The <a href="#janno_r_package">janno</a> package for handling .janno files in R</li>
    </ul>
  </div>
  <div class="grid-element">
    <div class="grid-symbol"><i class="fas fa-download" aria-hidden="true"></i></div>
    Poseidon features publicly hosted and curated <b>package archives</b> of published data
    <ul>
      <li>A <a href="#archive_overview">guide</a> explains the repositories</li>
      <li>And how to <a href="#archive_submission_guide">contribute data</a></li>
      <li>Our server software provides an open <a href="#web_api">Web-API</a> to access packages</li>
      <li style="color: #7CFC00">Which enables an <a href="https://poseidon-framework.github.io/community-archive">overview and download</a> page to browse the archives</li>
    </ul>
  </div>
</div>

<style>
  .grid-container{
    display: grid;
    grid-template-columns: repeat( auto-fit, minmax(250px, 1fr) );
    grid-gap: 10px;
  }
  .grid-element{
    background-color: #555555;
    border: 1px solid;
    border-color: grey;
    text-align: left;
    padding: 15px;
  }
  .grid-symbol {
    text-align: center;
    font-size: 30px;
  }
</style>

<br>

<script>
  Vue.createApp({
    data () {
     return {
        toots: null
      }
    },
    async mounted () {
      const rssResponse = await fetch(
        "https://ecoevo.social/@poseidon.rss"
      );
      const rssData = await rssResponse.text();
      this.toots = this.parseRSS(rssData);
    },
    methods: {
      parseRSS(xmlString) {
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(xmlString, 'text/xml');
        const items = xmlDoc.querySelectorAll('item');
        const itemArray = Array.from(items).slice(0, 9);
        const parsedItems = [];
        itemArray.forEach((item) => {
          const dateElement = item.querySelector('pubDate');
          const linkElement = item.querySelector('link');
          const descriptionElement = item.querySelector('description');
          if (dateElement && linkElement && descriptionElement) {
            const date = dateElement.textContent;
            const link = linkElement.textContent;
            const description = descriptionElement.textContent;
            parsedItems.push({
              date,
              link,
              description,
            });
          }
        });

        return parsedItems;
      }
    }
  }).mount('#tootViewer');
</script>

<div id="tootViewer">

  <div v-if="toots">
    <div class="grid-container">
      <div class="news-grid-element" v-for="toot in toots">
        <div class="news-small-text"><i class="fab fa-mastodon" aria-hidden="true"></i> {{toot.date}}</div>
        <div class="news-small-text"><a :href=toot.link> {{toot.link}}</a></div>
        <div v-html="toot.description"></div>
      </div>
    </div>
  </div>
  
  <div v-else><i>..fetching data from ecoevo.social</i></div>

</div>

<style>
  .news-grid-element{
    border-radius: 25px;
    border: 1px solid;
    border-color: grey;
    text-align: left;
    padding: 15px;
    overflow-wrap: break-word;
  }
  .news-small-text{
    font-size: 10px;
  }
</style>