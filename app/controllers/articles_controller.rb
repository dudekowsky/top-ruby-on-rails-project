class ArticlesController < ApplicationController
  include ArticlesHelper

  before_action :require_login, except: [:index, :show, :pop, :dateindex]
  def index
    @articles = Article.all
  end
  def pop
    @articles = Article.order(view_count: :desc).first(3)
  end
  def dateindex
    @articles = Article.order(:created_at)
    @articles_month = @articles.group_by {
        |art| art.created_at.beginning_of_month }
  end
  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
    @article.increase_view_count
    @article.save
  end
  def new
    @article = Article.new
  end
  def create
    @article = Article.new(article_params)
    @article.save
    flash.notice = "Article '#{@article.title}' created!"
    redirect_to article_path(@article)
  end
  def edit
    @article = Article.find(params[:id])
  end
  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      flash.notice = "Article '#{@article.title}' Updated!"
      redirect_to article_path(@article)
    else
      flash.error.now = "Article could not be Updated!"
      render "edit"
    end
  end
  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    flash.notice = "Article deleted!"
    redirect_to articles_path
  end


end
