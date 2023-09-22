# News

Follow us on [Mastodon](https://ecoevo.social/@poseidon)

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
      <li class="news-grid-element" v-for="toot in toots">
        <div class="news-small-text"><i class="fab fa-mastodon" aria-hidden="true"></i> {{toot.date}}</div>
        <div class="news-small-text"><a :href=toot.link> {{toot.link}}</a></div>
        <div v-html="toot.description"></div>
      </li>
    </ul>
  </div>
  
  <div v-else><i>..fetching data from ecoevo.social</i></div>

</div>
