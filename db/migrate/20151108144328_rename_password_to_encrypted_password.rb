class RenamePasswordToEncryptedPassword < ActiveRecord::Migration
  def change
    rename_column :dashboards, :password, :encrypted_password
  end
end
