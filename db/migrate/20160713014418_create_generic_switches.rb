class CreateGenericSwitches < ActiveRecord::Migration
  def change
    create_table :generic_switches do |t|
      t.string :name
      t.boolean :active

      t.timestamps null: false
    end

    GenericSwitch.create(name:'adsense',active:true)
  end
end
