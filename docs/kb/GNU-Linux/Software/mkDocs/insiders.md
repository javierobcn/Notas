---
template: overrides/main.html
---

# <span hidden>Insiders</span> :logo: :material-plus: :octicons-heart-fill-24:{: .tx-heart }

Material for MkDocs uses the [sponsorware][1] release strategy, which means
that _new features are first exclusively released to sponsors_ as part of
__Material for MkDocs Insiders__. Read on to learn [how sponsorship works][2],
and how you can [become a sponsor][3].

  [1]: https://github.com/sponsorware/docs
  [2]: #how-sponsorship-works
  [3]: #how-to-become-a-sponsor

<div style="width:100%;height:0px;position:relative;padding-bottom:56.138%;">
  <iframe src="https://streamable.com/e/b6ij21" frameborder="0" width="100%" height="100%" allowfullscreen style="width:100%;height:100%;position:absolute;left:0px;top:0px;overflow:hidden;"></iframe>
</div>
<p style="text-align: center; font-style: oblique">
  A demo is worth a thousand words — check it out at<br />
  <a href="https://squidfunk.github.io/mkdocs-material-insiders/">
    squidfunk.github.io/mkdocs-material-insiders
  </a>
</p>

## How sponsorship works

New features will first land in Material for MkDocs Insiders, which means that
_sponsors will have access immediately_. Every feature is tied to a funding
goal in monthly subscriptions. If a funding goal is hit, the features that are
tied to it are merged back into Material for MkDocs and released for general
availability. Bugfixes will always be released simultaneously in both editions.

See the [roadmap][4] for a list of already available and upcoming features, and
for demonstration purposes, [the official documentation][5] built with Material
for MkDocs Insiders.

  [4]: #roadmap
  [5]: https://squidfunk.github.io/mkdocs-material-insiders/

<div class="tx-sponsor" hidden>
  <h3>Join <span class="tx-sponsor__count"></span> awesome sponsors</h3>
  <div class="tx-sponsor__list"></div>
  <p>
    You can sponsor publicly or privately. As a public sponsor, you'll be listed
    here with your GitHub avatar, showing your support for Material for MkDocs!
  </p>
  <a class="md-button md-button--primary" href="https://github.com/sponsors/squidfunk">
    <span class="twemoji tx-heart"> <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24"><path d="M14 20.408c-.492.308-.903.546-1.192.709-.153.086-.308.17-.463.252h-.002a.75.75 0 01-.686 0 16.709 16.709 0 01-.465-.252 31.147 31.147 0 01-4.803-3.34C3.8 15.572 1 12.331 1 8.513 1 5.052 3.829 2.5 6.736 2.5 9.03 2.5 10.881 3.726 12 5.605 13.12 3.726 14.97 2.5 17.264 2.5 20.17 2.5 23 5.052 23 8.514c0 3.818-2.801 7.06-5.389 9.262A31.146 31.146 0 0114 20.408z"></path></svg> </span> &nbsp; Become a sponsor
  </a>
</div>
<script>
  fetch("https://gpiqp43wvb.execute-api.us-east-1.amazonaws.com/_/").then(function(e){return e.json()}).then(function(e){var t=document.querySelector(".tx-sponsor__list"),n=0;for(var o of e.sponsors)if("PUBLIC"===o.type){var s;(s=document.createElement("a")).href=o.url,s.title="@"+o.name,s.className="tx-sponsor__item",t.appendChild(s);var r=document.createElement("img");r.src=o.image,s.appendChild(r)}else n++;(s=document.createElement("a")).href="https://github.com/sponsors/squidfunk",s.title="[private]",s.innerText="+"+n,s.className="tx-sponsor__item tx-sponsor__item--private",t.appendChild(s),document.querySelector(".tx-sponsor__count").innerText=e.sponsors.length,document.querySelector(".tx-sponsor").removeAttribute("hidden")}).catch(console.log);
</script>
<style>
  .tx-sponsor {
    margin: 2em 0;
  }
  .tx-sponsor .md-button {
    background-color: #e91e63;
    border-color: #e91e63;
  }
  .tx-sponsor__list {
    overflow: auto;
  }
  .tx-sponsor__item {
    display: block;
    float: left;
    width: 3.2rem;
    height: 3.2rem;
    margin: 0.1rem;
    border-radius: 100%;
    overflow: hidden;
  }
  .tx-sponsor__item img {
    display: block;
    width: 100%;
    height: auto;
  }
  .md-typeset .tx-sponsor__item--private {
    background: #CCC;
    color: #666;
    font-size: 1.2rem;
    line-height: 3.2rem;
    text-align: center;
    font-weight: bold;
  }
</style>

## How to become a sponsor

So you've decided to become a sponsor? Great! You're just __three easy steps__
away from enjoying the latest features of Material for MkDocs Insiders.
Complete the following steps and you're in:

