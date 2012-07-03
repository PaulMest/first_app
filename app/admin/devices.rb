ActiveAdmin.register Device do
#    belongs_to :project

    filter :project, :as => :select, :label => "Project", 
        :collection => proc {Project.all} rescue nil
    filter :school, :as => :select, :label => "School", 
        :collection => proc {School.all} rescue nil
    filter :homeroom, :as => :select, :label => "Classroom", 
        :collection => proc {Homeroom.all} rescue nil
    filter :device_type
    filter :account #, :as => :select, :label => "Account", 
        #:collection => proc {Account.all.where(:id => :account_id)} rescue nil
    filter :control
    filter :flagged
    filter :serial_number
    filter :status, :as =>select, :label => "Status", :collection => proc {Device.all} rescue nil
    filter :reinforced_screen
    filter :purchase_order
    filter :number_broken

	action_item :only => :index do
    	link_to 'Upload CSV', :action => 'upload_csv'
  	end

  	collection_action :upload_csv do
    	render "admin/csv/upload_csv"
  	end

  	collection_action :import_csv, :method => :post do
    	CsvDb.convert_save("device", params[:dump][:file])
    	redirect_to :action => :index, :notice => "CSV imported successfully!"
  	end


    index do
        column("Account") do |device|
            link_to device.account.acc_number, admin_device_path(device)
        end
        column "Surname" do |device| 
            device.account.students.map(&:other_names).join("<br />").html_safe
        end
        column "Name" do |device| 
            device.account.students.map(&:first_name).join("<br />").html_safe
        end
        column :serial_number
        column :device_type
        column ("Status") { |device| device.status }
        column('Reinforced') { |device| device.reinforced_screen }
        column("Comments") { |device| device.account.comments }
        column("Broken devices") { |device| device.account.number_broken }
    end

    csv do
        column("Account") do |device|
          device.account.acc_number
        end
        column "Surname" do |device| 
            device.account.students.map(&:other_names).join(", ")
        end
        column "Name" do |device| 
            device.account.students.map(&:first_name).join(", ")
        end
        column("SerialNumber") {|device| device.serial_number }
        column("Type") { |device| device.device_type.name }
        column("Status") { |device| device.status }
        column('Reinforced') { |device| device.reinforced_screen }
        column("Comments") { |device| device.account.comments }
        column("Broken") { |device| device.account.number_broken }
    end

    form do |f|
    	f.inputs "Device Details" do
        	f.input :serial_number
        	f.input :flagged
        	f.input :control
        	f.input :reinforced_screen
        	f.input :device_type
            f.input :account, :collection => Account.all.map{ |account| [account.acc_number, account.id] }
        	f.input :purchase_order
            f.input :status, :collection => Device.device_status_collection, :as => :radio
            f.input :device_type, :collection => DeviceType.all, :as => :radio
 #           f.input :event, :collection => Event.events_name_collection
        end
        
        f.buttons

    end

  
end


ActiveAdmin.register PurchaseOrder do
    index do
        column :po_number
        column :date_ordered
        column :warranty_end_date
        column :project
        column :comments

        default_actions
    end
end

