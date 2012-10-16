ActiveAdmin.register Publisher do
  menu :if => proc{ current_admin_user.publishing_rel? }, :parent => "Books" 

  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("publishers", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
  
  index do
    selectable_column
    column :name 
    column :origin, :sortable => false
    column "Books" do |publisher| 
      publisher.books.map{ |book| book.title }.join("<br />").html_safe
    end
    default_actions
  end

  show do
    attributes_table do
      row :name 
      row :origin
      row "Books" do |publisher| 
        publisher.books.map{ |book| book.title }.join("<br />").html_safe
      end
    end
  end

  # form do |f|
  #   f.inputs "Publisher Details" do
  #     f.input :name
  #     f.input :origin
  #   end        
  #   f.buttons
  # end

end

ActiveAdmin.register Author do
  menu :if => proc{ current_admin_user.publishing_rel? }, :parent => "Books"
  
  action_item :only => :index do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    render "admin/csv/upload_csv"
  end

  collection_action :import_csv, :method => :post do
    CsvDb.convert_save("authors", params[:dump][:file])
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end

  index do
    selectable_column
    column "Name", :sortable => :name do |author|
      link_to author.name, admin_author_path(author)
    end 
    column :origin, :sortable => false
    column "Books" do |author| 
      author.books.map{ |book| book.title }.join("<br />").html_safe
    end
    column :comments
  end

  show do
    attributes_table do
      row :name 
      row :origin
      row "Books" do |author| 
        author.books.map{ |book| book.title }.join("<br />").html_safe
      end
      row :comments
    end
  end

  form do |f|
    f.inputs "Author Details" do
      f.input :name
      f.input :origin, :collection => Origin.all.map{ |origin| [origin.name, origin.id] }
      f.input :comments
    end      
    f.buttons
  end


end
