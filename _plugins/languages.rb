module Reading
  class Generator < Jekyll::Generator
    def generate(site)
      print site.pages
      print "\n\n"
      print site.config['languages']
      print "\n\n"
      
      print site.pages.length
      print "\n"
      
      old_pages = site.pages.dup()
      
      old_pages.each do |old_page|
        # Delete the initial page.
        print 'delete ' + old_page.path + "\n"
        site.pages.delete(old_page)
        
        site.config['languages'].each do |lang|
          iso_code = lang.keys[0]
          language = lang[iso_code]
          new_page1 = old_page.clone()
          new_page2 = old_page.clone()
          
          # Assign a name like base.language.extension, compatible with Apache:
          # http://httpd.apache.org/docs/2.2/content-negotiation.html#naming
          new_page1.name = old_page.basename + '.' + iso_code + old_page.ext
          new_page1.process(new_page1.name)

          new_page2.dir = iso_code + '/' + old_page.dir
          new_page2.process(new_page2.name)

          new_page1.data = old_page.data.clone()
          new_page1.data['language'] = language
          
          new_page2.data = old_page.data.clone()
          new_page2.data['language'] = language
          
          # For languages other than English, move the title and content.
          if iso_code != 'en'
            new_page1.data['title'] = old_page.data['title-' + iso_code]
            new_page1.content = old_page.data['body-' + iso_code]

            new_page2.data['title'] = old_page.data['title-' + iso_code]
            new_page2.content = old_page.data['body-' + iso_code]
          end
          
          site.pages << new_page1
          site.pages << new_page2
        end
      end

      print site.pages.length
      print "\n"
      
    end
  end
end
