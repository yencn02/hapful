class Admin::UsersController < Admin::BaseController

  def index
    @users = User.paginate(:page=>params[:page], :per_page=>10)
  end

  def edit
  end

  def update
  end

end
