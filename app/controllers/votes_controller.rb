class VotesController < ApplicationController
  
  before_filter :require_user
  before_filter :find_votable
  
  def vote_for
    @current_user.vote_for(@votable)
    respond_to do |format|
      format.html {
        flash[:notice] = "Voted up !"
        redirect_to @votable
      }
      format.json { render :json => true }
    end
  end
  
  def vote_against
    @current_user.vote_against(@votable)
    respond_to do |format|
      format.html {
        flash[:notice] = "Voted down !"
        redirect_to @votable
      }
      format.json { render :json => true }
    end
  end
  
  def vote_nil
    @current_user.vote_nil(@votable)
    respond_to do |format|
      format.html {
        flash[:notice] = "Removed vote !"
        redirect_to @votable
      }
      format.json { render :json => true }
    end
  end
  
  private
  def find_votable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return @votable = $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
