---
template: overrides/main.html
---

# Upgrading

Upgrade to the latest version with:

```
pip install --upgrade mkdocs-material
```

Inspect the currently installed version with:

```
pip show mkdocs-material
```

## Upgrading from 5.x to 6.x

### What's new?

- Improved search result look and feel
- Improved search result stability while typing
- Improved search result grouping (pages + headings)
- Improved search result relevance and scoring
- Added display of missing query terms to search results
- Reduced size of vendor bundle by 25% (84kb → 67kb)
- Reduced size of the Docker image to improve CI build performance
- Removed hero partial in favor of [custom implementation][1]
- Removed [deprecated front matter features][2]

  [1]: deprecations.md#hero
  [2]: deprecations.md#front-matter

### Changes to `mkdocs.yml`

Following is a list of changes that need to be made to `mkdocs.yml`. Note that
you only have to adjust the value if you defined it, so if your configuration
does not contain the key, you can skip it.

#### `theme.features`

All feature flags that can be set from `mkdocs.yml`, like [tabs][3] and
[instant loading][4], are now prefixed with the name of the component or
function they apply to, e.g. `navigation.*`:

=== "6.x"

    ``` yaml
    theme:
      features:
        - navigation.tabs
        - navigation.instant
    ```

=== "5.x"

    ``` yaml
    theme:
      features:
        - tabs
        - instant
    ```

  [3]: setup/setting-up-navigation.md#navigation-tabs
  [4]: setup/setting-up-navigation.md#instant-loading

### Changes to `*.html` files

The templates have undergone a set of changes to make them future-proof. If
you've used theme extension to override a block or template, make sure that it
matches the new structure:

- If you've overridden a __block__, check `base.html` for potential changes
- If you've overridden a __template__, check the respective `*.html` file for
  potential changes

??? quote "`base.html`"

    ``` diff
    @@ -22,13 +22,6 @@

    {% import "partials/language.html" as lang with context %}

    -<!-- Theme options -->
    -{% set palette = config.theme.palette %}
    -{% if not palette is mapping %}
    -  {% set palette = palette | first %}
    -{% endif %}
    -{% set font = config.theme.font %}
    -
    <!doctype html>
    <html lang="{{ lang.t('language') }}" class="no-js">
      <head>
    @@ -45,21 +38,8 @@
            <meta name="description" content="{{ config.site_description }}" />
          {% endif %}

    -      <!-- Redirect -->
    -      {% if page and page.meta and page.meta.redirect %}
    -        <script>
    -          var anchor = window.location.hash.substr(1)
    -          location.href = '{{ page.meta.redirect }}' +
    -            (anchor ? '#' + anchor : '')
    -        </script>
    -
    -        <!-- Fallback in case JavaScript is not available -->
    -        <meta http-equiv="refresh" content="0; url={{ page.meta.redirect }}" />
    -        <meta name="robots" content="noindex" />
    -        <link rel="canonical" href="{{ page.meta.redirect }}" />
    -
          <!-- Canonical -->
    -      {% elif page.canonical_url %}
    +      {% if page.canonical_url %}
            <link rel="canonical" href="{{ page.canonical_url }}" />
          {% endif %}

    @@ -96,20 +76,21 @@
          <link rel="stylesheet" href="{{ 'assets/stylesheets/main.css' | url }}" />

          <!-- Extra color palette -->
    -      {% if palette.scheme or palette.primary or palette.accent %}
    +      {% if config.theme.palette %}
    +        {% set palette = config.theme.palette %}
            <link
              rel="stylesheet"
              href="{{ 'assets/stylesheets/palette.css' | url }}"
            />
    -      {% endif %}

    -      <!-- Theme-color meta tag for Android -->
    -      {% if palette.primary %}
    -        {% import "partials/palette.html" as map %}
    -        {% set primary = map.primary(
    -          palette.primary | replace(" ", "-") | lower
    -        ) %}
    -        <meta name="theme-color" content="{{ primary }}" />
    +        <!-- Theme-color meta tag for Android -->
    +        {% if palette.primary %}
    +          {% import "partials/palette.html" as map %}
    +          {% set primary = map.primary(
    +            palette.primary | replace(" ", "-") | lower
    +          ) %}
    +          <meta name="theme-color" content="{{ primary }}" />
    +        {% endif %}
          {% endif %}
        {% endblock %}

    @@ -120,7 +101,8 @@
        {% block fonts %}

          <!-- Load fonts from Google -->
    -      {% if font != false %}
    +      {% if config.theme.font != false %}
    +        {% set font = config.theme.font %}
            <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin />
            <link
              rel="stylesheet"
    @@ -169,8 +151,12 @@

      <!-- Text direction and color palette, if defined -->
      {% set direction = config.theme.direction or lang.t('direction') %}
    -  {% if palette.scheme or palette.primary or palette.accent %}
    -    {% set scheme  = palette.scheme | lower %}
    +  {% if config.theme.palette %}
    +    {% set palette = config.theme.palette %}
    +    {% if not palette is mapping %}
    +      {% set palette = palette | first %}
    +    {% endif %}
    +    {% set scheme  = palette.scheme  | replace(" ", "-") | lower %}
        {% set primary = palette.primary | replace(" ", "-") | lower %}
        {% set accent  = palette.accent  | replace(" ", "-") | lower %}
        <body
    @@ -179,18 +165,19 @@
          data-md-color-primary="{{ primary }}"
          data-md-color-accent="{{ accent }}"
        >
    +
    +      <!-- Experimental: set color scheme based on preference -->
    +      {% if "preference" == scheme %}
    +        <script>
    +          if (matchMedia("(prefers-color-scheme: dark)").matches)
    +            document.body.setAttribute("data-md-color-scheme", "slate")
    +        </script>
    +      {% endif %}
    +
      {% else %}
        <body dir="{{ direction }}">
      {% endif %}

    -    <!-- Experimental: set color scheme based on preference -->
    -    {% if "preference" == palette.scheme %}
    -      <script>
    -        if (matchMedia("(prefers-color-scheme: dark)").matches)
    -          document.body.setAttribute("data-md-color-scheme", "slate")
    -      </script>
    -    {% endif %}
    -
        <!--
          State toggles - we need to set autocomplete="off" in order to reset the
          drawer on back button invocation in some browsers
    @@ -243,15 +230,11 @@
        <div class="md-container" data-md-component="container">

          <!-- Hero teaser -->
    -      {% block hero %}
    -        {% if page and page.meta and page.meta.hero %}
    -          {% include "partials/hero.html" with context %}
    -        {% endif %}
    -      {% endblock %}
    +      {% block hero %}{% endblock %}

          <!-- Tabs navigation -->
          {% block tabs %}
    -        {% if "tabs" in config.theme.features %}
    +        {% if "navigation.tabs" in config.theme.features %}
              {% include "partials/tabs.html" %}
            {% endif %}
          {% endblock %}
    @@ -310,13 +293,6 @@
                      </a>
                    {% endif %}

    -                <!-- Link to source file -->
    -                {% block source %}
    -                  {% if page and page.meta and page.meta.source %}
    -                    {% include "partials/source-link.html" %}
    -                  {% endif %}
    -                {% endblock %}
    -
                    <!--
                      Hack: check whether the content contains a h1 headline. If it
                      doesn't, the page title (or respectively site name) is used
    @@ -370,7 +346,10 @@
            "search.result.placeholder",
            "search.result.none",
            "search.result.one",
    -        "search.result.other"
    +        "search.result.other",
    +        "search.result.more.one",
    +        "search.result.more.other",
    +        "search.result.term.missing"
          ] -%}
            {%- set _ = translations.update({ key: lang.t(key) }) -%}
          {%- endfor -%}
    ```

