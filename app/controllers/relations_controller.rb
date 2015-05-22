class RelationsController < ApplicationController
  before_action :set_relation, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @relations = Relation.all
    respond_with(@relations)
  end

  def show
    respond_with(@relation)
  end

  def new
    @relation = Relation.new
    respond_with(@relation)
  end

  def edit
  end

  def create
    @relation = Relation.new(relation_params)
    @relation.save
    respond_with(@relation)
  end

  def update
    @relation.update(relation_params)
    respond_with(@relation)
  end

  def destroy
    @relation.destroy
    respond_with(@relation)
  end

  private
    def set_relation
      @relation = Relation.find(params[:id])
    end

    def relation_params
      params.require(:relation).permit(:good_count, :bad_count, :similarity, :movie_id, :movie_id, :user_id)
    end
end
