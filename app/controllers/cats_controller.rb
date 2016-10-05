class CatsController < ApplicationController
  def index
    @cats = Cat.all
  end

  def show
    @cat = Cat.find(params[:id])
  end

  def destroy
    @cat = Cat.find(params[:id])
    @cat.destroy
    redirect_to cats_url
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      flash[:notice] = "Created #{@cat.name}"
      redirect_to cat_url(@cat)
    else
      render text: "params not provided"
    end
  end

  def new
    @cat = Cat.new
    render :new
  end

  def edit
    @cat = Cat.find(params[:id])
  end

  def update
    @cat = Cat.find(params[:id])
    @cat.update(cat_params)
    if @cat.save
      flash[:notice] = "Updated #{@cat.name}"
      redirect_to cat_url(@cat)
    else
      render text: "params not provided"
    end
  end

  private
  def cat_params
    params.require(:cat).permit(:birth_date, :color, :name, :sex, :description)
  end
end
