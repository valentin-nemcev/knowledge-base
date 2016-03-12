class ArticlesController < ApplicationController
  include MarkdownHelper

  before_action :set_article,
    only: [:show, :edit, :update, :update_autosave, :restore, :destroy]

  def index
    @articles =
      (params[:with_deleted] ? Article : Article.without_soft_destroyed)
        .includes(:current_revision, :reviews)
        .all
        .decorate
        .sort_by(&:next_review_at_for_sort)
  end

  def show
  end

  def new
    @article = Article.create
    redirect_to [:edit, @article]
  end

  def edit
    render :form
  end

  def update
    respond_to do |format|
      if @article.autosaving(false).update(article_params)
        format.html { redirect_to @article, notice: :update_success }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :form }
        format.json { render json: @article.errors,
                      status: :unprocessable_entity }
      end
    end
  end

  def update_autosave
    respond_to do |format|
      if @article.autosaving(true).update(article_params)
        format.html { redirect_to [:edit, @article]}
        format.js { render 'form.js.coffee' }
      else
        format.html { render :form }
        format.js { render 'form.js.coffee' }
      end
    end
  end

  def restore
    @article.restore
    respond_to do |format|
      format.html { redirect_to articles_url, notice: :restore_success }
      format.json { head :no_content }
    end
  end

  def destroy
    if params[:forever]
      @article.destroy
    else
      @article.soft_destroy
    end
    respond_to do |format|
      format.html { redirect_to articles_url, notice: :destroy_success }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article
        .includes(:revisions, :reviews)
        .find(params[:id])
        .decorate
    end

    # Never trust parameters from the scary internet, only allow the white list
    # through.
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
