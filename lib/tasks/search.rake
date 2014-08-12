# encoding: utf-8

namespace :locomotive do

  namespace :search do

    desc 'Re-index all the searchable pages and entries'
    task reindex: :environment do
      Locomotive::ContentEntry.all.each_by(100) do |entry|
        entry.send(:reindex)
      end

      Locomotive::Page.all.each_by(100) do |page|
        page.send(:reindex)
      end
    end

  end

end