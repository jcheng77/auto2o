class DeviseSmsActivableAddToDealers < ActiveRecord::Migration
  def self.up
    change_table :dealers do |t|
      t.string   :phone
      t.string   :sms_confirmation_token, :limit => 5
      t.datetime :confirmation_sms_sent_at
      t.datetime :sms_confirmed_at
      t.index    :sms_confirmation_token, :unique => true # for sms_activable
    end
  end
  
  def self.down
    remove_column :dealers, :sms_confirmation_token
    remove_column :dealers, :sms_confirmed_at
    remove_column :dealers, :confirmation_sms_sent_at
    remove_column :dealers, :phone
  end
end