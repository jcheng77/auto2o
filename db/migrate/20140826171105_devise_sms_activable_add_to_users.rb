class DeviseSmsActivableAddToUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string   :phone
      t.string   :sms_confirmation_token, :limit => 5
      t.datetime :confirmation_sms_sent_at
      t.datetime :sms_confirmed_at
      t.index    :sms_confirmation_token, :unique => true # for sms_activable
    end
  end
  
  def self.down
    remove_column :users, :sms_confirmation_token
    remove_column :users, :sms_confirmed_at
    remove_column :users, :confirmation_sms_sent_at
    remove_column :users, :phone
  end
end