??? quote "`partials/hero.html`"

    ``` diff
    @@ -1,12 +0,0 @@
    -{#-
    -  This file was automatically generated - do not edit
    --#}
    -{% set class = "md-hero" %}
    -{% if "tabs" not in config.theme.features %}
    -  {% set class = "md-hero md-hero--expand" %}
    -{% endif %}
    -<div class="{{ class }}" data-md-component="hero">
    -  <div class="md-hero__inner md-grid">
    -    {{ page.meta.hero }}
    -  </div>
    -</div>
    ```

??? quote "`partials/source-link`"

    ``` diff
    -{#-
    -  This file was automatically generated - do not edit
    --#}
    -{% import "partials/language.html" as lang with context %}
    -{% set repo = config.repo_url %}
    -{% if repo | last == "/" %}
    -  {% set repo = repo[:-1] %}
    -{% endif %}
    -{% set path = page.meta.path | default("") %}
    -<a href="{{ [repo, path, page.meta.source] | join('/') }}" title="{{ page.meta.source }}" class="md-content__button md-icon">
    -  {{ lang.t("meta.source") }}
    -  {% set icon = config.theme.icon.repo or "fontawesome/brands/git-alt" %}
    -  {% include ".icons/" ~ icon ~ ".svg" %}
    -</a>
    ```

## Upgrading from 4.x to 5.x

### What's new?

- Reactive architecture – try `#!js app.dialog$.next("Hi!")` in the console
- [Instant loading][4] – make Material behave like a Single Page Application
- Improved CSS customization with [CSS variables][5] – set your brand's colors
- Improved CSS resilience, e.g. proper sidebar locking for customized headers
- Improved [icon integration][6] and configuration – now including over 5k icons
- Added possibility to use any icon for logo, repository and social links
- Search UI does not freeze anymore (moved to web worker)
- Search index built only once when using instant loading
- Improved extensible keyboard handling
- Support for [prebuilt search indexes][7]
- Support for displaying stars and forks for GitLab repositories
- Support for scroll snapping of sidebars and search results
- Reduced HTML and CSS footprint due to deprecation of Internet Explorer support
- Slight facelifting of some UI elements (Admonitions, tables, ...)

  [5]: setup/changing-the-colors.md#custom-colors
  [6]: setup/changing-the-logo-and-icons.md#icons
  [7]: setup/setting-up-site-search.md#built-in-search

### Changes to `mkdocs.yml`

Following is a list of changes that need to be made to `mkdocs.yml`. Note that
you only have to adjust the value if you defined it, so if your configuration
does not contain the key, you can skip it.

#### `theme.feature`

Optional features like [tabs][3] and [instant loading][4] are now implemented as
flags and can be enabled by listing them in `mkdocs.yml` under `theme.features`:

=== "5.x"

    ``` yaml
    theme:
      features:
        - tabs
        - instant
    ```

=== "4.x"

    ``` yaml
    theme:
      feature:
        tabs: true
    ```

#### `theme.logo.icon`

The logo icon configuration was centralized under `theme.icon.logo` and can now
be set to any of the [icons bundled with the theme][3]:

=== "5.x"

    ``` yaml
    theme:
      icon:
        logo: material/cloud
    ```

=== "4.x"

    ``` yaml
    theme:
      logo:
        icon: cloud
    ```

