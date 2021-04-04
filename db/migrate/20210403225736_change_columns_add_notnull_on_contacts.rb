class ChangeColumnsAddNotnullOnContacts < ActiveRecord::Migration[5.2]
  def change
    change_column_null :contacts, :name, false
    change_column_null :contacts, :message, false
  end
end
