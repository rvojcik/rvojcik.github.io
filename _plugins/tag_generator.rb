module Jekyll
  class TagPage < Page
    def initialize(site, base, dir, tag)
      @site = site
      @base = base
      @dir  = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag']   = tag
      self.data['title'] = "Posts tagged: #{tag}"
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      return unless site.layouts.key?('tag')

      dir = site.config['tag_dir'] || 'tag'
      site.categories.each_key do |tag|
        site.pages << TagPage.new(site, site.source, File.join(dir, tag), tag)
      end
    end
  end
end