#### `extra.repo_icon`

The repo icon configuration was centralized under `theme.icon.repo` and can now
be set to any of the [icons bundled with the theme][3]:

=== "5.x"

    ``` yaml
    theme:
      icon:
        repo: fontawesome/brands/gitlab
    ```

=== "4.x"

    ``` yaml
    extra:
      repo_icon: gitlab
    ```

#### `extra.search.*`

Search is now configured as part of the [plugin options][6]. Note that the
search languages must now be listed as an array of strings and the `tokenizer`
was renamed to `separator`:

=== "5.x"

    ``` yaml
    plugins:
      - search:
          separator: '[\s\-\.]+'
          lang:
            - en
            - de
            - ru
    ```

=== "4.x"

    ``` yaml
    extra:
      search:
        language: en, de, ru
        tokenizer: '[\s\-\.]+'
    ```

  [6]: setup/setting-up-site-search.md#built-in-search

#### `extra.social.*`

Social links stayed in the same place, but the `type` key was renamed to `icon`
in order to match the new way of specifying which icon to be used:

=== "5.x"

    ``` yaml
    extra:
      social:
        - icon: fontawesome/brands/github-alt
          link: https://github.com/squidfunk
    ```

=== "4.x"

    ``` yaml
    extra:
      social:
        - type: github
          link: https://github.com/squidfunk
    ```

### Changes to `*.html` files

The templates have undergone a set of changes to make them future-proof. If
you've used theme extension to override a block or template, make sure that it 
matches the new structure:

- If you've overridden a __block__, check `base.html` for potential changes
- If you've overridden a __template__, check the respective `*.html` file for
  potential changes

