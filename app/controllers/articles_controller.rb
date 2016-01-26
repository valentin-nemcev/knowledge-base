class ArticlesController < ApplicationController
  include MarkdownHelper

  before_action :set_article,
    only: [:show, :edit, :update, :autosave, :destroy, :mark_as_reviewed]

  # GET /articles
  # GET /articles.json
  def index
    @articles = Article.all
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
  end

  # GET /articles/new
  def new
    @article = Article.new
    render :form
  end

  # GET /articles/1/edit
  def edit
    render :form
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new()

    respond_to do |format|
      if @article.autosaving(false).update(article_params)
        format.html { redirect_to @article, flash: {success: 'Article was successfully created.' }}
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :form }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.autosaving(false).update(article_params)
        format.html { redirect_to @article, flash: {success: 'Article was successfully updated.' }}
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :form }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def autosave
    respond_to do |format|
      if @article.autosaving(true).update(article_params)
        format.html { redirect_to [:edit, @article]}
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :form }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url, flash: {success: 'Article was successfully deleted.' }}
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

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :body)
    end
end
