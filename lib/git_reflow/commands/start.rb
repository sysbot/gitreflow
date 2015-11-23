desc 'Start will create a new feature branch and setup remote tracking'
long_desc <<LONGTIME
  Performs the following:\n
  \t$ git pull origin <current_branch>\n
  \t$ git push origin <current_branch>:refs/heads/[new_feature_branch]\n
  \t$ git checkout --track -b [new_feature_branch] origin/[new_feature_branch]\n
LONGTIME
arg_name '[new-feature-branch-name] - name of the new feature branch'
command :start do |c|
  c.desc 'Use an existing trello card as a reference'
  c.switch :trello

  c.action do |global_options, options, args|
    GitReflow::Hooks.run(:before_start)
    GitReflow.start(args[0])
    GitReflow::Hooks.run(:after_start)
  end
end
