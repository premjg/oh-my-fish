# name: cod

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l green (set_color green)
  set -l magenta (set_color magenta)
  set -l orange (set_color "#ff8700")
  set -l normal (set_color normal)
  set -l grey (set_color "#666666")

  set -l cwd (basename (prompt_pwd))
  set -l cwd_p "$green$cwd/"

  set -l os_icon "$orange✈"
  if [ uname = "Darwin" ]
    set -l os_icon "$orange"
  end

  if [ (_git_branch_name) ]
    set -l git_branch $grey(_git_branch_name)
    set git_info "$git_branch"

    if [ (_is_git_dirty) ]
      set git_info "$git_info$red●"
    end

    set git_info "$grey($git_info$grey) $normal"
  end

  set -l error_prompt " "
  if test $last_status != 0
    set error_prompt " $red✕$normal "
  end

  echo -n -s $os_icon " " $cwd_p $git_info $error_prompt
end

function fish_right_prompt
  set -l red (set_color "#ff0000")

  # Ruby 
  set ruby_info ""
  if type chruby >/dev/null 2>&1
    set ruby_version (chruby |grep \* |tr -d '* ruby-')
    if [ ruby_version != "" ]
      set ruby_info "$red◈ $ruby_version$normal"
    end
  end

  set -l blue (set_color blue)
  set -l grey (set_color "#666666")
  set -l normal (set_color normal)

  set -l time (date '+%H:%M')
  set -l time_info "$grey⧖ $time$normal"

  echo -n -s $ruby_info " " $time_info
end
