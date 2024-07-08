function fish_prompt -d '[HH:MM] User@Hostname:Cwd (GitPrompt) [LastPipestatus] CmdDuration $'
    # Custom prompt contents
    set -l last_pipestatus $pipestatus[-1]
    set -l current_time (date "+%H:%M")
    set -l cwd (basename (pwd | string replace $HOME "~"))
    set -l cmd_duration (math -s0 "$CMD_DURATION / 1000")

    # Color mode
    set -l is_dark true

    # Lettepa full palette
    set -l lettepa_kurenai CB1B45
    set -l lettepa_nakabeni ED5A65
    set -l lettepa_aomidori 00AA90
    set -l lettepa_braomidori 47D2BC
    set -l lettepa_ruri 005CALF
    set -l lettepa_brruri 37B4FD
    set -l lettepa_chigusa 3A8FB7
    set -l lettepa_brchigusa 71DCEA
    set -l lettepa_tsutsuji E03C8A
    set -l lettepa_brtsutsuji FD67B8
    set -l lettepa_kohaku CA7A2C
    set -l lettepa_tamako F9BF45
    set -l lettepa_black 08192D
    set -l lettepa_brblack 24384F
    set -l lettepa_dimgrey 5C7186
    set -l lettepa_grey 728A9E
    set -l lettepa_brgrey 83A2B7
    set -l lettepa_white CCE0EC
    set -l lettepa_brwhite DFF3FF

    # Palette based on the color mode
    if $is_dark
        set -f red $lettepa_nakabeni
        set -f green $lettepa_braomidori
        set -f blue $lettepa_brruri
        set -f cyan $lettepa_brchigusa
        set -f magenta $lettepa_brtsutsuji
        set -f yellow $lettepa_tamako
        set -f bg $lettepa_black
        set -f bg0 $lettepa_brblack
        set -f fg0 $lettepa_brgrey
        set -f fg $lettepa_white
        set -f red0 $lettepa_kurenai
        set -f green0 $lettepa_aomidori
        set -f blue0 $lettepa_ruri
        set -f cyan0 $lettepa_chigusa
        set -f magenta0 $lettepa_tsutsuji
        set -f yellow0 $lettepa_kohaku
    else
        set -f red $lettepa_kurenai
        set -f green $lettepa_aomidori
        set -f blue $lettepa_ruri
        set -f cyan $lettepa_chigusa
        set -f magenta $lettepa_tsutsuji
        set -f yellow $lettepa_kohaku
        set -f bg $lettepa_brwhite
        set -f bg0 $lettepa_white
        set -f fg0 $lettepa_dimgrey
        set -f fg $lettepa_brblack
        set -f red0 $lettepa_nakabeni
        set -f green0 $lettepa_braomidori
        set -f blue0 $lettepa_brruri
        set -f cyan0 $lettepa_brchigusa
        set -f magenta0 $lettepa_brtsutsuji
        set -f yellow0 $lettepa_tamako
    end
    set -l ignore $lettepa_grey

    # git prompt settings
    set -g __fish_git_prompt_showcolorhints true
    set -g __fish_git_prompt_showdirtystate true
    set -g __fish_git_prompt_showuntrackedfiles true
    set -g __fish_git_prompt_show_informative_status true
    set -g __fish_git_prompt_showupstream informative
    set -g __fish_git_prompt_describe_style branch

    # git prompt clean state
    set -g __fish_git_prompt_char_cleanstate ''
    set -g __fish_git_prompt_color_cleanstate $green

    # git prompt dirty states
    set -g __fish_git_prompt_char_dirtystate '?'
    set -g __fish_git_prompt_char_invalidstate '*'
    set -g __fish_git_prompt_char_stagedstate '+'
    set -g __fish_git_prompt_color_dirtystate $yellow
    set -g __fish_git_prompt_color_invalidstate $red
    set -g __fish_git_prompt_color_stagedstate $green

    # git prompt untracked
    set -g __fish_git_prompt_char_untrackedfiles '!'
    set -g __fish_git_prompt_color_untrackedfiles $magenta

    # git prompt colors
    set -g __fish_git_prompt_color $fg0
    set -g __fish_git_prompt_color_branch $cyan
    set -g __fish_git_prompt_color_branch_detached $magenta
    set -g __fish_git_prompt_color_branch_dirty $yellow
    set -g __fish_git_prompt_color_branch_staged $green

    # current time
    set_color $fg0
    printf "[%s] " $current_time

    # username
    set_color $magenta
    echo -n $USER

    # @ sep
    set_color $ignore
    echo -n '@'

    # hostname
    set_color $green
    echo -n $hostname

    # : sep
    set_color $ignore
    echo -n ':'

    # cwd
    set_color $blue
    echo -n $cwd

    # git branch
    set_color $fg0
    printf '%s ' (fish_git_prompt)

    # last pipestatus
    if test ! $last_pipestatus = 0
        set_color $red --bold
        printf '[%s] ' $last_pipestatus
    end

    # cmd duration
    if test ! $cmd_duration = 0
        set_color $fg0
        set -l year (math -s0 "$cmd_duration / (60 * 60 * 24 * 30 * 12)")
        set -l month (math -s0 "$cmd_duration / (60 * 60 * 24 * 30) % 12")
        set -l day (math -s0 "$cmd_duration / (60 * 60 * 24) % 30")
        set -l hour (math -s0 "$cmd_duration / (60 * 60) % 24")
        set -l minute (math -s0 "$cmd_duration / 60 % 60")
        set -l second (math -s0 "$cmd_duration % 60")
        function print_non_zero
            if ! test $argv[1] = 0
                printf '%s%s' $argv[1] $argv[2]
            end
        end
        print_non_zero $year yr
        print_non_zero $month mo
        print_non_zero $day d
        print_non_zero $hour hr
        print_non_zero $minute min
        print_non_zero $second s
        echo -n ' '
    end

    # $ indicator
    set_color $green
    echo -n '$ '
    set_color normal
end
