#coding:utf-8
class Searcher < ActiveRecord::Base
  self.table_name = "searchers"

  before_create :set_create_time
  before_update :set_update_time
  
  def save_record(params)
    self.phone        = params[:phone]      if params[:phone].present?
    self.search_pic   = params[:search_pic] if params[:search_pic].present?
    self.save
  end
  
  def done_record
    self.done = 1
    self.save
  end

  def set_create_time 
    t = set_time
    self.create_time = t
    self.update_time = t
  end

  def set_update_time 
    t = set_time
    self.update_time = t
  end

  def set_time
    return Time.now.strftime("%Y-%m-%d %H:%M:%S")
  end
end