- Visit [squidfunk's sponsor profile][6] and pick a tier that includes exclusive
  access to squidfunk's sponsorware, which is _any tier from $10/month_. Select
  the tier and complete the checkout.
- Within 24 hours, you will become a collaborator of the private Material for
  MkDocs Insiders GitHub repository, a fork of Material for MkDocs with
  [brand new and exclusive features][7].
- Create a [personal access token][8], which allows installing Material for
  MkDocs Insiders from any destination, including other CI providers like
  [GitLab][9] or [Bitbucket][10].

__Congratulations! :partying_face: You're now officially a sponsor and will
get updates for Material for MkDocs Insiders, until you decide to cancel your
monthly subscription, which you can do at any time.__

  [6]: https://github.com/sponsors/squidfunk
  [7]: #available-features
  [8]: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token
  [9]: https://gitlab.com
  [10]: https://bitbucket.org

## Available features

The following list shows which features are currently only available in Material
for MkDocs Insiders. You can click on each feature to learn more about it:

- [x] [Remove _Made with Material for MkDocs_ from footer][11]
- [x] [Support for user-toggleable themes (light/dark mode switch)][12]
- [x] [Support for deploying multiple versions][13]
- [x] [Support for deploying multiple languages][22]
- [x] [Search suggestions help to save keystrokes][14]
- [x] [Highlighting of matched search terms in content area][15]
- [x] Search goes to first result on ++enter++ (I'm feeling lucky)
- [x] [Navigation can be grouped into sections][16]
- [x] [Navigation can be always expanded][17]
- [x] [Navigation and table of contents can be hidden][18]
- [x] [Table of contents can be integrated into navigation][19]
- [x] [Header can be automatically hidden on scrolling][20]
- [x] [Support for Admonitions as inline blocks][21]

  [11]: setup/setting-up-the-footer.md#remove-generator
  [12]: setup/changing-the-colors.md#color-palette-toggle
  [13]: setup/setting-up-versioning.md#versioning
  [14]: setup/setting-up-site-search.md#search-suggestions
  [15]: setup/setting-up-site-search.md#search-highlighting
  [16]: setup/setting-up-navigation.md#navigation-sections
  [17]: setup/setting-up-navigation.md#navigation-expansion
  [18]: setup/setting-up-navigation.md#hide-the-sidebars
  [19]: setup/setting-up-navigation.md#navigation-integration
  [20]: setup/setting-up-the-header.md#automatic-hiding
  [21]: reference/admonitions.md#inline-blocks
  [22]: setup/changing-the-language.md#site-language-selector

## Roadmap

The following list of funding goals – named after varieties of chili peppers 
[I'm growing on my balcony][23] – shows which features are already available
in Material for MkDocs Insiders.

  [23]: https://www.instagram.com/squidfunk/

### Madame Jeanette

[:octicons-flame-24: Funding goal: __$500__][6] ·
:octicons-unlock-24: Status: _Generally available_

- [x] Improved search result grouping (pages + headings)
- [x] Improved search result relevance and scoring
- [x] Display of missing query terms in search results

### Prairie Fire

[:octicons-flame-24: Funding goal: __$1,000__][6] ·
:octicons-lock-24: Status: _Insiders only_

- [x] [Navigation can be grouped into sections][16]
- [x] [Navigation can be always expanded][17]
- [x] [Navigation and table of contents can be hidden][18]
- [x] [Table of contents can be integrated into navigation][19]
- [x] [Header can be automatically hidden on scrolling][20]

### Bhut Jolokia

[:octicons-flame-24: Funding goal: __$1,500__][6] ·
:octicons-lock-24: Status: _Insiders only_

- [x] [Support for Admonitions as inline blocks][21]
- [x] [Support for deploying multiple versions][13]
- [x] [Support for deploying multiple languages][22]

### Black Pearl

[:octicons-flame-24: Funding goal: __$2,000__][6] ·
:octicons-lock-24: Status: _Insiders only_

- [x] [Support for user-toggleable themes (light/dark mode switch)][12]
- [ ] Support for user-toggleable code-block styles (light/dark mode switch)
- [ ] Table of contents auto-collapses and expands only the active section

### Biquinho Vermelho

[:octicons-flame-24: Funding goal: __$2,500__][6] ·
:octicons-lock-24: Status: _Insiders only_

- [x] [Search suggestions help to save keystrokes][14]
- [x] [Highlighting of matched search terms in content area][15]
- [x] Search goes to first result on ++enter++ (I'm feeling lucky)
- [ ] Table of contents shows which sections have search results
- [ ] Support for displaying a user's last searches
- [ ] Improved search result summaries

### Caribbean Red

[:octicons-flame-24: Funding goal: __$3,000__][6] ·
:octicons-lock-24: Status: _Insiders only_

- [x] [Remove _Made with Material for MkDocs_ from footer][11]
- [ ] Brand-new and exclusive vertical layout

## Frequently asked questions

### Compatibility

_We're running an open source project and want to make sure that users can build
the documentation without having access to Insiders. Is that still possible?_

Yes. Material for MkDocs Insiders strives to be compatible with Material for
MkDocs, so all new features are implemented as feature flags and all
improvements (e.g. search) do not require any changes to existing configuration.
This means that your users will be able to build the docs locally with the
regular version and when they push their changes to CI/CD, they will be built
with Material for MkDocs Insiders. For this reason, it's recommended to
[install Insiders][24] only in CI, as you don't want to expose your `GH_TOKEN`
to users.

  [24]: publishing-your-site.md#github-pages

### Terms

_We're using Material for MkDocs to build the developer documentation of a
commercial project. Can we use Material for MkDocs Insiders under the same
terms?_

Yes. Whether you're an individual or a company, you may use _Material for MkDocs
Insiders_ precisely under the same terms as Material for MkDocs, which are given
by the [MIT license][25]. However, we kindly ask you to respect the following
guidelines:

- Please __don't distribute the source code__ from Material for MkDocs Insiders.
  You may freely use it for public, private or commercial projects, fork it,
  mirror it, do whatever you want with it, but please don't release the source
  code, as it would cannibalize the sponsorware strategy.

- If you cancel your subscription, you're removed as a collaborator and will
  miss out on future updates of Material for MkDocs Insiders. However, you may
  __use the latest version__ that's available to you __as long as you like__.
  Just remember that __[GitHub deletes private forks][26]__.

  [25]: license.md
  [26]: https://docs.github.com/en/github/setting-up-and-managing-your-github-user-account/removing-a-collaborator-from-a-personal-repository
