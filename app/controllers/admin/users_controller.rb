class Admin::UsersController < Admin::BaseController

  def index
    @users = User.paginate(:page=>params[:page], :per_page=>10, :order=>"state desc")
  end

  def edit
  end

  def update
  end

  def tag
    @user = User.find(params[:id])
    if %w(banned active deactive).include? params[:state]
      @user.state = params[:state]
      if @user.save
        flash[:notice] = "User #{@user.email} tagged as banned."
      else
        flash[:error] = "Banning of user is unsuccessful. Please try again later"
      end
      redirect_to [:admin, :users] 
    end
  end

end