??? quote "`base.html`"

    ``` diff
    @@ -2,7 +2,6 @@
      This file was automatically generated - do not edit
    -#}
    {% import "partials/language.html" as lang with context %}
    -{% set feature = config.theme.feature %}
    {% set palette = config.theme.palette %}
    {% set font = config.theme.font %}
    <!doctype html>
    @@ -30,19 +29,6 @@
          {% elif config.site_author %}
            <meta name="author" content="{{ config.site_author }}">
          {% endif %}
    -      {% for key in [
    -        "clipboard.copy",
    -        "clipboard.copied",
    -        "search.language",
    -        "search.pipeline.stopwords",
    -        "search.pipeline.trimmer",
    -        "search.result.none",
    -        "search.result.one",
    -        "search.result.other",
    -        "search.tokenizer"
    -      ] %}
    -        <meta name="lang:{{ key }}" content="{{ lang.t(key) }}">
    -      {% endfor %}
          <link rel="shortcut icon" href="{{ config.theme.favicon | url }}">
          <meta name="generator" content="mkdocs-{{ mkdocs_version }}, mkdocs-material-5.0.0">
        {% endblock %}
    @@ -56,9 +42,9 @@
          {% endif %}
        {% endblock %}
        {% block styles %}
    -      <link rel="stylesheet" href="{{ 'assets/stylesheets/application.********.css' | url }}">
    +      <link rel="stylesheet" href="{{ 'assets/stylesheets/main.********.min.css' | url }}">
          {% if palette.primary or palette.accent %}
    -        <link rel="stylesheet" href="{{ 'assets/stylesheets/application-palette.********.css' | url }}">
    +        <link rel="stylesheet" href="{{ 'assets/stylesheets/palette.********.min.css' | url }}">
          {% endif %}
          {% if palette.primary %}
            {% import "partials/palette.html" as map %}
    @@ -69,20 +55,17 @@
          {% endif %}
        {% endblock %}
        {% block libs %}
    -      <script src="{{ 'assets/javascripts/modernizr.********.js' | url }}"></script>
        {% endblock %}
        {% block fonts %}
          {% if font != false %}
            <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
            <link rel="stylesheet" href="https://fonts.googleapis.com/css?family={{
                font.text | replace(' ', '+') + ':300,400,400i,700%7C' +
                font.code | replace(' ', '+')
              }}&display=fallback">
            <style>body,input{font-family:"{{ font.text }}","Helvetica Neue",Helvetica,Arial,sans-serif}code,kbd,pre{font-family:"{{ font.code }}","Courier New",Courier,monospace}</style>
          {% endif %}
        {% endblock %}
    -    <link rel="stylesheet" href="{{ 'assets/fonts/material-icons.css' | url }}">
        {% if config.extra.manifest %}
          <link rel="manifest" href="{{ config.extra.manifest | url }}" crossorigin="use-credentials">
        {% endif %}
    @@ -95,47 +77,50 @@
        {% endblock %}
        {% block extrahead %}{% endblock %}
      </head>
    +  {% set direction = config.theme.direction | default(lang.t('direction')) %}
      {% if palette.primary or palette.accent %}
        {% set primary = palette.primary | replace(" ", "-") | lower %}
        {% set accent  = palette.accent  | replace(" ", "-") | lower %}
    -    <body dir="{{ lang.t('direction') }}" data-md-color-primary="{{ primary }}" data-md-color-accent="{{ accent }}">
    +    <body dir="{{ direction }}" data-md-color-primary="{{ primary }}" data-md-color-accent="{{ accent }}">
      {% else %}
    -    <body dir="{{ lang.t('direction') }}">
    +    <body dir="{{ direction }}">
      {% endif %}
    -    <svg class="md-svg">
    -      <defs>
    -        {% set platform = config.extra.repo_icon or config.repo_url %}
    -        {% if "github" in platform %}
    -          {% include "assets/images/icons/github.f0b8504a.svg" %}
    -        {% elif "gitlab" in platform %}
    -          {% include "assets/images/icons/gitlab.6dd19c00.svg" %}
    -        {% elif "bitbucket" in platform %}
    -          {% include "assets/images/icons/bitbucket.1b09e088.svg" %}
    -        {% endif %}
    -      </defs>
    -    </svg>
        <input class="md-toggle" data-md-toggle="drawer" type="checkbox" id="__drawer" autocomplete="off">
        <input class="md-toggle" data-md-toggle="search" type="checkbox" id="__search" autocomplete="off">
    -    <label class="md-overlay" data-md-component="overlay" for="__drawer"></label>
    +    <label class="md-overlay" for="__drawer"></label>
    +    <div data-md-component="skip">
    +      {% if page.toc | first is defined %}
    +        {% set skip = page.toc | first %}
    +        <a href="{{ skip.url | url }}" class="md-skip">
    +          {{ lang.t('skip.link.title') }}
    +        </a>
    +      {% endif %}
    +    </div>
    +    <div data-md-component="announce">
    +      {% if self.announce() %}
    +        <aside class="md-announce">
    +          <div class="md-announce__inner md-grid md-typeset">
    +            {% block announce %}{% endblock %}
    +          </div>
    +        </aside>
    +      {% endif %}
    +    </div>
        {% block header %}
          {% include "partials/header.html" %}
        {% endblock %}
    -    <div class="md-container">
    +    <div class="md-container" data-md-component="container">
          {% block hero %}
            {% if page and page.meta and page.meta.hero %}
              {% include "partials/hero.html" with context %}
            {% endif %}
          {% endblock %}
    -      {% if feature.tabs %}
    -        {% include "partials/tabs.html" %}
    -      {% endif %}
    +      {% block tabs %}
    +        {% if "tabs" in config.theme.features %}
    +          {% include "partials/tabs.html" %}
    +        {% endif %}
    +      {% endblock %}
    -      <main class="md-main" role="main">
    -        <div class="md-main__inner md-grid" data-md-component="container">
    +      <main class="md-main" data-md-component="main">
    +        <div class="md-main__inner md-grid">
              {% block site_nav %}
                {% if nav %}
                  <div class="md-sidebar md-sidebar--primary" data-md-component="navigation">
    @@ -160,41 +141,25 @@
                <article class="md-content__inner md-typeset">
                  {% block content %}
                    {% if page.edit_url %}
    -                  <a href="{{ page.edit_url }}" title="{{ lang.t('edit.link.title') }}" class="md-icon md-content__icon">&#xE3C9;</a>
    +                  <a href="{{ page.edit_url }}" title="{{ lang.t('edit.link.title') }}" class="md-content__button md-icon">
    +                    {% include ".icons/material/pencil.svg" %}
    +                  </a>
                    {% endif %}
    +                {% block source %}
    +                  {% if page and page.meta and page.meta.source %}
    +                    {% include "partials/source-link.html" %}
    +                  {% endif %}
    +                {% endblock %}
                    {% if not "\x3ch1" in page.content %}
                      <h1>{{ page.title | default(config.site_name, true)}}</h1>
                    {% endif %}
                    {{ page.content }}
    -                {% block source %}
    -                  {% if page and page.meta and page.meta.source %}
    -                    <h2 id="__source">{{ lang.t("meta.source") }}</h2>
    -                    {% set repo = config.repo_url %}
    -                    {% if repo | last == "/" %}
    -                      {% set repo = repo[:-1] %}
    -                    {% endif %}
    -                    {% set path = page.meta.path | default([""]) %}
    -                    {% set file = page.meta.source %}
    -                    <a href="{{ [repo, path, file] | join('/') }}" title="{{ file }}" class="md-source-file">
    -                      {{ file }}
    -                    </a>
    -                  {% endif %}
    -                {% endblock %}
    +                {% if page and page.meta %}
    +                  {% if page.meta.git_revision_date_localized or
    +                        page.meta.revision_date
    +                  %}
    +                    {% include "partials/source-date.html" %}
    -                {% if page and page.meta and (
    -                      page.meta.git_revision_date_localized or
    -                      page.meta.revision_date
    -                ) %}
    -                  {% set label = lang.t("source.revision.date") %}
    -                  <hr>
    -                  <div class="md-source-date">
    -                    <small>
    -                      {% if page.meta.git_revision_date_localized %}
    -                        {{ label }}: {{ page.meta.git_revision_date_localized }}
    -                      {% elif page.meta.revision_date %}
    -                        {{ label }}: {{ page.meta.revision_date }}
    -                      {% endif %}
    -                    </small>
    -                  </div>
                    {% endif %}
                  {% endblock %}
                  {% block disqus %}
    @@ -208,29 +174,35 @@
            {% include "partials/footer.html" %}
          {% endblock %}
        </div>
        {% block scripts %}
    -      <script src="{{ 'assets/javascripts/application.********.js' | url }}"></script>
    -      {% if lang.t("search.language") != "en" %}
    -        {% set languages = lang.t("search.language").split(",") %}
    -        {% if languages | length and languages[0] != "" %}
    -          {% set path = "assets/javascripts/lunr/" %}
    -          <script src="{{ (path ~ 'lunr.stemmer.support.js') | url }}"></script>
    -          {% for language in languages | map("trim") %}
    -            {% if language != "en" %}
    -              {% if language == "ja" %}
    -                <script src="{{ (path ~ 'tinyseg.js') | url }}"></script>
    -              {% endif %}
    -              {% if language in ("ar", "da", "de", "es", "fi", "fr", "hu", "it", "ja", "nl", "no", "pt", "ro", "ru", "sv", "th", "tr", "vi") %}
    -                <script src="{{ (path ~ 'lunr.' ~ language ~ '.js') | url }}"></script>
    -              {% endif %}
    -            {% endif %}
    -          {% endfor %}
    -          {% if languages | length > 1 %}
    -            <script src="{{ (path ~ 'lunr.multi.js') | url }}"></script>
    -          {% endif %}
    -        {% endif %}
    -      {% endif %}
    -      <script>app.initialize({version:"{{ mkdocs_version }}",url:{base:"{{ base_url }}"}})</script>
    +      <script src="{{ 'assets/javascripts/vendor.********.min.js' | url }}"></script>
    +      <script src="{{ 'assets/javascripts/bundle.********.min.js' | url }}"></script>
    +      {%- set translations = {} -%}
    +      {%- for key in [
    +        "clipboard.copy",
    +        "clipboard.copied",
    +        "search.config.lang",
    +        "search.config.pipeline",
    +        "search.config.separator",
    +        "search.result.placeholder",
    +        "search.result.none",
    +        "search.result.one",
    +        "search.result.other"
    +      ] -%}
    +        {%- set _ = translations.update({ key: lang.t(key) }) -%}
    +      {%- endfor -%}
    +      <script id="__lang" type="application/json">
    +        {{- translations | tojson -}}
    +      </script>
    +      {% block config %}{% endblock %}
    +      <script>
    +        app = initialize({
    +          base: "{{ base_url }}",
    +          features: {{ config.theme.features | tojson }},
    +          search: Object.assign({
    +            worker: "{{ 'assets/javascripts/worker/search.********.min.js' | url }}"
    +          }, typeof search !== "undefined" && search)
    +        })
    +      </script>
          {% for path in config["extra_javascript"] %}
            <script src="{{ path | url }}"></script>
          {% endfor %}
    ```

