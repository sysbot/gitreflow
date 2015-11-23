desc 'Setup your GitHub account'
command :setup do |c|
  c.desc 'sets up your api token with GitHub'
  c.switch [:l, :local], default_value: false, desc: 'setup GitReflow for the current project only'
  c.switch [:e, :enterprise], default_value: false, desc: 'setup GitReflow with a Github Enterprise account'
  c.switch [:trello, :"use-trello"], default_value: false, desc: 'setup GitReflow for use with a Trello account'
  c.action do |global_options, options, args|
    reflow_options = { project_only: options[:local], enterprise: options[:enterprise] }
    reflow_already_setup = (
      !GitReflow::Config.get('reflow.git-server').empty? and
      !GitReflow::Config.get('github.user').empty? and
      !GitReflow::Config.get('github.site').empty? and
      !GitReflow::Config.get('github.endpoint').empty? and
      !GitReflow::Config.get('github.oauth-token').empty?
    )

    GitReflow::Hooks.run(:before_setup)

    unless reflow_already_setup
      choose do |menu|
        menu.header = "Available remote Git Server services:"
        menu.prompt = "Which service would you like to use for this project?  "

        menu.choice('GitHub')    { GitReflow::GitServer.connect reflow_options.merge({ provider: 'GitHub', silent: false }) }
        menu.choice('BitBucket (team-owned repos only)') { GitReflow::GitServer.connect reflow_options.merge({ provider: 'BitBucket', silent: false }) }
      end
    end

    GitReflow::Hooks.run(:after_setup)
  end
end
