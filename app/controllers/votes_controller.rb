class VotesController < ApplicationController
  def index
    @votes = Votes.all
  end
  
  def show
    @votes = Votes.find(params[:id])
  end
  
  def new
    @votes = Votes.new
  end
  
  def create
    @votes = Votes.new(params[:votes])
    if @votes.save
      flash[:notice] = "Successfully created votes."
      redirect_to @votes
    else
      render :action => 'new'
    end
  end
  
  def edit
    @votes = Votes.find(params[:id])
  end
  
  def update
    @votes = Votes.find(params[:id])
    if @votes.update_attributes(params[:votes])
      flash[:notice] = "Successfully updated votes."
      redirect_to @votes
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @votes = Votes.find(params[:id])
    @votes.destroy
    flash[:notice] = "Successfully destroyed votes."
    redirect_to votes_url
  end
end
