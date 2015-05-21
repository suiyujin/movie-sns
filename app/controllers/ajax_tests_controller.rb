class AjaxTestsController < ApplicationController
  before_action :set_ajax_test, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @ajax_tests = AjaxTest.all
    respond_with(@ajax_tests)
  end

  def show
    respond_with(@ajax_test)
  end

  def new
    @ajax_test = AjaxTest.new
    respond_with(@ajax_test)
  end

  def edit
  end

  def create
    @ajax_test = AjaxTest.new(ajax_test_params)
    @ajax_test.save
    respond_with(@ajax_test)
  end

  def update
    @ajax_test.update(ajax_test_params)
    respond_with(@ajax_test)
  end

  def destroy
    @ajax_test.destroy
    respond_with(@ajax_test)
  end

  private
    def set_ajax_test
      @ajax_test = AjaxTest.find(params[:id])
    end

    def ajax_test_params
      params.require(:ajax_test).permit(:movie_id, :title, :description, :url, :thumbnail_url, :thumbnail_path, :user_id)
    end
end
