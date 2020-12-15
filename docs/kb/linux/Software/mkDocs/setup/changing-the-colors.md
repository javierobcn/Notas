---
template: overrides/main.html
---

# Changing the colors

As any proper Material Design implementation, Material for MkDocs supports
Google's original [color palette][1], which can be easily configured through 
`mkdocs.yml`. Furthermore, colors can be customized with a few lines of CSS to
fit your brand's identity by using [CSS variables][2].

  [1]: http://www.materialui.co/colors
  [2]: #custom-colors

## Configuration

### Color palette

#### Color scheme

[:octicons-file-code-24: Source][3] · :octicons-milestone-24: Default: `default`

Material for MkDocs supports two _color schemes_: a light mode, which is just
called `default`, and a dark mode, which is called `slate`. The color scheme
can be set via `mkdocs.yml`:

``` yaml
theme:
  palette:
    scheme: default
```

:material-cursor-default-click-outline: Click on a tile to change the color
scheme:

<div class="tx-switch">
  <button data-md-color-scheme="default"><code>default</code></button>
  <button data-md-color-scheme="slate"><code>slate</code></button>
</div>

<script>
  var buttons = document.querySelectorAll("button[data-md-color-scheme]")
  buttons.forEach(function(button) {
    button.addEventListener("click", function() {
      var attr = this.getAttribute("data-md-color-scheme")
      document.body.setAttribute("data-md-color-scheme", attr)
      var name = document.querySelector("#__code_0 code span:nth-child(7)")
      name.textContent = attr
    })
  })
</script>

The _color scheme_ can also be set based on _user preference_, which makes use
of the `prefers-color-scheme` media query, by setting the value in `mkdocs.yml`
to `preference`:

``` yaml
theme:
  palette:
    scheme: preference
```

  [3]: https://github.com/squidfunk/mkdocs-material/blob/master/src/assets/stylesheets/palette/_scheme.scss

#### Primary color

[:octicons-file-code-24: Source][4] · :octicons-milestone-24: Default: `indigo`

The _primary color_ is used for the header, the sidebar, text links and several
other components. In order to change the primary color, set the following value
in `mkdocs.yml` to a valid color name:

``` yaml
theme:
  palette:
    primary: indigo
```

:material-cursor-default-click-outline: Click on a tile to change the primary
color:

<div class="tx-switch">
  <button data-md-color-primary="red"><code>red</code></button>
  <button data-md-color-primary="pink"><code>pink</code></button>
  <button data-md-color-primary="purple"><code>purple</code></button>
  <button data-md-color-primary="deep-purple"><code>deep purple</code></button>
  <button data-md-color-primary="indigo"><code>indigo</code></button>
  <button data-md-color-primary="blue"><code>blue</code></button>
  <button data-md-color-primary="light-blue"><code>light blue</code></button>
  <button data-md-color-primary="cyan"><code>cyan</code></button>
  <button data-md-color-primary="teal"><code>teal</code></button>
  <button data-md-color-primary="green"><code>green</code></button>
  <button data-md-color-primary="light-green"><code>light green</code></button>
  <button data-md-color-primary="lime"><code>lime</code></button>
  <button data-md-color-primary="yellow"><code>yellow</code></button>
  <button data-md-color-primary="amber"><code>amber</code></button>
  <button data-md-color-primary="orange"><code>orange</code></button>
  <button data-md-color-primary="deep-orange"><code>deep orange</code></button>
  <button data-md-color-primary="brown"><code>brown</code></button>
  <button data-md-color-primary="grey"><code>grey</code></button>
  <button data-md-color-primary="blue-grey"><code>blue grey</code></button>
  <button data-md-color-primary="black"><code>black</code></button>
  <button data-md-color-primary="white"><code>white</code></button>
</div>

<script>
  var buttons = document.querySelectorAll("button[data-md-color-primary]")
  buttons.forEach(function(button) {
    button.addEventListener("click", function() {
      var attr = this.getAttribute("data-md-color-primary")
      document.body.setAttribute("data-md-color-primary", attr)
      var name = document.querySelector("#__code_2 code span:nth-child(7)")
      name.textContent = attr.replace("-", " ")
    })
  })
</script>

  [4]: https://github.com/squidfunk/mkdocs-material/blob/master/src/assets/stylesheets/palette/_primary.scss

#### Accent color

[:octicons-file-code-24: Source][5] · :octicons-milestone-24: Default: `indigo`

The _accent color_ is used to denote elements that can be interacted with, e.g.
hovered links, buttons and scrollbars. It can be changed in `mkdocs.yml` by
choosing a valid color name:

``` yaml
theme:
  palette:
    accent: indigo
```

:material-cursor-default-click-outline: Click on a tile to change the accent
color:

<style>
  .md-typeset button[data-md-color-accent] > code {
    background-color: var(--md-code-bg-color);
    color: var(--md-accent-fg-color);
  }
</style>

<div class="tx-switch">
  <button data-md-color-accent="red"><code>red</code></button>
  <button data-md-color-accent="pink"><code>pink</code></button>
  <button data-md-color-accent="purple"><code>purple</code></button>
  <button data-md-color-accent="deep-purple"><code>deep purple</code></button>
  <button data-md-color-accent="indigo"><code>indigo</code></button>
  <button data-md-color-accent="blue"><code>blue</code></button>
  <button data-md-color-accent="light-blue"><code>light blue</code></button>
  <button data-md-color-accent="cyan"><code>cyan</code></button>
  <button data-md-color-accent="teal"><code>teal</code></button>
  <button data-md-color-accent="green"><code>green</code></button>
  <button data-md-color-accent="light-green"><code>light green</code></button>
  <button data-md-color-accent="lime"><code>lime</code></button>
  <button data-md-color-accent="yellow"><code>yellow</code></button>
  <button data-md-color-accent="amber"><code>amber</code></button>
  <button data-md-color-accent="orange"><code>orange</code></button>
  <button data-md-color-accent="deep-orange"><code>deep orange</code></button>
