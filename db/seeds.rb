# Create default admin user for developing
puts "Create default admin user"
Erp::User.create(email: "admin@phoviptour.vn", password: "aA456321@", name: "Phố Vip Tour", backend_access: true) if Erp::User.where(email: "admin@phoviptour.vn").empty?