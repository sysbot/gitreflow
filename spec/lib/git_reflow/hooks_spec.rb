require 'spec_helper'

describe GitReflow::Hooks do
  describe ".overrides" do
    specify { expect{ GitReflow::Hooks.overrides }.to have_run_command_silently 'git config --get-all reflow.hooks.overrides' }
  end

  describe ".before_setup" do
    subject { GitReflow::Hooks.before_setup }
    it      { expect{ subject }.to have_run_command_silently 'git config --get-all reflow.hooks.before-setup' }
  end

  describe ".after_setup" do
    subject { GitReflow::Hooks.after_setup }
    it      { expect{ subject }.to have_run_command_silently 'git config --get-all reflow.hooks.after-setup' }
  end

  describe ".before_start" do
    subject { GitReflow::Hooks.before_start }
    it      { expect{ subject }.to have_run_command_silently 'git config --get-all reflow.hooks.before-start' }
  end

  describe ".after_start" do
    subject { GitReflow::Hooks.after_start }
    it      { expect{ subject }.to have_run_command_silently 'git config --get-all reflow.hooks.after-start' }
  end

  describe ".before_review" do
    subject { GitReflow::Hooks.before_review }
    it      { expect{ subject }.to have_run_command_silently 'git config --get-all reflow.hooks.before-review' }
  end

  describe ".after_review" do
    subject { GitReflow::Hooks.after_review }
    it      { expect{ subject }.to have_run_command_silently 'git config --get-all reflow.hooks.after-review' }
  end

  describe ".before_deliver" do
    subject { GitReflow::Hooks.before_deliver }
    it      { expect{ subject }.to have_run_command_silently 'git config --get-all reflow.hooks.before-deliver' }
  end

  describe ".after_deliver" do
    subject { GitReflow::Hooks.after_deliver }
    it      { expect{ subject }.to have_run_command_silently 'git config --get-all reflow.hooks.after-deliver' }
  end

  describe ".perform(hook_name)" do
    let(:loader) { double() }
    subject { GitReflow::Hooks.perform(:after_setup) }

    before do
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:executable?).and_return(true)
      allow(GitReflow::Hooks).to receive(:load).and_return(loader)
    end

    context "when no hook has been configured" do
      before { allow(GitReflow::Hooks).to receive(:after_setup).and_return([]) }
      it "doesn't load any files" do
        expect(GitReflow::Hooks).to_not receive(:load)
        subject
      end
    end

    context "when only one hook has been configured" do
      before { allow(GitReflow::Hooks).to receive(:after_setup).and_return(['awesomefile.rb']) }
      it "loads only one file" do
        expect(GitReflow::Hooks).to receive(:load).once.with('awesomefile.rb')
        subject
      end
    end

    context "when multiple hooks have been configured" do
      before { allow(GitReflow::Hooks).to receive(:after_setup).and_return(['awesomefile.rb', 'another_awesomefile.rb']) }
      it "loads only one file" do
        expect(GitReflow::Hooks).to receive(:load).once.with('awesomefile.rb')
        expect(GitReflow::Hooks).to receive(:load).once.with('another_awesomefile.rb')
        subject
      end
    end

    context "when the provided hook doesn't correspond to an existing file" do
      before do
        allow(GitReflow::Hooks).to receive(:after_setup).and_return(['dud.rb'])
        allow(File).to receive(:exist?).and_return(false)
      end
      it "doesn't load any file" do
        expect(GitReflow::Hooks).to_not receive(:load)
        subject
      end
    end

    context "when the provided hook corresponds to an existing file but is not executable" do
      before do
        allow(GitReflow::Hooks).to receive(:after_setup).and_return(['inconceivable.rb'])
        allow(File).to receive(:executable?).and_return(false)
      end
      it "doesn't load any file" do
        expect(GitReflow::Hooks).to_not receive(:load)
        subject
      end
    end
  end
end
