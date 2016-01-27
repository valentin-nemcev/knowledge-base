class ArticlesController < ApplicationController
  include MarkdownHelper

  before_action :set_article,
    only: [:show, :edit, :update, :update_autosave,
           :destroy, :mark_as_reviewed]

  def index
    @articles = Article.all
  end

  def show
  end

  def new
    @article = Article.new
    render :form
  end

  def edit
    render :form
  end

  def create
    @article = Article.new()

    respond_to do |format|
      if @article.autosaving(false).update(article_params)
        format.html { redirect_to @article, notice: :create_success }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :form }
        format.json { render json: @article.errors,
                      status: :unprocessable_entity }
      end
    end
  end

  def create_autosave
    @article = Article.new()

    respond_to do |format|
      if @article.autosaving(true).update(article_params)
        format.html { redirect_to [:edit, @article] }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :form }
        format.json { render json: @article.errors,
                      status: :unprocessable_entity }
      end
    end
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

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, notice: :destroy_success }
      format.json { head :no_content }
    end
  end

  def mark_as_reviewed
    @article.add_review(Time.now)
    render :show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list
    # through.
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
