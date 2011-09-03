namespace :erb do
  task :remove do
    files = `find . -name *.html.erb`
    files.each_line do |file|
      `rm -v #{file}`
    end
  end
  namespace :to do
    task :haml do
      files = `find . -name *.html.erb`
      files.each_line do |file|
        file.strip!
        `bundle exec html2haml #{file} | cat > #{file.gsub(/\.erb$/, ".haml")}`
      end
    end
  end
end