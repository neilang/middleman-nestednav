# Middleman Nested Nav Gem

Simple gem to generate a menu from the source html files.

## Installation

Add this line to your application's Gemfile:

    gem 'middleman', '~>3.2' # Requires latest middleman
    gem 'middleman-nestednav'

Execute:

    $ bundle install

In your `config.rb` add:

    activate :nested_nav

## Usage

To access the menu nested menu structure call `nested_nav` in your template.

### Simple usage

Slim example:

    nav
      ul
        - nested_nav.each do |nav_item|
          li
            = link_to nav_item.title, nav_item.full_path
            - if nav_item.children?
              ul
                - nav_item.each do |sub_nav_item|
                  li= link_to sub_nav_item.title, sub_nav_item.full_path

### Recursive partial example

Create a partial called `_nested_nav.html.slim`:

    ul
      - nav.each do |nav_item|
        li
          = link_to nav_item.title, nav_item.full_path
          - if nav_item.children?
            = partial '_nested_nav', locals: { nav: nav_item }

Then include this line in your main layout file:

    nav= partial '_nested_nav', locals: { nav: nested_nav }

