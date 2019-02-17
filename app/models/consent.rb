#coding:utf-8
class Consent < ActiveRecord::Base
  self.table_name = "consents"

  before_create :set_create_time
  before_update :set_update_time
  
  def save_record(params)
    self.victim_id    = params[:victim_id]    if params[:victim_id].present?
    self.searcher_id  = params[:searcher_id]  if params[:searcher_id].present?
    self.consent      = params[:consent]      if params[:consent].present?
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
