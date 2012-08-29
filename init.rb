require 'redmine'
require 'redmine_anonymous_watchers/acts_as_watchable_patch'
require 'redmine_anonymous_watchers/hooks'

to_prepare = Proc.new do
  unless WatchersHelper.include?(RedmineAnonymousWatchers::WatchersHelperPatch)
    WatchersHelper.send :include, RedmineAnonymousWatchers::WatchersHelperPatch
  end
  unless Issue.include?(RedmineAnonymousWatchers::IssuePatch)
    Issue.send :include, RedmineAnonymousWatchers::IssuePatch
  end
  unless MailHandler.include?(RedmineAnonymousWatchers::MailHandlerPatch)
    MailHandler.send :include, RedmineAnonymousWatchers::MailHandlerPatch
  end
  unless WatchersController.include?(RedmineAnonymousWatchers::WatchersControllerPatch)
    WatchersController.send :include, RedmineAnonymousWatchers::WatchersControllerPatch
  end
end

if Redmine::VERSION::MAJOR >= 2
  Rails.configuration.to_prepare(&to_prepare)
else
  require 'dispatcher'
  Dispatcher.to_prepare(:redmine_anonymous_watchers, &to_prepare)
end

Redmine::Plugin.register :redmine_anonymous_watchers do
  name 'Redmine Anonymous Watchers plug-in'
  author 'Anton Argirov'
  author_url 'http://redmine.academ.org'
  description "Allows to add arbitrary emails as watchers."
  url "http://redmine.academ.org"
  version '0.0.1'

  settings :default => {
    :ignore_emails => ''
  }, :partial => 'settings/anonymous_watchers'
end

