class VotesController < ApplicationController
  before_filter :set_votable_or_redirect
  before_filter :require_user
  
  def index
    @votes = @votable.votes.all
  end
  
  def vote_for
    @current_user.vote_for(@votable)
    respond_to do |format|
      format.json { render :json => true }
      format.html {
        flash[:notice] = "Voted up !"
        redirect_to @votable
      }
    end
  end
  
  def vote_against
    @current_user.vote_against(@votable)
    respond_to do |format|
      format.json { render :json => true }
      format.html {
        flash[:notice] = "Voted down !"
        redirect_to @votable
      }
    end
  end
  
  def vote_nil
    @current_user.vote_nil(@votable)
    respond_to do |format|
      format.json { render :json => true }
      format.html {
        flash[:notice] = "Removed vote !"
        redirect_to @votable
      }
    end
  end
  
  private
  def set_votable_or_redirect
    @votable = find_votable
    redirect_to home if @votable.nil?
  end
  
  def find_votable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
