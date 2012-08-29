module RedmineAnonymousWatchers
  module WatchersControllerPatch
    unloadable

    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        alias_method_chain :destroy, :anonymous
        alias_method_chain :create, :anonymous
        alias_method_chain :append, :anonymous
      end
    end

    module InstanceMethods
      def destroy_with_anonymous
        if params[:mail]
          @watched.set_watcher(params[:mail], false) if request.post?
          respond_to do |format|
            format.html { redirect_to :back }
            format.js
          end
        else
          destroy_without_anonymous
        end
      end

      def append_with_anonymous
        if params[:watcher].is_a?(Hash)
          @watcher_mails = params[:watcher][:mails].split(/[\s,]+/) || [params[:watcher][:mail]]
        end
        append_without_anonymous
      end

      def create_with_anonymous
        if params[:watcher].is_a?(Hash) && request.post?
          mails = params[:watcher][:mails].split(/[\s,]+/) || [params[:watcher][:mail]]
          mails.each do |mail|
            AnonymousWatcher.create(:watchable => @watched, :mail => mail) if mail.present?
          end
        end
        create_without_anonymous
      end
    end
  end
end