![poseidon banner with logo](_media/Poseidon-Logo-WaterGraphicLrg.png)

**Poseidon is a framework offering a standardized way to store and share human archaeogenetic genotype datasets with archaeological context information.** It aims to [fill a desideratum](background.md) in the current handling of research data.

?> New here? Check out our [Getting Started Guide](getting_started.md)

<div id="landingPageButtonsOuter">
  <div id="landingPageButtonsInner">
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
      <li style="color: #7CFC00">Which enables an <a href="archive_explorer">overview and download</a> page to browse the archives</li>
    </ul>
  </div>
</div>


