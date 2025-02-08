function fish_prompt -d '[HH:MM] User@Hostname:Cwd (GitPrompt) [LastPipestatus] CmdDuration $'
    # Custom prompt contents
    set -l last_pipestatus $pipestatus[-1]
    set -l current_time (date "+%H:%M")
    set -l cwd (basename (pwd | string replace $HOME "~"))
    set -l cmd_duration (math -s0 "$CMD_DURATION / 1000")

    # Sync with OS
    #
    # If enable this feature, the highlighting colors are set to the colors
    # defined by the terminal. This is helpful when the terminal is able to
    # switch its color scheme based on the OS appearance (or 'color mode').
    #
    # It's recommended to use the corresponding terminal port of Lettepa when
    # using this feature.
    set -l sync_with_os true

    # Color mode
    set -l is_dark true

    # Lettepa full palette
    set -l lettepa_kachi 08192d
    set -l lettepa_kon 0f2540
    set -l lettepa_keshizumi 434343
    set -l lettepa_nibi 656765
    set -l lettepa_hai 828282
    set -l lettepa_ginnezumi 91989f
    set -l lettepa_shironezumi bdc0ba
    set -l lettepa_shironeri fcfaf2
    set -l lettepa_nakabeni db4d6d
    set -l lettepa_kurenai cb1b45
    set -l lettepa_mizuasagi 66bab7
    set -l lettepa_seiheki 268785
    set -l lettepa_tsuyukusa 2ea9df
    set -l lettepa_ruri 005caf
    set -l lettepa_wasurenagusa 7db9de
    set -l lettepa_chigusa 3a8fb7
    set -l lettepa_momo f596aa
    set -l lettepa_tsutsuji e03c8a
    set -l lettepa_hanaba f7c242
    set -l lettepa_chojicha 96632e

    # Palette corresponding to the OS appearance
    if $sync_with_os
        # Main colors
        set -f bg black
        set -f bg0 brblack
        set -f ignore 747574 # a mix of 'nibi' and 'hai'
        set -f fg0 white
        set -f fg brwhite
        # Primary accent colors
        set -f red brred
        set -f green brgreen
        set -f blue brblue
        set -f cyan brcyan
        set -f magenta brmagenta
        set -f yellow bryellow
        # Secondary accent colors
        set -f red0 red
        set -f green0 green
        set -f blue0 blue
        set -f cyan0 cyan
        set -f magenta0 magenta
        set -f yellow0 yellow
    else
        # Palette based on the color mode
        if $is_dark
            # Main colors
            set -f bg $lettepa_kachi
            set -f bg0 $lettepa_kon
            set -f ignore $lettepa_nibi
            set -f fg0 $lettepa_ginnezumi
            set -f fg $lettepa_shironezumi
            # Primary accent colors
            set -f red $lettepa_nakabeni
            set -f green $lettepa_mizuasagi
            set -f blue $lettepa_tsuyukusa
            set -f cyan $lettepa_wasurenagusa
            set -f magenta $lettepa_momo
            set -f yellow $lettepa_hanaba
            # Secondary accent colors
            set -f red0 $lettepa_kurenai
            set -f green0 $lettepa_seiheki
            set -f blue0 $lettepa_ruri
            set -f cyan0 $lettepa_chigusa
            set -f magenta0 $lettepa_tsutsuji
            set -f yellow0 $lettepa_chojicha
        else
            # Main colors
            set -f bg $lettepa_shironeri
            set -f bg0 $lettepa_shironezumi
            set -f ignore $lettepa_hai
            set -f fg0 $lettepa_keshizumi
            set -f fg $lettepa_kon
            # Primary accent colors
            set -f red $lettepa_kurenai
            set -f green $lettepa_seiheki
            set -f blue $lettepa_ruri
            set -f cyan $lettepa_chigusa
            set -f magenta $lettepa_tsutsuji
            set -f yellow $lettepa_chojicha
            # Secondary accent colors
            set -f red0 $lettepa_nakabeni
            set -f green0 $lettepa_mizuasagi
            set -f blue0 $lettepa_tsuyukusa
            set -f cyan0 $lettepa_wasurenagusa
            set -f magenta0 $lettepa_momo
            set -f yellow0 $lettepa_hanaba
        end
    end

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
        set_color normal
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
