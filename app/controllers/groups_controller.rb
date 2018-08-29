class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy bills]

  def index
    @groups = Group.all
  end

  def show; end

  def new
    @group = Group.new
  end

  def edit
    redirect_to root_path unless can?(:update, @group)
  end

  def create
    @group = Group.new(group_params.merge(creator_id: current_user.id))
    if @group.save
      User.invite!({ email: params[:user][:address] }, current_user)
      @group.users << User.find_by(email: params[:user][:address])
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new, alert: 'Group coul not be created!'
    end
  end

  def update
    if @group.update(group_params) && can?(:update, @group)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit, alert: 'Could not update group!'
    end
  end

  def destroy
    if can?(:destroy, Group)
      @group.destroy
      redirect_to groups_path, notice: 'Group was successfully deleted.'
    else
      redirect_to @group, alert: 'Can\'t perform this operaiton!' unless can?(:destroy, User)
    end
  end

  def bills
    respond_to do |format|
      format.js
    end
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

  def set_group
    @group = Group.find(params[:id])
  end
end
