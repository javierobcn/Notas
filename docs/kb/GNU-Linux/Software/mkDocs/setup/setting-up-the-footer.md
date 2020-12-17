---
template: overrides/main.html
---

# Setting up the footer

The footer of your project documentation is a great place to add links to
websites or platforms you or your company are using as additional marketing 
channels, e.g. :fontawesome-brands-medium:{: style="color: #00AB6C" },
:fontawesome-brands-twitter:{: style="color: #1DA1F2" } or
:fontawesome-brands-facebook:{: style="color: #4267B2" }, which can be
configured via `mkdocs.yml`.

## Configuration

### Social links

[:octicons-file-code-24: Source][1] ·
:octicons-milestone-24: Default: _none_

All _social links_ are rendered next to the copyright information as part of the 
footer of your project documentation. Add a list of social links in `mkdocs.yml` 
with:

``` yaml
extra:
  social:
    - icon: fontawesome/brands/twitter
      link: https://twitter.com/squidfunk
```

For each entry, the following fields are available:

`icon`{: #icon }

:   :octicons-milestone-24: Default: _none_ · :octicons-alert-24: Required –
    This field must point to a valid icon path referencing [any icon bundled
    with the theme][2], or the build will not succeed. Some popular choices:

    * :fontawesome-brands-behance: – `fontawesome/brands/behance`
    * :fontawesome-brands-docker: – `fontawesome/brands/docker`
    * :fontawesome-brands-github: – `fontawesome/brands/github`
    * :fontawesome-brands-instagram: – `fontawesome/brands/instagram`
    * :fontawesome-brands-linkedin: – `fontawesome/brands/linkedin`
    * :fontawesome-brands-medium: – `fontawesome/brands/medium`
    * :fontawesome-brands-pied-piper-alt: – `fontawesome/brands/pied-piper-alt`
    * :fontawesome-brands-product-hunt: – `fontawesome/brands/product-hunt`
    * :fontawesome-brands-slack: – `fontawesome/brands/slack`
    * :fontawesome-brands-twitter: – `fontawesome/brands/twitter`

  [1]: https://github.com/squidfunk/mkdocs-material/blob/master/src/partials/social.html
  [2]: https://github.com/squidfunk/mkdocs-material/tree/master/material/.icons

`link`{: #link }

:   :octicons-milestone-24: Default: _none_ · :octicons-alert-24: Required –
    This field must contain a valid relative or absolute URL including the URI 
    scheme. All URI schemes are supported, including `mailto` and `bitcoin`:

    === "Twitter"

        ``` yaml
        extra:
          social:
            - icon: fontawesome/brands/twitter
              link: https://twitter.com/squidfunk
        ```

    === "Email address"

        ``` yaml
        extra:
          social:
            - icon: fontawesome/solid/paper-plane
              link: mailto:<email-address>
        ```

`name`{: #name }

:   :octicons-milestone-24: Default: _domain name from_ `link`_, if available_ –
    This field is used as the link's `title` attribute and can be set to a 
    discernable name to improve accessibility:

    ``` yaml
    extra:
      social:
        - icon: fontawesome/brands/twitter
          link: https://twitter.com/squidfunk
          name: squidfunk on Twitter
    ```

### Copyright notice

[:octicons-file-code-24: Source][3] · 
:octicons-milestone-24: Default: _none_

A custom _copyright banner_ can be rendered as part of the footer, which is
displayed next to the social links. It can be defined as part of `mkdocs.yml`:

``` yaml
copyright: Copyright &copy; 2016 - 2020 Martin Donath
```

  [3]: https://github.com/squidfunk/mkdocs-material/blob/master/src/partials/footer.html#L85-L99

### Remove generator

[:octicons-file-code-24: Source][4] ·
[:octicons-heart-fill-24:{: .tx-heart } Insiders only][4]{: .tx-insiders }

The footer displays a _Made with Material for MkDocs_ notice to denote how
the site was generated. The notice can be removed with the following setting
via `mkdocs.yml`:

``` yaml
extra:
  generator: false
```

  [4]: ../insiders.md

## Customization

### Custom icons

[:octicons-file-code-24: Source][2] ·
:octicons-mortar-board-24: Difficulty: _moderate_

The social links feature uses the standard [icon integration][5] of Material for
MkDocs. If you want to use custom icons, follow the guide explaining how to
add [additional icons][6].

  [5]: changing-the-logo-and-icons.md#icons
  [6]: changing-the-logo-and-icons.md#additional-icons