??? quote "`partials/footer.html`"

    ``` diff
    @@ -5,34 +5,34 @@
        <div class="md-footer-nav">
    -      <nav class="md-footer-nav__inner md-grid">
    +      <nav class="md-footer-nav__inner md-grid" aria-label="{{ lang.t('footer.title') }}">
            {% if page.previous_page %}
    -          <a href="{{ page.previous_page.url | url }}" title="{{ page.previous_page.title | striptags }}" class="md-flex md-footer-nav__link md-footer-nav__link--prev" rel="prev">
    -            <div class="md-flex__cell md-flex__cell--shrink">
    -              <i class="md-icon md-icon--arrow-back md-footer-nav__button"></i>
    +          <a href="{{ page.previous_page.url | url }}" title="{{ page.previous_page.title | striptags }}" class="md-footer-nav__link md-footer-nav__link--prev" rel="prev">
    +            <div class="md-footer-nav__button md-icon">
    +              {% include ".icons/material/arrow-left.svg" %}
                </div>
    -            <div class="md-flex__cell md-flex__cell--stretch md-footer-nav__title">
    -              <span class="md-flex__ellipsis">
    +            <div class="md-footer-nav__title">
    +              <div class="md-ellipsis">
                    <span class="md-footer-nav__direction">
                      {{ lang.t("footer.previous") }}
                    </span>
                    {{ page.previous_page.title }}
    -              </span>
    +              </div>
                </div>
              </a>
            {% endif %}
            {% if page.next_page %}
    -          <a href="{{ page.next_page.url | url }}" title="{{ page.next_page.title | striptags }}" class="md-flex md-footer-nav__link md-footer-nav__link--next" rel="next">
    -            <div class="md-flex__cell md-flex__cell--stretch md-footer-nav__title">
    -              <span class="md-flex__ellipsis">
    +          <a href="{{ page.next_page.url | url }}" title="{{ page.next_page.title | striptags }}" class="md-footer-nav__link md-footer-nav__link--next" rel="next">
    +            <div class="md-footer-nav__title">
    +              <div class="md-ellipsis">
                    <span class="md-footer-nav__direction">
                      {{ lang.t("footer.next") }}
                    </span>
                    {{ page.next_page.title }}
    -              </span>
    +              </div>
                </div>
    -            <div class="md-flex__cell md-flex__cell--shrink">
    -              <i class="md-icon md-icon--arrow-forward md-footer-nav__button"></i>
    +            <div class="md-footer-nav__button md-icon">
    +              {% include ".icons/material/arrow-right.svg" %}
                </div>
              </a>
            {% endif %}
    ```

