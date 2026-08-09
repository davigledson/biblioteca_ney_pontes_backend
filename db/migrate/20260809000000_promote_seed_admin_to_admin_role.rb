class PromoteSeedAdminToAdminRole < ActiveRecord::Migration[7.2]
  def up
    User.where(email: "admin@biblioteca.com").update_all(role: 2)
  end

  def down
    User.where(email: "admin@biblioteca.com").update_all(role: 0)
  end
end