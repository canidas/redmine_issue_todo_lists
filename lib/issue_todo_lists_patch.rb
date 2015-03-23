module StuffToDoProjectPatch
  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)

    base.class_eval do
      unloadable
      
      has_many :issue_todo_lists
    end
  end
end