??? quote "`partials/header.html`"

    ``` diff
    @@ -2,51 +2,43 @@
      This file was automatically generated - do not edit
    -#}
    <header class="md-header" data-md-component="header">
    -  <nav class="md-header-nav md-grid">
    -    <div class="md-flex">
    -      <div class="md-flex__cell md-flex__cell--shrink">
    -        <a href="{{ config.site_url | default(nav.homepage.url, true) | url }}" title="{{ config.site_name }}" aria-label="{{ config.site_name }}" class="md-header-nav__button md-logo">
    -          {% if config.theme.logo.icon %}
    -            <i class="md-icon">{{ config.theme.logo.icon }}</i>
    -          {% else %}
    -            <img alt="logo" src="{{ config.theme.logo | url }}" width="24" height="24">
    -          {% endif %}
    -        </a>
    -      </div>
    -      <div class="md-flex__cell md-flex__cell--shrink">
    -        <label class="md-icon md-icon--menu md-header-nav__button" for="__drawer"></label>
    -      </div>
    -      <div class="md-flex__cell md-flex__cell--stretch">
    -        <div class="md-flex__ellipsis md-header-nav__title" data-md-component="title">
    -          {% if config.site_name == page.title %}
    -            {{ config.site_name }}
    -          {% else %}
    -            <span class="md-header-nav__topic">
    -              {{ config.site_name }}
    -            </span>
    -            <span class="md-header-nav__topic">
    -              {% if page and page.meta and page.meta.title %}
    -                {{ page.meta.title }}
    -              {% else %}
    -                {{ page.title }}
    -              {% endif %}
    -            </span>
    -          {% endif %}
    +  <nav class="md-header-nav md-grid" aria-label="{{ lang.t('header.title') }}">
    +    <a href="{{ config.site_url | default(nav.homepage.url, true) | url }}" title="{{ config.site_name }}" class="md-header-nav__button md-logo" aria-label="{{ config.site_name }}">
    +      {% include "partials/logo.html" %}
    +    </a>
    +    <label class="md-header-nav__button md-icon" for="__drawer">
    +      {% include ".icons/material/menu" ~ ".svg" %}
    +    </label>
    +    <div class="md-header-nav__title" data-md-component="header-title">
    +      {% if config.site_name == page.title %}
    +        <div class="md-header-nav__ellipsis md-ellipsis">
    +          {{ config.site_name }}
            </div>
    -      </div>
    -      <div class="md-flex__cell md-flex__cell--shrink">
    -        {% if "search" in config["plugins"] %}
    -          <label class="md-icon md-icon--search md-header-nav__button" for="__search"></label>
    -          {% include "partials/search.html" %}
    -        {% endif %}
    -      </div>
    -      {% if config.repo_url %}
    -        <div class="md-flex__cell md-flex__cell--shrink">
    -          <div class="md-header-nav__source">
    -            {% include "partials/source.html" %}
    -          </div>
    +      {% else %}
    +        <div class="md-header-nav__ellipsis">
    +          <span class="md-header-nav__topic md-ellipsis">
    +            {{ config.site_name }}
    +          </span>
    +          <span class="md-header-nav__topic md-ellipsis">
    +            {% if page and page.meta and page.meta.title %}
    +              {{ page.meta.title }}
    +            {% else %}
    +              {{ page.title }}
    +            {% endif %}
    +          </span>
            </div>
          {% endif %}
        </div>
    +    {% if "search" in config["plugins"] %}
    +      <label class="md-header-nav__button md-icon" for="__search">
    +        {% include ".icons/material/magnify.svg" %}
    +      </label>
    +      {% include "partials/search.html" %}
    +    {% endif %}
    +    {% if config.repo_url %}
    +      <div class="md-header-nav__source">
    +        {% include "partials/source.html" %}
    +      </div>
    +    {% endif %}
      </nav>
    </header>
    ```

??? quote "`partials/hero.html`"

    ``` diff
    @@ -1,9 +1,8 @@
    {#-
      This file was automatically generated - do not edit
    -#}
    -{% set feature = config.theme.feature %}
    {% set class = "md-hero" %}
    -{% if not feature.tabs %}
    +{% if "tabs" not in config.theme.features %}
      {% set class = "md-hero md-hero--expand" %}
    {% endif %}
    <div class="{{ class }}" data-md-component="hero">
    ```

??? quote "`partials/language.html`"

    ``` diff
    @@ -3,12 +3,4 @@
    -#}
    {% import "partials/language/" + config.theme.language + ".html" as lang %}
    {% import "partials/language/en.html" as fallback %}
    -{% macro t(key) %}{{ {
    -  "direction": config.theme.direction,
    -  "search.language": (
    -    config.extra.search | default({})
    -  ).language,
    -  "search.tokenizer": (
    -    config.extra.search | default({})
    -  ).tokenizer | default("", true),
    -}[key] or lang.t(key) or fallback.t(key) }}{% endmacro %}
    +{% macro t(key) %}{{ lang.t(key) | default(fallback.t(key)) }}{% endmacro %}
    ```

??? quote "`partials/logo.html`"

    ``` diff
    @@ -0,0 +1,9 @@
    +{#-
    +  This file was automatically generated - do not edit
    +-#}
    +{% if config.theme.logo %}
    +  <img src="{{ config.theme.logo | url }}" alt="logo">
    +{% else %}
    +  {% set icon = config.theme.icon.logo or "material/library" %}
    +  {% include ".icons/" ~ icon ~ ".svg" %}
    +{% endif %}
    ```

??? quote "`partials/nav-item.html`"

    ``` diff
    @@ -14,9 +14,15 @@
        {% endif %}
        <label class="md-nav__link" for="{{ path }}">
          {{ nav_item.title }}
    +      <span class="md-nav__icon md-icon">
    +        {% include ".icons/material/chevron-right.svg" %}
    +      </span>
        </label>
    -    <nav class="md-nav" data-md-component="collapsible" data-md-level="{{ level }}">
    +    <nav class="md-nav" aria-label="{{ nav_item.title }}" data-md-level="{{ level }}">
          <label class="md-nav__title" for="{{ path }}">
    +        <span class="md-nav__icon md-icon">
    +          {% include ".icons/material/arrow-left.svg" %}
    +        </span>
            {{ nav_item.title }}
          </label>
          <ul class="md-nav__list" data-md-scrollfix>
    @@ -39,6 +45,9 @@
        {% if toc | first is defined %}
          <label class="md-nav__link md-nav__link--active" for="__toc">
            {{ nav_item.title }}
    +        <span class="md-nav__icon md-icon">
    +          {% include ".icons/material/table-of-contents.svg" %}
    +        </span>
          </label>
        {% endif %}
        <a href="{{ nav_item.url | url }}" title="{{ nav_item.title | striptags }}" class="md-nav__link md-nav__link--active">
    ```