</div>

<script>
  var buttons = document.querySelectorAll("button[data-md-color-accent]")
  buttons.forEach(function(button) {
    button.addEventListener("click", function() {
      var attr = this.getAttribute("data-md-color-accent")
      document.body.setAttribute("data-md-color-accent", attr)
      var name = document.querySelector("#__code_3 code span:nth-child(7)")
      name.textContent = attr.replace("-", " ")
    })
  })
</script>

  [5]: https://github.com/squidfunk/mkdocs-material/blob/master/src/assets/stylesheets/palette/_accent.scss

---

!!! warning "Accessibility – not all color combinations work well"

    With __2__ (color schemes) __x 21__ (primary colors) __x 17__ (accent color)
    = __714__ combinations, it's impossible to ensure that all configurations
    provide a good user experience (e.g. _yellow on light background_). Make
    sure that the color combination of your choosing provides enough contrast
    and tweak CSS variables where necessary.

### Color palette toggle

  [:octicons-file-code-24: Source][6] ·
  :octicons-beaker-24: Experimental ·
  [:octicons-heart-fill-24:{: .tx-heart } Insiders only][6]{: .tx-insiders }

[Material for MkDocs Insiders][6] makes it possible to define multiple color
palettes, including a [scheme][7], [primary][8] and [accent][9] color each, and
let the user choose. Define them via `mkdocs.yml`:

``` yaml
theme:
  palette:
    - scheme: default
      primary: indigo
      accent: indigo
      toggle:
        icon: material/toggle-switch
        name: Switch to light mode
    - scheme: slate
      primary: blue
      accent: blue
      toggle:
        icon: material/toggle-switch-off-outline
        name: Switch to dark mode
```

The `toggle` field allows to specify an `icon` and `name` for each palette. The
toggle is rendered next to the search bar and will cycle through all defined
color palettes:

`icon`{: #icon }

:   :octicons-milestone-24: Default: _none_ · :octicons-alert-24: Required –
    This field must point to a valid icon path referencing [any icon bundled
    with the theme][10], or the build will not succeed. Some popular
    combinations:

    * :material-toggle-switch-off-outline: + :material-toggle-switch: – `material/toggle-switch-off-outline` + `material/toggle-switch`
    * :material-weather-sunny: + :material-weather-night: – `material/weather-sunny` + `material/weather-night`
    * :material-eye-outline: + :material-eye: – `material/eye-outline` + `material/eye`
    * :material-lightbulb-outline: + :material-lightbulb: – `material/lightbulb-outline` + `material/lightbulb`

`name`{: #name }

:   :octicons-milestone-24: Default: _none_ · :octicons-alert-24: Required –
    This field is used as the toggle's `title` attribute and should be set to a
    discernable name to improve accessibility.

[Try this feature][11]{: .md-button .md-button--primary }

_This feature is enabled on the [official documentation][11] built with
Insiders._

  [6]: ../insiders.md
  [7]: #color-scheme
  [8]: #primary-color
  [9]: #accent-color
  [10]: https://github.com/squidfunk/mkdocs-material/tree/master/material/.icons
  [11]: https://squidfunk.github.io/mkdocs-material-insiders/setup/changing-the-colors

## Customization

### Custom colors

[:octicons-file-code-24: Source][12] ·
:octicons-mortar-board-24: Difficulty: _easy_

Material for MkDocs implements colors using [CSS variables][13] (custom
properties). If you want to customize the colors beyond the palette (e.g. to
use your brand-specific colors), you can add an [additional stylesheet][14] and
tweak the values of the CSS variables.

Let's say you're :fontawesome-brands-youtube:{: style="color: #EE0F0F" }
__YouTube__, and want to set the primary color to your brand's palette. Just
add:

``` css
:root {
  --md-primary-fg-color:        #EE0F0F;
  --md-primary-fg-color--light: #ECB7B7;
  --md-primary-fg-color--dark:  #90030C;
}
```

See the file containing the [color definitions][12] for a list of all CSS
variables.

  [12]: https://github.com/squidfunk/mkdocs-material/blob/master/src/assets/stylesheets/main/_colors.scss
  [13]: https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties
  [14]: ../customization.md#additional-css


### Custom color schemes

[:octicons-file-code-24: Source][3] ·
:octicons-mortar-board-24: Difficulty: _easy_

Besides overriding specific colors, you can create your own, named color scheme
by wrapping the definitions in the `#!css [data-md-color-scheme="..."]`
[attribute selector][15], which you can then set via `mkdocs.yml` as described
in the [color schemes][7] section:

``` css
[data-md-color-scheme="youtube"] {
  --md-primary-fg-color:        #EE0F0F;
  --md-primary-fg-color--light: #ECB7B7;
  --md-primary-fg-color--dark:  #90030C;
}
```

Additionally, the `slate` color scheme defines all of it's colors via `hsla`
color functions and deduces its colors from the `--md-hue` CSS variable. You
can tune the `slate` theme with:

``` css
[data-md-color-scheme="slate"] {
  --md-hue: 210; /* [0, 360] */
}
```

  [15]: https://www.w3.org/TR/selectors-4/#attribute-selectors
