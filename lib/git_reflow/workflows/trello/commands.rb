module TrelloWorkflow::Commands
  def start(feature_branch)
    GitReflow.setup_trello
    # Gather Next cards
    next_list = GitReflow.trello_next_list
    in_progress_list = GitReflow.trello_in_progress_list
    next_up_cards = next_list.cards.first(5)

    unless next_list.nil?
      selected = choose do |menu|
        menu.prompt = "Choose a task to start: "

        next_up_cards.each do |card|
          menu.choice("#{card.name} [#{card.short_id}]")
        end
      end

      selected_card_id = selected[/\[\d+\]/][1..-2]
      selected_card = next_up_cards.select {|card| card.short_id.to_s == selected_card_id.to_s }.first

      feature_branch = ask("Enter a branch name: ") if feature_branch.empty?

      super(branch_name)

      GitReflow::Config.set "branch.#{branch_name}.trello-card-id", selected_card.id.to_s, local: true
      GitReflow::Config.set "branch.#{branch_name}.trello-card-short-id", selected_card.short_id.to_s, local: true
      GitReflow::Config.set "branch.#{branch_name}.trello-task-name", selected_card.name.to_s, local: true

      GitReflow.say "Adding you as a member of card ##{selected_card.short_id}", :notice
      selected_card.add_member(GitReflow.current_trello_member)
      GitReflow.say "Moving card ##{selected_card.short_id} to 'In Progress' list", :notice
      selected_card.move_to_list( in_progress_list )
    end
  end
end
