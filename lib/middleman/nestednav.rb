require "middleman/nestednav/version"
require "middleman-core"

module Middleman

  class NestedNavItem
    include Enumerable

    attr_accessor :parent
    attr_reader   :title
    attr_accessor :path
    attr_accessor :children

    def initialize(title, path)
      @title    = title
      @path     = path
      @parent   = nil
      @children = []
    end

    def [](key)
      children.each do |child|
        return child if child.path == key
      end
      return nil
    end

    def sub_pages
      @children - [self['index.html']]
    end

    def <<(value)
      self.children << value
      value.parent = self
    end

    def each(&block)
      sub_pages.each do |child|
        if block_given?
          block.call child
        else
          yield child
        end
      end
    end

    def children?
      sub_pages.size > 0
    end

    def root?
      @parent == nil
    end

    def full_path
      return '' if root?
      [parent.full_path, path].join('/')
    end

    def title
      index_page = self['index.html']
      t = index_page ? index_page.title : @title
    end

    def self.recursively_create(nav_item, title, path)
      parts = path.split('/')
      if parts.size == 1
        return nav_item << NestedNavItem.new(title, path)
      end
      subpath = parts.shift
      subnav  = nav_item[subpath]
      if subnav.nil?
        subnav = NestedNavItem.new('', subpath)
        nav_item << subnav
      end
      NestedNavItem.recursively_create(subnav, title, parts.join('/'))
    end

  end

  class RootNestedNavItem < NestedNavItem
    def initialize
      super('', '/')
    end

    def sub_pages
      @children
    end
  end

  class NestedNav < Middleman::Extension
    def initialize(app, options_hash={}, &block)
      super
    end

    helpers do
      def nested_nav
        nav = RootNestedNavItem.new
        sitemap.resources.each do |resource|
          next unless resource.path =~ /\.html?$/
          title = resource.metadata[:page].try(:[], 'title') or 'Untitled Page'
          path  = resource.path
          NestedNavItem.recursively_create(nav, title, path)
        end
        nav
      end
    end
  end
end

::Middleman::Extensions.register(:nested_nav, Middleman::NestedNav)
