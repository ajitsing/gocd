project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + '/gocd/**/*.rb', &method(:require))
