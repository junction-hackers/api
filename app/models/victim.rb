#coding:utf-8
class Victim < ActiveRecord::Base
  self.table_name = "victims"

  before_create :set_create_time
  before_update :set_update_time
  
  def save_record(params)
    self.phone    = params[:phone]    if params[:phone].present?
    self.location = params[:location] if params[:location].present?
    self.pic      = params[:pic]      if params[:pic].present?
    self.age      = params[:age]      if params[:age].present?
    self.gender   = params[:gender]   if params[:gender].present?
    self.album_key = params[:album_key] if params[:album_key].present?
    self.album_id = params[:album_id] if params[:album_id].present?
    self.save
  end
  
  def done_record
    self.done = 1
    self.save
  end

  def set_create_time 
    t = set_time
    self.created_at = t
    self.updated_at = t
  end

  def set_update_time 
    t = set_time
    self.updated_at = t
  end

  def set_time
    return Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
