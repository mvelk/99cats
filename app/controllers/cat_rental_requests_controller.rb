class CatRentalRequestsController < ApplicationController
  def index
    @requests = CatRentalRequest.all
  end

  def show
    @request = CatRentalRequest.find(params[:id])
  end


  def destroy
    @request = CatRentalRequest.find(params[:id])
    @request.destroy
    redirect_to cat_rental_requests_url
  end

  def create
    @request = CatRentalRequest.new(cat_rental_params)
    if @request.save
      flash[:notice] = "Created request"
      redirect_to cat_rental_request_url(@request)
    else
      render text: "params not provided"
    end
  end

  def new
    @request = CatRentalRequest.new
    render :new
  end

  def edit
    @request = CatRentalRequest.find(params[:id])
  end

  def update
    @request = CatRentalRequest.find(params[:id])
    @request.update(cat_rental_params)
    if @request.save
      flash[:notice] = "Updated request"
      redirect_to cat_rental_request_url(@request)
    else
      render text: "params not provided"
    end
  end

  private
  def cat_rental_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
