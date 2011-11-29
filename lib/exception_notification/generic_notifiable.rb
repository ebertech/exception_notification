module ExceptionNotification::GenericNotifiable

  def self.included(target)
    target.extend(ClassMethods)
    ActionMailer::Base.template_root =  Dir.pwd   
    Object.const_set(:RAILS_ROOT, Dir.pwd) unless defined?(RAILS_ROOT)
    # Object.const_set(:RAILS_DEFAULT_LOGGER, Logger.new(STDOUT)) unless defined?(RAILS_DEFAULT_LOGGER)
    target.skip_exception_notifications false
  end

  module ClassMethods
    def exception_data(deliverer=self)
      if deliverer == self
        read_inheritable_attribute(:exception_data)
      else
        write_inheritable_attribute(:exception_data, deliverer)
      end
    end

    def skip_exception_notifications(boolean=true)
      write_inheritable_attribute(:skip_exception_notifications, boolean)
    end

    def skip_exception_notifications?
      read_inheritable_attribute(:skip_exception_notifications)
    end
  end

  private
  def silent_notifiable
    begin
      yield
    rescue => exception
      notify_about_exception(exception)
    end
  end

  def notifiable
    begin
      yield
    rescue => exception
      notify_about_exception(exception)
      raise
    end
  end

  def notify_about_exception(exception, outside_rails = false)
    deliverer = self.class.exception_data
    data = case deliverer
    when nil then {}
    when Symbol then send(deliverer)
    when Proc then deliverer.call(self)
    end

    ExceptionNotification::Notifier.deliver_exception_notification(exception, self, ::ExceptionNotification::FakeRequest.new, data)
  end
end