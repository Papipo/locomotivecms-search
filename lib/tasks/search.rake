# encoding: utf-8

namespace :locomotive do

  namespace :search do

    desc 'Re-index all the searchable pages and entries'
    task reindex: :environment do
       Locomotive::Site.all.each do |s|
        puts "====== Site: #{s.subdomain}"
        s.pages.each do |p|
          puts "-- #{p.slug}"
          p.save
        end
        s.content_types.each do |ct|
          puts "===== #{ct.slug}"
          ct.entries.each do |e|
            puts e._slug
            e.save
          end
        end
      end
    end

  end

end
