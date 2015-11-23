module GitReflow
  module Hooks
    extend self

    [:setup, :start, :review, :deliver].each do |command|
      define_method(:"before_#{command}") do
        GitReflow::Sandbox.run "git config --get-all reflow.hooks.before-#{command}", loud: false
      end
      define_method(:"after_#{command}") do
        GitReflow::Sandbox.run "git config --get-all reflow.hooks.after-#{command}", loud: false
      end
    end

    def overrides
      Array(GitReflow::Config.get("reflow.hooks.overrides", all: true))
    end

    def preform(hook)
      return false unless self.respond_to?(hook)
      files_to_run_for_hook = self.send(hook)
      Array(files_to_run_for_hook).each do |filename|
        load(filename) if File.exist?(filename) and File.executable?(filename)
      end
    end
  end
end
