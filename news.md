# News

Follow us on <a href=https://ecoevo.social/@poseidon>Mastodon <i class="fab fa-mastodon" aria-hidden="true"></i></a> or via <a href=https://ecoevo.social/@poseidon.rss>RSS <i class="fa fa-rss" aria-hidden="true"></i></a>

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
        const itemArray = Array.from(items).slice(0, 30);
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
    <ul class="grid-container">
      <div class="news-grid-element" v-for="toot in toots">
        <div class="news-small-text"><i class="fab fa-mastodon" aria-hidden="true"></i> {{toot.date}} | <a :href=toot.link>{{toot.link}}</a></div>
        <div v-html="toot.description"></div>
      </div>
    </ul>
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
    padding-bottom: 0px;
    overflow-wrap: break-word;
    margin-bottom: 10px;
  }
  .news-small-text{
    font-size: 10px;
  }
</style>