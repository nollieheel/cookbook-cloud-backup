cwd = "#{File.absolute_path(File.dirname(__FILE__))}/.."

cookbook_path   ["#{cwd}/cookbooks", "#{cwd}/site-cookbooks"]
log_level       :info
log_location    STDOUT
data_bag_path   "#{cwd}/data_bags"
verbose_logging true
