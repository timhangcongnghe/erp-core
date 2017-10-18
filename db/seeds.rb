# Create default admin user for developing
puts "Create default admin user"
Erp::User.create(
  email: "admin@globalnaturesoft.com",
  password: "aA456321@",
  name: "Super Admin",
  backend_access: true,
  confirmed_at: Time.now-1.day,
  active: true
) if Erp::User.where(email: "admin@globalnaturesoft.com").empty?