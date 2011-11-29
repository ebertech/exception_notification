require 'rake/tasklib'
class NotifiedTask < Rake::TaskLib
  include ExceptionNotification::GenericNotifiable
  attr_accessor :name, :block

  def initialize(name, &block)
    @name = name
    @block = block
    define
  end

  def define
    task name do |t|
      notifiable { block.call }
    end
  end
end