??? quote "`partials/nav.html`"

    ``` diff
    @@ -1,14 +1,10 @@
    {#-
      This file was automatically generated - do not edit
    -#}
    -<nav class="md-nav md-nav--primary" data-md-level="0">
    -  <label class="md-nav__title md-nav__title--site" for="__drawer">
    -    <a href="{{ config.site_url | default(nav.homepage.url, true) | url }}" title="{{ config.site_name }}" class="md-nav__button md-logo">
    -      {% if config.theme.logo.icon %}
    -        <i class="md-icon">{{ config.theme.logo.icon }}</i>
    -      {% else %}
    -        <img alt="logo" src="{{ config.theme.logo | url }}" width="48" height="48">
    -      {% endif %}
    +<nav class="md-nav md-nav--primary" aria-label="{{ lang.t('nav.title') }}" data-md-level="0">
    +  <label class="md-nav__title" for="__drawer">
    +    <a href="{{ config.site_url | default(nav.homepage.url, true) | url }}" title="{{ config.site_name }}" class="md-nav__button md-logo" aria-label="{{ config.site_name }}">
    +      {% include "partials/logo.html" %}
        </a>
        {{ config.site_name }}
      </label>
    ```

??? quote "`partials/search.html`"

    ``` diff
    @@ -6,15 +6,18 @@
      <label class="md-search__overlay" for="__search"></label>
      <div class="md-search__inner" role="search">
        <form class="md-search__form" name="search">
    -      <input type="text" class="md-search__input" name="query" aria-label="Search" placeholder="{{ lang.t('search.placeholder') }}" autocapitalize="off" autocorrect="off" autocomplete="off" spellcheck="false" data-md-component="query" data-md-state="active">
    +      <input type="text" class="md-search__input" name="query" aria-label="{{ lang.t('search.placeholder') }}" placeholder="{{ lang.t('search.placeholder') }}" autocapitalize="off" autocorrect="off" autocomplete="off" spellcheck="false" data-md-component="search-query" data-md-state="active">
          <label class="md-search__icon md-icon" for="__search">
    +        {% include ".icons/material/magnify.svg" %}
    +        {% include ".icons/material/arrow-left.svg" %}
          </label>
    -      <button type="reset" class="md-icon md-search__icon" data-md-component="reset" tabindex="-1">
    -        &#xE5CD;
    +      <button type="reset" class="md-search__icon md-icon" aria-label="{{ lang.t('search.reset') }}" data-md-component="search-reset" tabindex="-1">
    +        {% include ".icons/material/close.svg" %}
          </button>
        </form>
        <div class="md-search__output">
          <div class="md-search__scrollwrap" data-md-scrollfix>
    -        <div class="md-search-result" data-md-component="result">
    +        <div class="md-search-result" data-md-component="search-result">
              <div class="md-search-result__meta">
                {{ lang.t("search.result.placeholder") }}
              </div>
    ```

??? quote "`partials/social.html`"

    ``` diff
    @@ -3,9 +3,12 @@
    -#}
    {% if config.extra.social %}
      <div class="md-footer-social">
    -    <link rel="stylesheet" href="{{ 'assets/fonts/font-awesome.css' | url }}">
        {% for social in config.extra.social %}
    -      <a href="{{ social.link }}" target="_blank" rel="noopener" title="{{ social.type }}" class="md-footer-social__link fa fa-{{ social.type }}"></a>
    +      {% set _,rest = social.link.split("//") %}
    +      {% set domain = rest.split("/")[0] %}
    +      <a href="{{ social.link }}" target="_blank" rel="noopener" title="{{ domain }}" class="md-footer-social__link">
    +        {% include ".icons/" ~ social.icon ~ ".svg" %}
    +      </a>
        {% endfor %}
      </div>
    {% endif %}
    ```

??? quote "`partials/source-date.html`"

    ``` diff
    @@ -0,0 +1,15 @@
    +{#-
    +  This file was automatically generated - do not edit
    +-#}
    +{% import "partials/language.html" as lang with context %}
    +{% set label = lang.t("source.revision.date") %}
    +<hr>
    +<div class="md-source-date">
    +  <small>
    +    {% if page.meta.git_revision_date_localized %}
    +      {{ label }}: {{ page.meta.git_revision_date_localized }}
    +    {% elif page.meta.revision_date %}
    +      {{ label }}: {{ page.meta.revision_date }}
    +    {% endif %}
    +  </small>
    +</div>
    ```

??? quote "`partials/source-link.html`"

    ``` diff
    @@ -0,0 +1,13 @@
    +{#-
    +  This file was automatically generated - do not edit
    +-#}
    +{% import "partials/language.html" as lang with context %}
    +{% set repo = config.repo_url %}
    +{% if repo | last == "/" %}
    +  {% set repo = repo[:-1] %}
    +{% endif %}
    +{% set path = page.meta.path | default([""]) %}
    +<a href="{{ [repo, path, page.meta.source] | join('/') }}" title="{{ file }}" class="md-content__button md-icon">
    +  {{ lang.t("meta.source") }}
    +  {% include ".icons/" ~ config.theme.icon.repo ~ ".svg" %}
    +</a>
    ```

