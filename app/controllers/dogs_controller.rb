class DogsController < ApplicationController
  before_action :set_dog, only: [:show, :edit, :update, :destroy]

  # GET /dogs
  # GET /dogs.json
  def index
    @dogs = Dog.all
    dogs_per_page = 5
    page_index = params[:current_page].to_i || 1

    paginate(dogs_per_page, page_index)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
    if !current_user_dog_owner?
      redirect_to "/dogs/#{@dog.id}"
    end
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)
    @dog.user = find_owner

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      @dog.user = find_owner
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dog
      @dog = Dog.find(params[:id])
    end
    
    # Find owner by email from params
    def find_owner
      User.find_by(email: params[:dog][:user_email])
    end

    # Determine if current user is the owner of the dog being edited
    def current_user_dog_owner?
      current_user.id == @dog.user_id
    end

    # Encapsulate the pagination logic
    def paginate(items_per_page, current_page)
      
      # Determine the first index for dog element based on page & dog count
      dog_index = (current_page - 1) * items_per_page
      
      # Populate the dogs based on current index and dogs per page
      @current_dogs = @dogs[dog_index, items_per_page]

      @total_pages = (@dogs.count.to_f / items_per_page).ceil
    end
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def dog_params
      params.require(:dog).permit(:name, :description, :images)
    end
end
