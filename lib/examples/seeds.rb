Seeder = Dibber::Seeder

# Set up the path to seed YAML files
Seeder.seeds_path = "#{Rails.root}/db/seeds"

# Example 1. Seeder is used to monitor the process 
# and grab the attributes from the YAML file
Seeder.monitor Borough
Seeder.objects_from("boroughs.yml").each do |holder, borough|
  Borough.find_or_create_by_name(borough)
end

# Example 2. Seeder is only used to monitor the process
Seeder.monitor AdminUser
admin_email = 'admin@undervale.co.uk'
password = 'change_me'
AdminUser.create!(
  :email => admin_email,
  :password => password,
  :password_confirmation => password
) unless AdminUser.exists?(:email => admin_email)

# Example 3. Seeder grabs the attributes from the YAML and builds a 
# set of Fee objects with those attributes (or updates them if 
# they already exist). 
# Note that the build process defaults to using a 'name' field to store 
# the root key.
Seeder.new(Fee, 'fees.yml').build

# Example 4. Seeder using an alternative name field
Seeder.new(Fee, 'fees.yml', :name_method => :title).build

# Example 5. Seeder working with a name spaced object
Seeder.new(Disclaimer::Document, 'disclaimer/documents.yml').build

# Example 6. Seeder using values in the yaml file to set a single field
Seeder.new(Category, 'categories.yml', 'description').build

# Example 7. Seeder using alternative name and attributes fields
Seeder.new(
  Category, 
  'categories.yml', 
  :name_method => :title, 
  :attributes_method => :description
).build

# You can also access Seeders attached process log, and set up a custom log
Seeder.process_log.start('First questionnaire questions', 'Questionnaire.count > 0 ? Questionnaire.first.questions.length : 0')

# Output a report showing how the numbers of each type of object
# have changed through the process. Also has a log of start and end time.
puts Seeder.report