??? quote "`partials/source.html`"

    ``` diff
    @@ -2,24 +2,11 @@
      This file was automatically generated - do not edit
    -#}
    {% import "partials/language.html" as lang with context %}
    -{% set platform = config.extra.repo_icon or config.repo_url %}
    -{% if "github" in platform %}
    -  {% set repo_type = "github" %}
    -{% elif "gitlab" in platform %}
    -  {% set repo_type = "gitlab" %}
    -{% elif "bitbucket" in platform %}
    -  {% set repo_type = "bitbucket" %}
    -{% else %}
    -  {% set repo_type = "" %}
    -{% endif %}
    -<a href="{{ config.repo_url }}" title="{{ lang.t('source.link.title') }}" class="md-source" data-md-source="{{ repo_type }}">
    -  {% if repo_type %}
    -    <div class="md-source__icon">
    -      <svg viewBox="0 0 24 24" width="24" height="24">
    -        <use xlink:href="#__{{ repo_type }}" width="24" height="24"></use>
    -      </svg>
    -    </div>
    -  {% endif %}
    +<a href="{{ config.repo_url }}" title="{{ lang.t('source.link.title') }}" class="md-source">
    +  <div class="md-source__icon md-icon">
    +    {% set icon = config.theme.icon.repo or "fontawesome/brands/git-alt" %}
    +    {% include ".icons/" ~ icon ~ ".svg" %}
    +  </div>
      <div class="md-source__repository">
        {{ config.repo_name }}
      </div>
    ```

??? quote "`partials/tabs-item.html`"

    ``` diff
    @@ -1,7 +1,7 @@
    {#-
      This file was automatically generated - do not edit
    -#}
    -{% if nav_item.is_homepage %}
    +{% if nav_item.is_homepage or nav_item.url == "index.html" %}
      <li class="md-tabs__item">
        {% if not page.ancestors | length and nav | selectattr("url", page.url) %}
          <a href="{{ nav_item.url | url }}" class="md-tabs__link md-tabs__link--active">
    ```

??? quote "`partials/tabs.html`"

    ``` diff
    @@ -5,7 +5,7 @@
    {% if page.ancestors | length > 0 %}
      {% set class = "md-tabs md-tabs--active" %}
    {% endif %}
    -<nav class="{{ class }}" data-md-component="tabs">
    +<nav class="{{ class }}" aria-label="{{ lang.t('tabs.title') }}" data-md-component="tabs">
      <div class="md-tabs__inner md-grid">
        <ul class="md-tabs__list">
          {% for nav_item in nav %}
    ```

??? quote "`partials/toc-item.html`"

    ``` diff
    @@ -6,7 +6,7 @@
        {{ toc_item.title }}
      </a>
      {% if toc_item.children %}
    -    <nav class="md-nav">
    +    <nav class="md-nav" aria-label="{{ toc_item.title }}">
          <ul class="md-nav__list">
            {% for toc_item in toc_item.children %}
              {% include "partials/toc-item.html" %}
    ```

??? quote "`partials/toc.html`"

    ``` diff
    @@ -2,35 +2,22 @@
      This file was automatically generated - do not edit
    -#}
    {% import "partials/language.html" as lang with context %}
    -<nav class="md-nav md-nav--secondary">
    +<nav class="md-nav md-nav--secondary" aria-label="{{ lang.t('toc.title') }}">
      {% endif %}
      {% if toc | first is defined %}
        <label class="md-nav__title" for="__toc">
    +      <span class="md-nav__icon md-icon">
    +        {% include ".icons/material/arrow-left.svg" %}
    +      </span>
          {{ lang.t("toc.title") }}
        </label>
        <ul class="md-nav__list" data-md-scrollfix>
          {% for toc_item in toc %}
            {% include "partials/toc-item.html" %}
          {% endfor %}
    -      {% if page.meta.source and page.meta.source | length > 0 %}
    -        <li class="md-nav__item">
    -          <a href="#__source" class="md-nav__link md-nav__link--active">
    -            {{ lang.t("meta.source") }}
    -          </a>
    -        </li>
    -      {% endif %}
    -      {% set disqus = config.extra.disqus %}
    -      {% if page and page.meta and page.meta.disqus is string %}
    -        {% set disqus = page.meta.disqus %}
    -      {% endif %}
    -      {% if not page.is_homepage and disqus %}
    -        <li class="md-nav__item">
    -          <a href="#__comments" class="md-nav__link md-nav__link--active">
    -            {{ lang.t("meta.comments") }}
    -          </a>
    -        </li>
    -      {% endif %}
        </ul>
      {% endif %}
    </nav>
    ```

## Upgrading from 3.x to 4.x

### What's new?

Material for MkDocs 4 fixes incorrect layout on Chinese systems. The fix
includes a mandatory change of the base font-size from `10px` to `20px` which
means all `rem` values needed to be updated. Within the theme, `px` to `rem` 
calculation is now encapsulated in a new function called `px2rem` which is part
of the SASS code base.

If you use Material for MkDocs with custom CSS that is based on `rem` values,
note that those values must now be divided by 2. Now, `1.0rem` doesn't map to
`10px`, but `20px`. To learn more about the problem and implications, please
refer to #911 in which the problem was discovered and fixed.

### Changes to `mkdocs.yml`

None.

### Changes to `*.html` files

None.
