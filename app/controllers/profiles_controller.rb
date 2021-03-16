class ProfilesController < ApplicationController
  before_action :set_user
  before_action :require_username

  def show
    custom_meta_tags("@#{ @user.username }'s Timeline",
                     "Translations created by @#{ @user.username }.",
                     "#{ @user.username }")

    if @user
      @entries = @user.entries.order(created_at: :desc).page params[:page]
    end
  end

  def votes
    custom_meta_tags("@#{ @user.username }'s Votes",
                     "Translations voted by @#{ @user.username }.",
                     ["#{ @user.username }", "votes"])

    @entries = (@user.get_voted Entry, :vote_scope => 'vote').page params[:page]
  end

  def saved
    custom_meta_tags("@#{ @user.username }'s Bookmarks",
                     "Translations created by @#{ @user.username }.",
                     ["#{ @user.username }", "saved", "bookmarks"])

    @entries = (@user.get_voted Entry, :vote_scope => 'saved').page params[:page]
  end

  def verified
    custom_meta_tags("@#{ @user.username }'s Verified",
                     "Translations verified by @#{ @user.username }.",
                     ["#{ @user.username }", "verified"])

    @entries = (@user.get_voted Entry, :vote_scope => 'verify').page params[:page]
  end

  private

  def set_user
    @user = User.find_by(username: params[:username])
  end
end
