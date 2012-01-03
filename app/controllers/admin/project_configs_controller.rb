class Admin::ProjectConfigsController < Admin::BaseController


  def index
    @configs = ProjectConfig.all
  end

  def new
    
  end

  def create
    
  end

  def edit
    @config = ProjectConfig.find(params[:id])
  end

  def update
    @config = ProjectConfig.find(params[:id])
    if @config.update_attributes(params[:project_config])
      redirect_to [:admin, :project_configs]
    else
      render 'edit'
    end
  end
  
  def destroy

  end
end