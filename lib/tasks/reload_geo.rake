desc "Update any null latitude longitudes on needs"
task :reload_geo => :environment do
  Need.pluck(:id).each do |id|
    Workers::Coords.new.perform(need)
  end
end
