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

accounts = {
  '1': {name: 'Mr. Tú', email: 'acc01@email.com', pwd: 'p12345'},
  '2': {name: 'Mr. Nhân', email: 'acc02@email.com', pwd: 'p12345'},
  '3': {name: 'Mr. Dương', email: 'acc03@email.com', pwd: 'p12345'},
  '4': {name: 'Ms. Trúc', email: 'acc04@email.com', pwd: 'p12345'},
  '5': {name: 'Ms. Đan', email: 'acc05@email.com', pwd: 'p12345'},
  '6': {name: 'Ms. Trinh', email: 'acc06@email.com', pwd: 'p12345'},
  '7': {name: 'Mr. Thanh', email: 'acc07@email.com', pwd: 'p12345'},
  '8': {name: 'Mr. Phúc', email: 'acc08@email.com', pwd: 'p12345'},
  '9': {name: 'Bs. Liễu', email: 'acc09@email.com', pwd: 'p12345'},
  '10': {name: 'Ms. Thu', email: 'acc10@email.com', pwd: 'p12345'},
  '11': {name: 'Ms. Mỹ', email: 'acc11@email.com', pwd: 'p12345'}
}
accounts.each do |acc|
  Erp::User.create(
    name: acc[1][:"name"],
    email: acc[1][:"email"],
    password: acc[1][:"pwd"],
    backend_access: true,
    confirmed_at: Time.now,
    active: true
  ) if Erp::User.where(email: acc[1][:"email"]).empty?
end
