# Create default admin user for developing
puts "Create default admin user"
Erp::User.create(email: "admin@globalnaturesoft.com", password: "aA456321@", name: "Super Admin") if Erp::User.where(email: "admin@globalnaturesoft.com").empty?